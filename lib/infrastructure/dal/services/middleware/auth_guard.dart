import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../domain/core/interfaces/utility.dart';
import '../../../navigation/routes.dart';
import '../../daos/printlog.dart';

class AuthGuardMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final bool hasToken = Utility().hasToken();
    final bool hasRefresh = Utility().hasRefreshToken();
    final bool isBiometricEnabled =
        GetStorage().read('isBiometricEnabled') == true;
    final neverEnableBiometric =
        GetStorage().read('neverEnableBiometric') == true;

    printLog('hasToken: $hasToken');
    printLog('hasRefresh: $hasRefresh');
    printLog('isBiometricEnabled: $isBiometricEnabled');
    printLog('neverEnableBiometric: $neverEnableBiometric');

    final bool isTokenInvalid = !hasToken || Utility().isTokenExpired();
    printLog('isTokenInvalid: $isTokenInvalid');

    if (isTokenInvalid) {
      return _getRedirectRoute(
          hasRefresh, isBiometricEnabled, neverEnableBiometric);
    }

    return null;
  }

  RouteSettings _getRedirectRoute(
      bool hasRefresh, bool isBiometricEnabled, bool neverEnableBiometric) {
    if (neverEnableBiometric) {
      return RouteSettings(name: Routes.LOGIN);
    }

    return (hasRefresh && isBiometricEnabled)
        ? RouteSettings(name: Routes.ONBOARDING)
        : RouteSettings(name: Routes.LOGIN);
  }
}
