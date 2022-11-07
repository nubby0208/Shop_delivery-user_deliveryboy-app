import 'package:flutter/material.dart';
import 'package:mighty_delivery/main/models/models.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mighty_delivery/main/utils/DataProviders.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'LoginScreen.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  List<WalkThroughItemModel> pages = getWalkThroughItems();
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(appStore.isDarkMode ? scaffoldColorDark : Colors.white, statusBarBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Text(language.skip, style: boldTextStyle(color: grey)).onTap(
            () async {
              await setValue(IS_FIRST_TIME, false);
              LoginScreen().launch(context, isNewTask: true, duration: Duration(milliseconds: 1000), pageRouteAnimation: PageRouteAnimation.Scale);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ).paddingOnly(top: 16, right: 16),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PageView(
        controller: pageController,
        children: List.generate(
          pages.length,
          (index) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(pages[index].image!, width: context.width(), height: context.height() * 0.4, fit: BoxFit.cover),
                    50.height,
                    Column(
                      children: [
                        Text(
                          pages[index].title!,
                          style: boldTextStyle(size: headingSize),
                          textAlign: TextAlign.center,
                        ).paddingOnly(left: 30, right: 30),
                        16.height,
                        Text(
                          pages[index].subTitle!,
                          textAlign: TextAlign.center,
                          style: secondaryTextStyle(size: 16),
                        ).paddingOnly(left: 30, right: 30),
                      ],
                    ),
                    16.height,
                  ],
                ),
              ),
            );
          },
        ),
        onPageChanged: (value) {
          currentPage = value;
          setState(() {});
        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.navigate_before, color: colorPrimary, size: 30).onTap(() {
            pageController.animateToPage(--currentPage, duration: Duration(milliseconds: 800), curve: Curves.easeInOut);
          }).visible(currentPage != 0),
          DotIndicator(
            pages: pages,
            pageController: pageController,
            indicatorColor: colorPrimary,
          ),
          currentPage != 2
              ? Icon(Icons.navigate_next, color: colorPrimary, size: 30).onTap(() {
                  pageController.animateToPage(++currentPage, duration: Duration(milliseconds: 800), curve: Curves.easeInOut);
                })
              : commonButton(
                  language.getStarted,
                  () async {
                    await setValue(IS_FIRST_TIME, false);
                    LoginScreen().launch(context, isNewTask: true, duration: Duration(milliseconds: 1000), pageRouteAnimation: PageRouteAnimation.Scale);
                  },
                ),
        ],
      ).paddingAll(16),
    );
  }
}
