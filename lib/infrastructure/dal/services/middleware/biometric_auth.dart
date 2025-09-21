import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  var isAuthenticated = false.obs;
  var isBiometricAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkBiometricAvailability();
  }

  Future<void> checkBiometricAvailability() async {
    try {
      bool canAuthenticate = await isBiometricSetup();
      isBiometricAvailable.value = canAuthenticate;
      print('isBiometricAvailable: $isBiometricAvailable');
    } catch (e) {
      print('Error checking biometrics: $e');
    }
  }

  Future<void> authenticate() async {
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      isAuthenticated.value = didAuthenticate;
    } catch (e) {
      print('Error during authentication: $e');
    }
  }

  Future<bool> isBiometricSetup() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      bool isSupported = await auth.isDeviceSupported();
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      return canCheck && isSupported && availableBiometrics.isNotEmpty;
    } catch (e) {
      print('Error checking biometric setup: $e');
      return false;
    }
  }
}
