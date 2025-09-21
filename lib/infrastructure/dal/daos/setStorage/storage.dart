import 'package:get_storage/get_storage.dart';

import '../printlog.dart';

class Storage {
  final storage = GetStorage();
  Future<void> setToken({required token}) async {
    await GetStorage().write('token', token);
    printLog('token -> ${GetStorage().read('token')}');
  }

  Future<void> setRefreshToken({required refreshToken}) async {
    await GetStorage().write('refreshToken', refreshToken);
    printLog('refreshToken -> ${GetStorage().read('refreshToken')}');
  }

  Future<void> setTokenType({required tokenType}) async {
    await GetStorage().write('tokenType', tokenType);
    printLog('tokenType -> ${GetStorage().read('tokenType')}');
  }

  Future<void> setExpiresIn({required expiresIn}) async {
    await GetStorage().write('expiresIn', expiresIn);
    printLog('expiresIn -> ${GetStorage().read('expiresIn')}');
  }

  Future<void> setUserInfo({required userInfo}) async {
    await GetStorage().write('userInfo', userInfo);
    printLog('userInfo -> ${GetStorage().read('userInfo')}');
    if (userInfo['userId'] != null) {
      setUserID(userId: userInfo['userId']);
    }
    if (userInfo['firstName'] != null && userInfo['lastName'] != null) {
      await setUserFirstName(userFirstName: userInfo['firstName']);

      await setUserLastName(userLastName: userInfo['lastName']);

      final userName = '${userInfo['firstName']} ${userInfo['lastName']}';

      await setUserName(userName: userName);
    }
    if (userInfo['role'] != null) {
      await setUserRole(userRole: userInfo['role']);
    }
    if (userInfo['email'] != null) {
      await setUserEmail(userEmail: userInfo['email']);
    }
    if (userInfo['contactNumber'] != null) {
      await setUserContact(userContact: userInfo['contactNumber']);
    }
  }

  Future<void> setUserID({required userId}) async {
    await GetStorage().write('userId', userId);
    printLog('userId -> ${GetStorage().read('userId')}');
  }

  Future<void> setUserFirstName({required userFirstName}) async {
    await GetStorage().write('userFirstName', userFirstName);
    printLog('userFirstName -> ${GetStorage().read('userFirstName')}');
  }

  Future<void> setUserLastName({required userLastName}) async {
    await GetStorage().write('userLastName', userLastName);
    printLog('userLastName -> ${GetStorage().read('userLastName')}');
  }

  Future<void> setUserName({required userName}) async {
    await GetStorage().write('userName', userName);
    printLog('userName -> ${GetStorage().read('userName')}');
  }

  Future<void> setUserEmail({required userEmail}) async {
    await GetStorage().write('userEmail', userEmail);
    printLog('userEmail -> ${GetStorage().read('userEmail')}');
  }

  Future<void> setUserRole({required userRole}) async {
    await GetStorage().write('userRole', userRole);
    printLog('userRole -> ${GetStorage().read('userRole')}');
  }

  Future<void> setUserContact({required userContact}) async {
    await GetStorage().write('userContact', userContact);
    printLog('userContact -> ${GetStorage().read('userContact')}');
  }

  Future<void> setNoteList({required noteList}) async {
    await GetStorage().write('noteList', noteList);
    printLog('noteList -> ${GetStorage().read('noteList')}');
  }

  Future<void> setIsBiometricEnabled({required isBiometricEnabled}) async {
    await GetStorage().write('isBiometricEnabled', isBiometricEnabled);
    printLog(
        'isBiometricEnabled -> ${GetStorage().read('isBiometricEnabled')}');
  }

  Future<void> setNeverEnableBiometric({required neverEnableBiometric}) async {
    await GetStorage().write('neverEnableBiometric', neverEnableBiometric);
    printLog(
        'neverEnableBiometric -> ${GetStorage().read('neverEnableBiometric')}');
  }
}
