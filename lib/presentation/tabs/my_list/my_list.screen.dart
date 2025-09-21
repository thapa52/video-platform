import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../infrastructure/theme/app_colors.dart';
import 'controllers/my_list.controller.dart';

class MyListScreen extends GetView<MyListController> {
  const MyListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
          backgroundColor: Colors.black,
          elevation: 0,
          toolbarHeight: 100,
          actions: [
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2938),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Newest'),
                    SizedBox(width: 10),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.list,
                color: Colors.blueGrey,
                size: 30,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E2938), // Background color of tab
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    textScaler: TextScaler.linear(1.0),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bookmark_border_rounded),
                            SizedBox(width: 10),
                            Text(
                              'BookMarked (3)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          children: [
                            Icon(Icons.file_download_outlined),
                            SizedBox(width: 10),
                            Text(
                              'Downloads (2)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Wrap(
                  spacing: 10,
                  runSpacing: 20,
                  children: List.generate(
                    controller.bannerItems.length,
                    (index) {
                      double itemWidth =
                          (MediaQuery.of(context).size.width - 30) / 2;
                      // 10 padding left + 10 padding right + 10 spacing between banners = 30
                      return Container(
                          height: 120, // adjust height as needed
                          width: itemWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(
                                controller.bannerItems[index].image,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.bookmark,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              controller.bannerItems[index].trending == true
                                  ? Positioned(
                                      left: 10,
                                      top: 10,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              134, 231, 0, 12),
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                              Center(
                                child: TextWidget(
                                  text: controller.bannerItems[index].name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: TextWidget(
                                  text: controller.bannerItems[index].episodes,
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ));
                    },
                  )),
            ),
            const Center(
              child: Text(
                'Tab 2',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
