import '../../../../domain/core/interfaces/utility.dart';
import '../../daos/printlog.dart';
import 'api_service.dart';

class ApiResponse {
  Future<Map<String, dynamic>> getSitesList() async {
    try {
      final response = await ApiService().get('sites');
      printLog('getSitesList response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          return response['data'];
        } else {
          printLog('getSitesList data not found');
          return {};
        }
      } else {
        printLog('getSitesList status=false');
        return {};
      }
    } catch (e) {
      printLog('Error while fetching site list -> $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getUserActiveSite() async {
    try {
      final response = await ApiService().get('sites/users-active-site');
      printLog('getUserActiveSite response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          return response['data'];
        } else {
          printLog('getUserActiveSite data not found');
          return {};
        }
      } else {
        printLog('getUserActiveSite status=false');
        return {};
      }
    } catch (e) {
      printLog('Error while fetching user active site -> $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getUserList() async {
    try {
      final response = await ApiService().get('users');
      printLog('getUserList response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          return response['data'];
        } else {
          printLog('getUserList data not found');
          return {};
        }
      } else {
        printLog('getUserList status=false');
        return {};
      }
    } catch (e) {
      printLog('Error while fetching user list -> $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getUserInfoById(userId) async {
    try {
      final response = await ApiService().get('users/$userId');
      printLog('getUserList response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          return response['data'];
        } else {
          printLog('getUserInfoById data not found');
          return {};
        }
      } else {
        printLog('getUserInfoById status=false');
        return {};
      }
    } catch (e) {
      printLog('Error while fetching user info by id -> $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getSiteDetailsById(siteId) async {
    try {
      final response = await ApiService().get('sites/$siteId');
      printLog('getSiteDetailsById response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          return response['data'];
        } else {
          printLog('getSiteDetailsById data not found');
          return {};
        }
      } else {
        printLog('getSiteDetailsById status=false');
        return {};
      }
    } catch (e) {
      printLog('Error while fetching site list -> $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getCheckInRecordUser(siteId) async {
    printLog('getCheckInRecordUser siteId-> $siteId');
    try {
      final response =
          await ApiService().get('check-in-record/user?siteId=$siteId');
      printLog('getCheckInRecordUser response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          return response['data'];
        } else {
          printLog('check-in-record/user data not found');
          return {};
        }
      } else {
        printLog('check-in-record/user status=false');
        return {};
      }
    } catch (e) {
      printLog('Error while fetching check-in-record/user -> $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getCheckInTimeShift(
      {DateTime? dateTime, required String status}) async {
    final String formattedDate = Utility().getUtcDateOnly(dateTime);
    printLog('timeShift formattedDate $formattedDate');
    try {
      final response = await ApiService().get(
          'check-in-record/time-sheet?filterStatus=${status.toUpperCase()}&date=$formattedDate');
      printLog('timeShift response $response');
      if (response['status'] == true) {
        final List<Map<String, dynamic>> list =
            List<Map<String, dynamic>>.from(response['data']);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getShiftMine() async {
    try {
      final response = await ApiService().get('shift/mine');
      printLog('getShiftMine response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          List shifts = response['data'];
          return shifts.map((shift) => shift as Map<String, dynamic>).toList();
        } else {
          printLog('getShiftMine data not found');
          return [];
        }
      } else {
        printLog('getShiftMine status = false');
        return [];
      }
    } catch (e) {
      printLog('Error while fetching shift mine -> $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getShiftTeam() async {
    try {
      final response = await ApiService().get('shift/team');
      printLog('getShiftTeam response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          List shifts = response['data'];
          return shifts.map((shift) => shift as Map<String, dynamic>).toList();
        } else {
          printLog('getShiftTeam data not found');
          return [];
        }
      } else {
        printLog('getShiftTeam status = false');
        return [];
      }
    } catch (e) {
      printLog('Error while fetching shift team -> $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getShiftToday() async {
    try {
      final response = await ApiService().get('shift/today');
      printLog('getShiftToday response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          List shifts = response['data'];
          return shifts.map((shift) => shift as Map<String, dynamic>).toList();
        } else {
          printLog('getShiftToday data not found');
          return [];
        }
      } else {
        printLog('getShiftToday status = false');
        return [];
      }
    } catch (e) {
      printLog('Error while fetching shift today -> $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getShiftById(id) async {
    try {
      final response = await ApiService().get('shift/$id');
      printLog('getShiftById response $response');
      if (response['status'] == true) {
        if (response.containsKey('data') && response['data'] != null) {
          return response['data'];
        } else {
          printLog('getShiftById data not found');
          return {};
        }
      } else {
        printLog('getShiftById status = false');
        return {};
      }
    } catch (e) {
      printLog('Error while fetching shift id -> $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getNotifications(
      {required String status}) async {
    try {
      final response =
          await ApiService().get('notification?status=${status.toString()}');
      printLog('getNotifications response $response');
      if (response['status'] == true) {
        return response['data'];
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}
