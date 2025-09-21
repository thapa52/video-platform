import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/dal/daos/printlog.dart';
import '../../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../../infrastructure/theme/app_colors.dart';

class HomeController extends GetxController {
  // final FocusNode searchFocusNode = FocusNode();
  // final userRole = ''.obs;
  // final activeSiteLoading = false.obs;
  // final siteLoading = false.obs;
  // final shiftLoading = false.obs;
  // final userActiveSite = {}.obs;
  // final siteList = [].obs;
  // final shift = [].obs;
  // final filterSiteList = [].obs;
  // final siteSearchQuery = ''.obs;
  // ScrollController scrollController = ScrollController();

  // Future<void> initHome() async {
  //   userRole.value = GetStorage().read('userRole').toString().toLowerCase();
  //   shiftMine();
  //   getUserActiveSite();
  //   getSiteList();
  // }

  // Future<void> getUserActiveSite() async {
  //   activeSiteLoading.value = true;
  //   try {
  //     final response = await ApiResponse().getUserActiveSite();
  //     printLog('active site response $response');
  //     userActiveSite.value = {};
  //     if (response.isNotEmpty) {
  //       userActiveSite.addAll(response);
  //     }
  //     activeSiteLoading.value = false;
  //   } catch (e) {
  //     activeSiteLoading.value = false;
  //     printLog('Error while fetching site list: $e');
  //   }
  // }

  // Future<void> getSiteList() async {
  //   siteLoading.value = true;
  //   try {
  //     final response = await ApiResponse().getSitesList();
  //     printLog('site response $response');
  //     siteList.value = [];
  //     if (response.isNotEmpty) {
  //       siteList.addAll(response['content']);
  //       printLog('siteList $siteList');
  //     }
  //     siteLoading.value = false;
  //   } catch (e) {
  //     siteLoading.value = false;
  //     printLog('Error while fetching site list: $e');
  //   }
  // }

  // Future<void> shiftMine() async {
  //   shiftLoading.value = true;
  //   try {
  //     final res = await ApiResponse().getShiftMine();
  //     printLog('res mine $res');
  //     shift.value = [];
  //     if (res.isNotEmpty) {
  //       shift.addAll(res);
  //     }
  //     shiftLoading.value = false;
  //   } catch (e) {
  //     shiftLoading.value = false;
  //     printLog('Error while fetching today shift: $e');
  //   }
  // }

  // Future<void> filteredSiteList() async {
  //   printLog('Filtering site list...');
  //   siteLoading.value = true;
  //   try {
  //     final query = siteSearchQuery.value;
  //     final response = await ApiService().get('sites?searchKeyword=$query');
  //     if (query.isEmpty) {
  //       printLog('filtered site response $response');
  //       filterSiteList.value = response['data']['content'];
  //       printLog('filtered siteList $filterSiteList');
  //     } else {
  //       filterSiteList.value = response['data']['content'].where((site) {
  //         final siteName = site['siteName'].toString().toLowerCase();
  //         return siteName.contains(query.toLowerCase());
  //       }).toList();
  //       printLog('filtered siteList $filterSiteList');
  //     }
  //     siteLoading.value = false;
  //   } catch (e) {
  //     siteLoading.value = false;
  //   }
  // }

  final trendingNow = <Images>[].obs;
  final recommended = <Images>[].obs;
  final exclusive = <Images>[].obs;

  Future<void> fetchTrendingImage() async {
    trendingNow.assignAll([
      Images(
        image: 'assets/images/kdrama/banner3.jpg',
        name: 'Goblin',
        episodes: '20',
        isTrending: true,
      ),
      Images(
        image: 'assets/images/kdrama/image4.webp',
        name: 'Business Proposal',
        episodes: '12',
        isTrending: true,
      ),
      Images(
        image: 'assets/images/kdrama/banner4.jpg',
        name: 'Squid Game',
        episodes: '16',
      ),
      Images(
        image: 'assets/images/kdrama/image6.jpg',
        name: 'Start-Up',
        episodes: '16',
      ),
    ]);
  }

  Future<void> fetchRecomendedImage() async {
    recommended.assignAll([
      Images(
        image: 'assets/images/kdrama/image2.jpg',
        name: 'Goblin',
        episodes: '20',
        isTrending: true,
        isExclusive: true,
      ),
      Images(
        image: 'assets/images/kdrama/banner2.jpg',
        name: 'Business Proposal',
        episodes: '12',
      ),
      Images(
        image: 'assets/images/kdrama/image3.jpg',
        name: 'Squid Game',
        episodes: '16',
        isTrending: true,
      ),
      Images(
        image: 'assets/images/kdrama/image5.jpg',
        name: 'Start-Up',
        episodes: '16',
      ),
    ]);
  }

  Future<void> fetchExclusiveImage() async {
    exclusive.assignAll([
      Images(
        image: 'assets/images/kdrama/image1.jpg',
        name: 'Goblin',
        episodes: '20',
        isTrending: true,
        isExclusive: true,
        exclusiveOnly: true,
      ),
      Images(
        image: 'assets/images/kdrama/image7.jpg',
        name: 'Start-up',
        episodes: '16',
        isTrending: true,
        isExclusive: true,
        exclusiveOnly: true,
      ),
    ]);
  }

  Widget imageContainer(width, data) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 120,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(
            data.image,
          ),
          fit: BoxFit.cover,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          data.isTrending == true
              ? Positioned(
                  left: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(134, 231, 0, 12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextWidget(
                      text: 'Trending',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : Container(),
          data.isExclusive == true
              ? Positioned(
                  left: 6,
                  top: 26,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(134, 231, 0, 12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.diamond,
                          size: 10,
                        ),
                        TextWidget(
                          text: 'Exclusive',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: TextWidget(
              text: data.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: TextWidget(
              text: '${data.episodes} episodes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (data.exclusiveOnly == true)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Colors.black.withOpacity(0.7), // adjust opacity as needed
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.diamond,
                        size: 20,
                        color: AppColors.red[550],
                      ),
                      TextWidget(
                        text: 'Exclisuve Only',
                        textAlign: TextAlign.center,
                        fontSize: 14,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget sectionHeader(title) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: title,
            textColor: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshHome() async {
    printLog('refresh home');
    // await initHome();
    fetchTrendingImage();
    fetchRecomendedImage();
    fetchExclusiveImage();
  }

  @override
  void onInit() {
    super.onInit();
    refreshHome();
    // initHome();
    // scrollController.addListener(() async {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {}
    // });
  }

  @override
  void onReady() {
    // debounce(siteSearchQuery, (_) {
    //   filteredSiteList();
    // }, time: Duration(milliseconds: 300));
    super.onReady();
  }

  @override
  void onClose() {
    // searchFocusNode.dispose();
    super.onClose();
  }
}

class Images {
  final String image;
  final String name;
  final String episodes;
  bool? isTrending = false;
  bool? isExclusive = false;
  bool? exclusiveOnly = false;

  Images({
    required this.image,
    required this.name,
    required this.episodes,
    this.isTrending,
    this.isExclusive,
    this.exclusiveOnly,
  });
}
