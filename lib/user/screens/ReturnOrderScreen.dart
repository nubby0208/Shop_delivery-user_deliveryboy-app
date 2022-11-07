import 'dart:core';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mighty_delivery/main/components/BodyCornerWidget.dart';
import 'package:mighty_delivery/main/models/OrderListModel.dart';
import 'package:mighty_delivery/main/network/RestApis.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mighty_delivery/main/utils/DataProviders.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:mighty_delivery/user/components/PaymentScreen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'DashboardScreen.dart';

class ReturnOrderScreen extends StatefulWidget {
  static String tag = '/ReturnOrderScreen';
  final OrderData orderData;

  ReturnOrderScreen(this.orderData);

  @override
  ReturnOrderScreenState createState() => ReturnOrderScreenState();
}

class ReturnOrderScreenState extends State<ReturnOrderScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isDeliverNow = true;
  DateTime? pickDate, deliverDate;
  TimeOfDay? pickFromTime, pickToTime, deliverFromTime, deliverToTime;

  String paymentCollectFrom = PAYMENT_ON_PICKUP;
  bool isCashPayment = true;

  TextEditingController reasonController = TextEditingController();
  String? reason;

  List<String> returnOrderReasonList = getReturnReasonList();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on('UpdateLanguage', (p0) {
      returnOrderReasonList.clear();
      returnOrderReasonList.addAll(getReturnReasonList());
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  createOrderApiCall() async {
    if (formKey.currentState!.validate()) {
      Duration difference = Duration();
      if (!isDeliverNow) {
        DateTime pickFromDateTime = pickDate!.add(Duration(hours: pickFromTime!.hour, minutes: pickFromTime!.minute));
        DateTime pickToDateTime = pickDate!.add(Duration(hours: pickToTime!.hour, minutes: pickToTime!.minute));
        DateTime deliverFromDateTime = deliverDate!.add(Duration(hours: deliverFromTime!.hour, minutes: deliverFromTime!.minute));
        DateTime deliverToDateTime = deliverDate!.add(Duration(hours: deliverToTime!.hour, minutes: deliverToTime!.minute));
        widget.orderData.deliveryPoint!.startTime = pickFromDateTime.toString();
        widget.orderData.deliveryPoint!.endTime = pickToDateTime.toString();
        widget.orderData.pickupPoint!.startTime = deliverFromDateTime.toString();
        widget.orderData.pickupPoint!.endTime = deliverToDateTime.toString();
        difference = pickFromDateTime.difference(deliverFromDateTime);
      } else {
        widget.orderData.pickupPoint!.startTime = DateTime.now().toString();
        widget.orderData.pickupPoint!.endTime = null;
        widget.orderData.deliveryPoint!.startTime = null;
        widget.orderData.deliveryPoint!.endTime = null;
      }
      if (difference.inMinutes > 0) return toast(language.pickupDeliverValidationMsg);
      Map req = {
        "client_id": widget.orderData.clientId!,
        "date": DateTime.now().toString(),
        "country_id": widget.orderData.countryId!,
        "city_id": widget.orderData.cityId!,
        "pickup_point": widget.orderData.deliveryPoint!,
        "delivery_point": widget.orderData.pickupPoint!,
        "extra_charges": widget.orderData.extraCharges!,
        "parcel_type": widget.orderData.parcelType!,
        "total_weight": widget.orderData.totalWeight!,
        "total_distance": widget.orderData.totalDistance!,
        "payment_collect_from": widget.orderData.paymentCollectFrom!,
        "status": ORDER_CREATE,
        "payment_type": "",
        "payment_status": "",
        "fixed_charges": widget.orderData.fixedCharges!,
        "parent_order_id": widget.orderData.id!,
        "total_amount": widget.orderData.totalAmount!,
        "reason": reason!.validate().trim() != language.other.trim() ? reason : reasonController.text
      };
      appStore.setLoading(true);
      await createOrder(req).then((value) {
        appStore.setLoading(false);
        toast(value.message);
        finish(context);
        if (!isCashPayment) {
          PaymentScreen(orderId: value.orderId.validate(), totalAmount: widget.orderData.totalAmount.validate()).launch(context);
        } else {
          DashboardScreen().launch(context, isNewTask: true);
        }
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(language.returnOrder)),
      body: BodyCornerWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    scheduleOptionWidget(context, isDeliverNow, 'assets/icons/ic_clock.png', language.deliveryNow).onTap(() {
                      isDeliverNow = true;
                      setState(() {});
                    }).expand(),
                    16.width,
                    scheduleOptionWidget(context, !isDeliverNow, 'assets/icons/ic_schedule.png', language.schedule).onTap(() {
                      isDeliverNow = false;
                      setState(() {});
                    }).expand(),
                  ],
                ),
                16.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.pickTime, style: primaryTextStyle()),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: appStore.isDarkMode ? 0.2 : 1),
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      child: Column(
                        children: [
                          DateTimePicker(
                            type: DateTimePickerType.date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                            onChanged: (value) {
                              pickDate = DateTime.parse(value);
                              setState(() {});
                            },
                            validator: (value) {
                              if (value!.isEmpty) return errorThisFieldRequired;
                              return null;
                            },
                            decoration: commonInputDecoration(suffixIcon: Icons.calendar_today),
                          ),
                          16.height,
                          Row(
                            children: [
                              Text(language.from, style: primaryTextStyle()).expand(flex: 1),
                              8.width,
                              DateTimePicker(
                                type: DateTimePickerType.time,
                                onChanged: (value) {
                                  pickFromTime = TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(value));
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.validate().isEmpty) return errorThisFieldRequired;
                                  return null;
                                },
                                decoration: commonInputDecoration(suffixIcon: Icons.access_time),
                              ).expand(flex: 2),
                            ],
                          ),
                          16.height,
                          Row(
                            children: [
                              Text(language.to, style: primaryTextStyle()).expand(flex: 1),
                              8.width,
                              DateTimePicker(
                                type: DateTimePickerType.time,
                                onChanged: (value) {
                                  pickToTime = TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(value));
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.validate().isEmpty) return errorThisFieldRequired;
                                  double fromTimeInHour = pickFromTime!.hour + pickFromTime!.minute / 60;
                                  double toTimeInHour = pickToTime!.hour + pickToTime!.minute / 60;
                                  double difference = toTimeInHour - fromTimeInHour;
                                  print(difference);
                                  if (difference <= 0) {
                                    return language.endTimeValidationMsg;
                                  }
                                  return null;
                                },
                                decoration: commonInputDecoration(suffixIcon: Icons.access_time),
                              ).expand(flex: 2),
                            ],
                          )
                        ],
                      ),
                    ),
                    16.height,
                    Text(language.deliverTime, style: primaryTextStyle()),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: appStore.isDarkMode ? 0.2 : 1),
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      child: Column(
                        children: [
                          DateTimePicker(
                            type: DateTimePickerType.date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                            onChanged: (value) {
                              deliverDate = DateTime.parse(value);
                              setState(() {});
                            },
                            validator: (value) {
                              if (value!.isEmpty) return errorThisFieldRequired;
                              return null;
                            },
                            decoration: commonInputDecoration(suffixIcon: Icons.calendar_today),
                          ),
                          16.height,
                          Row(
                            children: [
                              Text(language.from, style: primaryTextStyle()).expand(flex: 1),
                              8.width,
                              DateTimePicker(
                                type: DateTimePickerType.time,
                                onChanged: (value) {
                                  deliverFromTime = TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(value));
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.validate().isEmpty) return errorThisFieldRequired;
                                  return null;
                                },
                                decoration: commonInputDecoration(suffixIcon: Icons.access_time),
                              ).expand(flex: 2),
                            ],
                          ),
                          16.height,
                          Row(
                            children: [
                              Text(language.to, style: primaryTextStyle()).expand(flex: 1),
                              8.width,
                              DateTimePicker(
                                type: DateTimePickerType.time,
                                onChanged: (value) {
                                  deliverToTime = TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(value));
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value!.isEmpty) return errorThisFieldRequired;
                                  double fromTimeInHour = deliverFromTime!.hour + deliverFromTime!.minute / 60;
                                  double toTimeInHour = deliverToTime!.hour + deliverToTime!.minute / 60;
                                  double difference = toTimeInHour - fromTimeInHour;
                                  if (difference < 0) {
                                    return language.endTimeValidationMsg;
                                  }
                                  return null;
                                },
                                decoration: commonInputDecoration(suffixIcon: Icons.access_time),
                              ).expand(flex: 2),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ).visible(!isDeliverNow),
                16.height,
                Text(language.payment, style: boldTextStyle()),
                16.height,
                Row(
                  children: [
                    scheduleOptionWidget(context, isCashPayment, 'assets/icons/ic_cash.png', language.cash).onTap(() {
                      isCashPayment = true;
                      setState(() {});
                    }).expand(),
                    16.width,
                    scheduleOptionWidget(context, !isCashPayment, 'assets/icons/ic_credit_card.png', language.online).onTap(() {
                      isCashPayment = false;
                      setState(() {});
                    }).expand(),
                  ],
                ),
                16.height,
                Row(
                  children: [
                    Text(language.paymentCollectFrom, style: boldTextStyle()),
                    16.width,
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: paymentCollectFrom,
                      decoration: commonInputDecoration(),
                      items: [
                        DropdownMenuItem(value: PAYMENT_ON_PICKUP, child: Text(language.pickupLocation, style: primaryTextStyle(),maxLines: 1)),
                        DropdownMenuItem(value: PAYMENT_ON_DELIVERY, child: Text(language.deliveryLocation, style: primaryTextStyle(),maxLines: 1)),
                      ],
                      onChanged: (value) {
                        paymentCollectFrom = value!;
                        setState(() {});
                      },
                    ).expand(),
                  ],
                ).visible(isCashPayment),
                16.height,
                Text(language.reason, style: boldTextStyle()),
                8.height,
                DropdownButtonFormField<String>(
                  value: reason,
                  isExpanded: true,
                  decoration: commonInputDecoration(),
                  items: returnOrderReasonList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    reason = val;
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null) return language.fieldRequiredMsg;
                    return null;
                  },
                ),
                16.height,
                AppTextField(
                  controller: reasonController,
                  textFieldType: TextFieldType.OTHER,
                  decoration: commonInputDecoration(hintText: language.writeReasonHere),
                  maxLines: 3,
                  minLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) return language.fieldRequiredMsg;
                    return null;
                  },
                ).visible(reason.validate().trim() == language.other.trim()),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.total, style: boldTextStyle()),
                    16.width,
                    Text('${printAmount(widget.orderData.totalAmount.validate())}', style: boldTextStyle(size: 20)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: commonButton(language.lblReturn, () {
          createOrderApiCall();
        }),
      ),
    );
  }
}
