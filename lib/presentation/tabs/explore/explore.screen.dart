import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../infrastructure/dal/daos/widgets/text_widget.dart';
import 'controllers/explore.controller.dart';

class ExploreScreen extends GetView<ExploreController> {
  const ExploreScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/kdrama/image3.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white30,
                      ),
                      child: Icon(
                        Icons.star_border_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white30,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white30,
                      ),
                      child: Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextWidget(
                        text: 'Title Name',
                        fontSize: 20,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextWidget(
                        text: 'Episode 1 - 12',
                        fontSize: 16,
                        textColor: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 6, right: 150),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white38,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6, bottom: 6, right: 100),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white38,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6, bottom: 6, right: 50),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white38,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6, bottom: 10),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white38,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: TextWidget(
                        text: 'More',
                        fontSize: 12,
                        textColor: Colors.white54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
