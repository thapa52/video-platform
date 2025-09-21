import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../daos/setStorage/storage.dart';

class NoteController extends GetxController {
  var noteList = <Map<String, String>>[].obs;
  var editingNoteId = ''.obs;
  var noteText = ''.obs;
  final textController = TextEditingController();

  @override
  void onInit() {
    loadNotes();
    super.onInit();
  }

  // Load notes from storage
  Future<void> loadNotes() async {
    // Retrieve the stored notes (if any)
    final storedNotes = GetStorage().read<List<dynamic>>('noteList');
    if (storedNotes != null) {
      // Convert dynamic data to a List of Maps
      noteList.value = storedNotes.map((item) {
        return Map<String, String>.from(item as Map);
      }).toList();
    }
  }

  // Save notes to storage
  Future<void> saveNotes() async {
    Storage().setNoteList(noteList: noteList);
  }

  // Add a new note
  Future<void> addNote(String siteId, String noteContent) async {
    // Check if the note already exists
    final existingNoteIndex =
        noteList.indexWhere((note) => note['noteId'] == siteId);
    if (existingNoteIndex == -1) {
      // Add a new note if it doesn't exist
      noteList.add({
        'noteId': siteId,
        'noteContent': noteContent,
      });
    } else {
      // If the note exists, update the content
      noteList[existingNoteIndex]['noteContent'] = noteContent;
    }
    await saveNotes(); // Save to storage
    editingNoteId.value = '';
  }

  Future<void> updateNote(String siteId, String noteContent) async {
    final index = noteList.indexWhere((note) => note['noteId'] == siteId);
    if (index != -1) {
      // Update the existing note's content
      noteList[index]['noteContent'] = noteContent;
    } else {
      // If the note doesn't exist, add it as a new note
      noteList.add({
        'noteId': siteId,
        'noteContent': noteContent,
      });
    }
    await saveNotes(); // Save the updated notes to storage
    editingNoteId.value = '';
  }

  // Delete a note
  Future<void> deleteNote(String siteId) async {
    noteList.removeWhere((note) => note['noteId'] == siteId);
    await saveNotes(); // Save to storage
    editingNoteId.value = '';
  }

  // Start editing a note
  Future<void> startEditing(String siteId) async {
    final note = getNote(siteId);
    textController.text = note ?? ''; // set once when editing begins
    noteText.value = note ?? ''; // keep noteText in sync
    editingNoteId.value = siteId;
  }

  // Cancel editing
  Future<void> cancelEditing() async {
    editingNoteId.value = '';
  }

  // Check if the user is editing a note
  bool isEditing(String siteId) => editingNoteId.value == siteId;

  // Get a note by siteId
  String? getNote(String siteId) {
    final note = noteList.firstWhere(
      (note) => note['noteId'] == siteId,
      orElse: () => {},
    );
    return note.isNotEmpty ? note['noteContent'] : null;
  }
}
