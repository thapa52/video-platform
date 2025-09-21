import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import '../dal/services/middleware/auth_guard.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
      // middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
      binding: OnboardingControllerBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginControllerBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardControllerBinding(),
      // middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.JOB_ACTIVITY,
      page: () => const JobActivityScreen(),
      binding: JobActivityControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.TIME_TRACK,
      page: () => const TimeTrackScreen(),
      binding: TimeTrackControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.SCHEDULE,
      page: () => const ScheduleScreen(),
      binding: ScheduleControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.SITE_DETAILS,
      page: () => const SiteDetailsScreen(),
      binding: SiteDetailsControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_SETTING,
      page: () => const ProfileSettingScreen(),
      binding: ProfileSettingControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.PROFILE_MEMBER,
      page: () => const ProfileMemberScreen(),
      binding: ProfileMemberControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.ADD_SCHEDULE_SHIFT,
      page: () => const AddScheduleShiftScreen(),
      binding: AddScheduleShiftControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.SCHEDULE_DETAILS,
      page: () => const ScheduleDetailsScreen(),
      binding: ScheduleDetailsControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.HOME_SCHEDULE,
      page: () => const HomeScheduleScreen(),
      binding: HomeScheduleControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.PERSONAL_INFORMATION,
      page: () => const PersonalInformationScreen(),
      binding: PersonalInformationControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsScreen(),
      binding: NotificationsControllerBinding(),
      middlewares: [AuthGuardMiddleware()],
    ),
    GetPage(
      name: Routes.EXPLORE,
      page: () => const ExploreScreen(),
      binding: ExploreControllerBinding(),
    ),
    GetPage(
      name: Routes.MY_LIST,
      page: () => const MyListScreen(),
      binding: MyListControllerBinding(),
    ),
  ];
}
