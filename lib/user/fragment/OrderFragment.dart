import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mighty_delivery/main.dart';
import 'package:mighty_delivery/main/models/OrderListModel.dart';
import 'package:mighty_delivery/main/models/models.dart';
import 'package:mighty_delivery/main/network/RestApis.dart';
import 'package:mighty_delivery/user/screens/OrderTrackingScreen.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mighty_delivery/user/screens/OrderDetailScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/GenerateInvoice.dart';

class OrderFragment extends StatefulWidget {
  static String tag = '/OrderFragment';

  @override
  OrderFragmentState createState() => OrderFragmentState();
}

class OrderFragmentState extends State<OrderFragment> {
  List<OrderData> orderList = [];
  ScrollController scrollController = ScrollController();
  int page = 1;
  int totalPage = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        if (page < totalPage) {
          page++;
          init();
        }
      }
    });
    LiveStream().on('UpdateOrderData', (p0) {
      page = 1;
      getOrderListApiCall();
      setState(() {});
    });
  }

  Future<void> init() async {
    afterBuildCreated(() {
      getOrderListApiCall();
    });
  }

  getOrderListApiCall() async {
    appStore.setLoading(true);
    FilterAttributeModel filterData = FilterAttributeModel.fromJson(getJSONAsync(FILTER_DATA));
    await getOrderList(page: page, orderStatus: filterData.orderStatus, fromDate: filterData.fromDate, toDate: filterData.toDate).then((value) {
      appStore.setLoading(false);
      appStore.setAllUnreadCount(value.allUnreadCount.validate());
      totalPage = value.pagination!.totalPages.validate(value: 1);
      page = value.pagination!.currentPage.validate(value: 1);
      isLastPage = false;
      if (page == 1) {
        orderList.clear();
      }
      orderList.addAll(value.data!);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        page = 1;
        init();
      },
      child: Observer(builder: (context) {
        return Stack(
          children: [
            orderList.isNotEmpty
                ? ListView(
                    shrinkWrap: true,
                    controller: scrollController,
                    padding: EdgeInsets.all(16),
                    children: orderList.map((item) {
                      return item.status != ORDER_DRAFT
                          ? GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: appStore.isDarkMode
                                    ? boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(defaultRadius), backgroundColor: context.cardColor)
                                    : boxDecorationRoundedWithShadow(defaultRadius.toInt()),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${language.order}# ${item.id}', style: secondaryTextStyle(size: 16)).expand(),
                                        Container(
                                          decoration: BoxDecoration(color: statusColor(item.status.validate()).withOpacity(0.15), borderRadius: BorderRadius.circular(defaultRadius)),
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Text(orderStatus(item.status!), style: boldTextStyle(color: statusColor(item.status.validate()))),
                                        ),
                                      ],
                                    ),
                                    8.height,
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: boxDecorationWithRoundedCorners(
                                              borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor, width: appStore.isDarkMode ? 0.2 : 1), backgroundColor: Colors.transparent),
                                          padding: EdgeInsets.all(8),
                                          child: Image.asset(parcelTypeIcon(item.parcelType.validate()), height: 24, width: 24, color: Colors.grey),
                                        ),
                                        8.width,
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.parcelType.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            4.height,
                                            Row(
                                              children: [
                                                item.date != null ? Text(printDate(item.date!), style: secondaryTextStyle()).expand() : SizedBox(),
                                                Text(printAmount(item.totalAmount ?? 0), style: boldTextStyle()),
                                              ],
                                            ),
                                          ],
                                        ).expand(),
                                      ],
                                    ),
                                    Divider(height: 30, thickness: 1),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (item.pickupDatetime != null)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(language.picked, style: boldTextStyle(size: 18)),
                                              4.height,
                                              Text('${language.at} ${printDate(item.pickupDatetime!)}', style: secondaryTextStyle()),
                                              16.height,
                                            ],
                                          ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ImageIcon(AssetImage('assets/icons/ic_pick_location.png'), size: 24, color: colorPrimary),
                                            12.width,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${item.pickupPoint!.address}', style: primaryTextStyle()),
                                                if (item.pickupDatetime == null && item.pickupPoint!.endTime != null && item.pickupPoint!.startTime != null)
                                                  Text('${language.note} ${language.courierWillPickupAt} ${DateFormat('dd MMM yyyy').format(DateTime.parse(item.pickupPoint!.startTime!).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(item.pickupPoint!.startTime!).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(item.pickupPoint!.endTime!).toLocal())}',
                                                          style: secondaryTextStyle())
                                                      .paddingOnly(top: 8),
                                              ],
                                            ).expand(),
                                            12.width,
                                            if (item.pickupPoint!.contactNumber != null)
                                              Image.asset('assets/icons/ic_call.png', width: 24, height: 24).onTap(() {
                                                launchUrl(Uri.parse('tel:${item.pickupPoint!.contactNumber}'));
                                              }),
                                          ],
                                        ),
                                      ],
                                    ),
                                    DottedLine(dashColor: borderColor).paddingSymmetric(vertical: 16, horizontal: 24),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (item.deliveryDatetime != null)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(language.delivered, style: boldTextStyle(size: 18)),
                                              4.height,
                                              Text('${language.at} ${printDate(item.deliveryDatetime!)}', style: secondaryTextStyle()),
                                              16.height,
                                            ],
                                          ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ImageIcon(AssetImage('assets/icons/ic_delivery_location.png'), size: 24, color: colorPrimary),
                                            12.width,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${item.deliveryPoint!.address}', style: primaryTextStyle()),
                                                if (item.deliveryDatetime == null && item.deliveryPoint!.endTime != null && item.deliveryPoint!.startTime != null)
                                                  Text('${language.note} ${language.courierWillDeliverAt} ${DateFormat('dd MMM yyyy').format(DateTime.parse(item.deliveryPoint!.startTime!).toLocal())} ${language.from} ${DateFormat('hh:mm').format(DateTime.parse(item.deliveryPoint!.startTime!).toLocal())} ${language.to} ${DateFormat('hh:mm').format(DateTime.parse(item.deliveryPoint!.endTime!).toLocal())}',
                                                          style: secondaryTextStyle())
                                                      .paddingOnly(top: 8),
                                              ],
                                            ).expand(),
                                            12.width,
                                            if (item.deliveryPoint!.contactNumber != null)
                                              Image.asset('assets/icons/ic_call.png', width: 24, height: 24).onTap(() {
                                                launchUrl(Uri.parse('tel:${item.deliveryPoint!.contactNumber}'));
                                              }),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(language.invoice, style: primaryTextStyle(color: colorPrimary)),
                                            4.width,
                                            Icon(Icons.download_rounded, color: colorPrimary),
                                          ],
                                        ).onTap(() {
                                          generateInvoiceCall(item);
                                        }),
                                        AppButton(
                                          elevation: 0,
                                          height: 35,
                                          color: Colors.transparent,
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          shapeBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(defaultRadius),
                                            side: BorderSide(color: colorPrimary),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(language.trackOrder, style: primaryTextStyle(color: colorPrimary)),
                                              Icon(Icons.arrow_right, color: colorPrimary),
                                            ],
                                          ),
                                          onTap: () {
                                            OrderTrackingScreen(orderData: item).launch(context);
                                          },
                                        ).visible(item.status == ORDER_DEPARTED || item.status == ORDER_ACTIVE),
                                      ],
                                    ).paddingOnly(top: 16),
                                  ],
                                ),
                              ),
                              onTap: () {
                                OrderDetailScreen(orderId: item.id.validate()).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: 400.milliseconds);
                              },
                            )
                          : SizedBox();
                    }).toList(),
                  )
                : !appStore.isLoading
                    ? emptyWidget()
                    : SizedBox(),
            loaderWidget().center().visible(appStore.isLoading)
          ],
        );
      }),
    );
  }
}
