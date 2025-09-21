import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../services/controllers/note_controller.dart';
import 'text_widget.dart';

class NoteWidget extends StatelessWidget {
  final String siteId;
  final NoteController controller = Get.find();

  NoteWidget({super.key, required this.siteId});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final id = siteId.toString();
        final note = controller.getNote(id);
        final isEdit = controller.isEditing(id);

        // If there's no note and the user isn't editing, show the "Add a note" prompt.
        if (note == null && !isEdit) {
          return buildAddPrompt();
        }

        // If the user is editing, show the input area.
        if (isEdit) {
          return buildInputArea(isEdit: note != null);
        }

        // Otherwise, display the existing note.
        return buildNoteDisplay(note!);
      },
    );
  }

  Widget buildAddPrompt() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () {
          controller.startEditing(siteId.toString());
        },
        child: Row(
          children: [
            Icon(
              Icons.add,
              color: AppColors.brand[700],
            ),
            SizedBox(width: 10),
            TextWidget(
              text: 'Add a note',
              textColor: AppColors.brand[700],
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputArea({required bool isEdit}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => TextField(
              controller: controller.textController,
              onChanged: (value) => controller.noteText.value = value.trim(),
              decoration: InputDecoration(
                hintText: "Add a note...",
                hintStyle: TextStyle(
                  color: AppColors.text,
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: controller.noteText.value.isNotEmpty
                        ? AppColors.gray[700]!
                        : AppColors.gray,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: controller.noteText.value.isNotEmpty
                        ? AppColors.gray[700]!
                        : AppColors.gray,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: controller.noteText.value.isNotEmpty
                        ? AppColors.gray[700]!
                        : AppColors.gray,
                  ),
                ),
              ),
              maxLines: null,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  controller.cancelEditing();
                  controller.textController.clear();
                },
                child: TextWidget(
                  text: 'Cancel',
                  textColor: AppColors.text,
                ),
              ),
              SizedBox(width: 10),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.noteText.value.isNotEmpty
                      ? () {
                          final note = controller.textController.text.trim();
                          if (note.isNotEmpty) {
                            if (isEdit) {
                              controller.updateNote(siteId.toString(), note);
                            } else {
                              controller.addNote(siteId.toString(), note);
                            }
                            controller.textController.clear();
                            controller.noteText.value = '';
                          }
                        }
                      : null, // disables the button if empty
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.noteText.value.isNotEmpty
                        ? AppColors.brand[700]
                        : AppColors.gray,
                  ),
                  child: TextWidget(
                    text: isEdit ? "Save" : "Add",
                    textColor: controller.noteText.value.isNotEmpty
                        ? AppColors.white
                        : AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNoteDisplay(String note) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(text: 'Notes'),
              Align(
                alignment: Alignment.topRight,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      controller.startEditing(siteId.toString());
                    } else if (value == 'delete') {
                      _confirmDelete(Get.context!);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.gray,
                width: 2,
              ),
              color: AppColors.white,
            ),
            child: TextWidget(
              text: note,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: "Delete this note?",
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: TextWidget(text: "Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.deleteNote(siteId.toString());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand[900]),
                  child: TextWidget(
                    text: "Delete",
                    textColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
