import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mighty_delivery/delivery/fragment/DProfileFragment.dart';
import 'package:mighty_delivery/delivery/screens/CreateTabScreen.dart';
import 'package:mighty_delivery/main/components/BodyCornerWidget.dart';
import 'package:mighty_delivery/main/screens/NotificationScreen.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../main/network/RestApis.dart';

class DeliveryDashBoard extends StatefulWidget {
  @override
  DeliveryDashBoardState createState() => DeliveryDashBoardState();
}

class DeliveryDashBoardState extends State<DeliveryDashBoard> {
  List<String> statusList = [ORDER_ASSIGNED, ORDER_ACTIVE, ORDER_ARRIVED, ORDER_PICKED_UP, ORDER_DEPARTED, ORDER_COMPLETED, ORDER_CANCELLED];
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    LiveStream().on('UpdateLanguage', (p0) {
      setState(() {});
    });
    LiveStream().on('UpdateTheme', (p0) {
      setState(() {});
    });
    if (await checkPermission()) {
      await updateLatLong();
    }
    await getAppSetting().then((value) {
      appStore.setOtpVerifyOnPickupDelivery(value.otpVerifyOnPickupDelivery == 1);
      appStore.setCurrencyCode(value.currencyCode ?? currencyCode);
      appStore.setCurrencySymbol(value.currency ?? currencySymbol);
      appStore.setCurrencyPosition(value.currencyPosition ?? CURRENCY_POSITION_LEFT);
    }).catchError((error) {
      log(error.toString());
    });
  }

  updateLatLong() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await updateLocation(latitude: position.latitude.toString(), longitude: position.longitude.toString()).then((value) {
      //
    }).catchError((error) {
      log(error);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: statusList.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
          automaticallyImplyLeading: false,
          actions: [
            Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Icon(Icons.notifications),
                ),
                Observer(builder: (context) {
                  return Positioned(
                    right: 2,
                    top: 8,
                    child: Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${appStore.allUnreadCount < 99 ? appStore.allUnreadCount : '99+'}', style: primaryTextStyle(size: appStore.allUnreadCount < 99 ? 12 : 8, color: Colors.white)),
                    ),
                  ).visible(appStore.allUnreadCount != 0);
                }),
              ],
            ).withWidth(40).onTap(() {
              NotificationScreen().launch(context);
            }),
            4.width,
            IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () async {
                DProfileFragment().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
              },
              icon: Icon(Icons.settings),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white70,
            indicator: BoxDecoration(color: Colors.transparent),
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelStyle: secondaryTextStyle(),
            labelStyle: boldTextStyle(),
            tabs: statusList.map((e) {
              return Tab(text: orderStatus(e));
            }).toList(),
          ),
        ),
        body: BodyCornerWidget(
          child: TabBarView(
            children: statusList.map((e) {
              return CreateTabScreen(orderStatus: e);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
