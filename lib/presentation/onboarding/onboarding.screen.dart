import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../infrastructure/theme/app_colors.dart';
import 'controllers/onboarding.controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  List<Widget> onBoardSlideList(BuildContext context) {
    return [
      Image.asset(
        'assets/images/kdrama/image1.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/images/kdrama/image2.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/images/kdrama/image3.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/images/kdrama/image4.webp',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/images/kdrama/image5.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/images/kdrama/image6.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      Image.asset(
        'assets/images/kdrama/image7.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        elevation: 0,
        toolbarHeight: 0,
        title: const Text(''),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.black,
          systemNavigationBarDividerColor: AppColors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            children: [
              CarouselSlider(
                items: onBoardSlideList(context),
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  autoPlayCurve: Curves.easeInOut,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  onPageChanged: (index, reason) {
                    controller.currentIndex.value = index;
                  },
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('dashboard');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            width: 2,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: TextWidget(
                          text: 'Later',
                          fontSize: 14,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7000B),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      child: TextWidget(
                        text: 'Drama Kilat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextWidget(
                        text: 'Stream exclusive short dramas',
                        textColor: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextWidget(
                        text: 'Coming September 2024',
                        textColor: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Dots indicator
              Positioned(
                bottom: 20, // distance from bottom
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(180, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: TextWidget(
                        text: 'Login Now',
                      ),
                      // ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      child: TextWidget(
                        text: 'Join thousands of drama lovers worldwide',
                        textColor: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onBoardSlideList(context).length,
                          (index) {
                            final isActive =
                                controller.currentIndex.value == index;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width:
                                  isActive ? 20 : 6, // longer line when active
                              height: 6,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFFE7000B)
                                    : Colors.grey[300],
                                borderRadius:
                                    BorderRadius.circular(12), // pill shape
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
