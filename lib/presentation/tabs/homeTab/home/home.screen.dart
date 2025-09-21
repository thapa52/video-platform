import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../../infrastructure/theme/app_colors.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final double bannerHeight = MediaQuery.of(context).size.width * 12 / 9;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// Sticky header (Search bar + Play Icon + VIP)
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Row(
                children: [
                  /// Play Icon
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.red,
                      size: 30,
                    ),
                  ),

                  /// Search bar
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2938),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          hintText: 'Search dramas...',
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// VIP Button
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF186),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.diamond, color: Colors.black, size: 18),
                        SizedBox(width: 4),
                        TextWidget(
                          text: 'VIP',
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Banner Image with Blur, Gradient, and Text
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  ClipRect(
                    child: Container(
                      height: bannerHeight,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/kdrama/image1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.black.withOpacity(0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: bannerHeight,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: "Shadows & Light",
                          textColor: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(137, 231, 0, 12),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: TextWidget(
                                    text: 'Featured',
                                    fontSize: 14,
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(137, 231, 0, 12),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: TextWidget(
                                    text: 'Exclusive',
                                    fontSize: 14,
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: TextWidget(
                            text:
                                "A supernatural drama where light and darkness collide. A photographer discovers her camera can capture more that just...",
                            textColor: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "2024",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    Text(
                                      "10 Episodes",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "Fantasy",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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

            /// Body Content
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 12),

                  /// Trending Now
                  if (controller.trendingNow.isNotEmpty) ...[
                    controller.sectionHeader("Trending Now"),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.trendingNow.length,
                        itemBuilder: (context, index) {
                          double itemWidth =
                              (MediaQuery.of(context).size.width - 50) / 3;
                          return controller.imageContainer(
                              itemWidth, controller.trendingNow[index]);
                        },
                      ),
                    ),
                  ],

                  /// Recommended
                  if (controller.recommended.isNotEmpty) ...[
                    controller.sectionHeader("Recommended for You"),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.recommended.length,
                        itemBuilder: (context, index) {
                          double itemWidth =
                              (MediaQuery.of(context).size.width - 50) / 3;
                          return controller.imageContainer(
                              itemWidth, controller.recommended[index]);
                        },
                      ),
                    ),
                  ],

                  /// Exclusive Content
                  if (controller.exclusive.isNotEmpty) ...[
                    controller.sectionHeader("Exclusive Content"),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.exclusive.length,
                        itemBuilder: (context, index) {
                          double itemWidth =
                              (MediaQuery.of(context).size.width - 50) / 3;
                          return controller.imageContainer(
                              itemWidth, controller.exclusive[index]);
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
