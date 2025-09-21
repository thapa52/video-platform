import 'package:get/get.dart';

import '../../../../infrastructure/dal/daos/printlog.dart';

class MyListController extends GetxController {
  final bannerItems = <BannerItem>[].obs;

  Future<void> fetchBannerImage() async {
    bannerItems.assignAll([
      BannerItem(
          image: 'assets/images/kdrama/banner3.jpg',
          name: 'Goblin',
          episodes: '12',
          trending: true),
      BannerItem(
          image: 'assets/images/kdrama/banner4.jpg',
          name: 'Squid Game',
          episodes: '12'),
      BannerItem(
          image: 'assets/images/kdrama/banner1.jpg',
          name: 'Business Proposal',
          episodes: '12'),
    ]);
  }

  Future<void> refreshMyList() async {
    printLog('refresh home');
    fetchBannerImage();
  }

  @override
  void onInit() {
    super.onInit();
    refreshMyList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class BannerItem {
  final String image;
  final String name;
  final String episodes;
  bool? trending = false;

  BannerItem(
      {required this.image,
      required this.name,
      required this.episodes,
      this.trending});
}
