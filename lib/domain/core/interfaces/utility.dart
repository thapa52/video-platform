import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../infrastructure/dal/daos/printlog.dart';
import '../../../infrastructure/dal/daos/setStorage/storage.dart';
import '../../../infrastructure/dal/daos/widgets/snackbar_widget.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../presentation/tabs/homeTab/home/controllers/home.controller.dart';
import '../../../presentation/tabs/scheduleTab/schedule/controllers/schedule.controller.dart';

class Utility {
  Future manageAuthentication(res) async {
    final token = res['access_token'] ?? '';
    final refreshToken = res['refresh_token'] ?? '';
    final tokenType = res['token_type'] ?? '';
    final expiresIn = res['expires_in'] ?? 0;
    Storage().setToken(token: token);
    Storage().setRefreshToken(refreshToken: refreshToken);
    Storage().setTokenType(tokenType: tokenType);
    Storage().setExpiresIn(expiresIn: expiresIn);
  }

  bool hasToken() {
    final token = GetStorage().read('token');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  bool hasRefreshToken() {
    final refreshToken = GetStorage().read('refreshToken');
    if (refreshToken == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isTokenExpired() {
    bool expired = isAccessTokenExpired(GetStorage().read('token'));
    if (expired) {
      return true;
    } else {
      return false;
    }
  }

  bool isAccessTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future<void> logOut() async {
    final refreshToken = GetStorage().read('refreshToken');
    final isBiometricEnabled = GetStorage().read('isBiometricEnabled');
    final neverEnableBiometric = GetStorage().read('neverEnableBiometric');

    await GetStorage().erase();

    if (refreshToken != null) {
      await Storage().setRefreshToken(refreshToken: refreshToken);
    }
    if (isBiometricEnabled != null) {
      await Storage()
          .setIsBiometricEnabled(isBiometricEnabled: isBiometricEnabled);
    }
    if (neverEnableBiometric != null) {
      await Storage()
          .setNeverEnableBiometric(neverEnableBiometric: neverEnableBiometric);
    }

    Get.offAllNamed(Routes.DASHBOARD);
    SnackbarWidget(message: 'You are logged out');
  }

  String todaysDate() {
    String formattedDate = DateFormat('MMMM d, y').format(DateTime.now());
    return formattedDate;
  }

  String getUtcDateOnly([DateTime? dateTime]) {
    final dt = dateTime ?? DateTime.now();
    printLog('getUtcDateOnly dateTime $dt');
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  String getInitials(
      {String? fullName,
      String? firstName,
      String? lastName,
      bool showFullInitials = true}) {
    String combinedName = '';

    if (fullName != null && fullName.trim().isNotEmpty) {
      combinedName = fullName.trim();
    } else if ((firstName?.isNotEmpty ?? false) ||
        (lastName?.isNotEmpty ?? false)) {
      combinedName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    } else {
      return '';
    }

    final parts = combinedName.split(RegExp(r'\s+'));

    if (parts.isEmpty) return '';

    if (showFullInitials) {
      return parts.map((e) => e[0].toUpperCase()).take(2).join(); // e.g., KS
    } else {
      return parts[0][0].toUpperCase(); // e.g., K
    }
  }

  String getFullDate(String dateTimeString, {bool useSlashes = true}) {
    final parsed = DateTime.parse(dateTimeString);
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    final year = parsed.year;

    return useSlashes ? '$month/$day/$year' : '$year-$month-$day';
  }

  String getTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return '-'; // or any fallback like 'N/A'
    }

    try {
      // Check for time-only format like "22:16"
      if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(dateTimeString)) {
        final parts = dateTimeString.split(':');
        int hour = int.parse(parts[0]);
        final minute = parts[1].padLeft(2, '0');
        final period = hour >= 12 ? 'PM' : 'AM';

        hour = hour % 12;
        hour = hour == 0 ? 12 : hour;

        return '$hour:$minute $period';
      }

      // Default case for full DateTime strings
      final parsed = DateTime.parse(dateTimeString);
      int hour = parsed.hour;
      final minute = parsed.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';

      hour = hour % 12;
      hour = hour == 0 ? 12 : hour; // convert hour '0' to '12'

      return '$hour:$minute $period';
    } catch (e) {
      return '-'; // fallback in case parsing fails
    }
  }

  String getTimeInHMS(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  bool isToday(String dateTimeString) {
    final parsed = DateTime.parse(dateTimeString);
    final now = DateTime.now();
    return parsed.year == now.year &&
        parsed.month == now.month &&
        parsed.day == now.day;
  }

  DateTime parseDateTime(String dateTimeStr) {
    try {
      // Try full ISO format first
      return DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
          .parseUTC(dateTimeStr)
          .toLocal();
    } catch (e) {
      // Fallback to simple date format
      return DateFormat("yyyy-MM-dd").parse(dateTimeStr);
    }
  }

  int getDay(String dateTimeStr) {
    final dateTime = parseDateTime(dateTimeStr);
    return dateTime.day;
  }

  int getMonthNumber(String dateTimeStr) {
    final dateTime = parseDateTime(dateTimeStr);
    return dateTime.month;
  }

  int getYear(String dateTimeStr) {
    final dateTime = parseDateTime(dateTimeStr);
    return dateTime.year;
  }

  String getMonthName(String dateTimeStr) {
    final dateTime = parseDateTime(dateTimeStr);
    return DateFormat('MMM').format(dateTime); // e.g. Apr
  }

  reloadSchedule() {
    try {
      final controller = Get.find<ScheduleController>();
      controller.refreshSchedule();
    } catch (e) {
      printLog('Schedule not refreshed');
    }
  }

  reloadActiveSite() {
    try {
      final controller = Get.find<HomeController>();
      // controller.getUserActiveSite();
    } catch (e) {
      printLog('Active site not refreshed');
    }
  }
}
