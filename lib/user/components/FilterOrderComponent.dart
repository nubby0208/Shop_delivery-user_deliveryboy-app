import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:mighty_delivery/main/models/models.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class FilterOrderComponent extends StatefulWidget {
  static String tag = '/FilterOrderComponent';

  @override
  FilterOrderComponentState createState() => FilterOrderComponentState();
}

class FilterOrderComponentState extends State<FilterOrderComponent> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  FilterAttributeModel? filterData;

  DateTime? fromDate, toDate;
  List<String> statusList = [
    ORDER_CREATE,
    ORDER_ACTIVE,
    ORDER_CANCELLED,
    ORDER_ASSIGNED,
    ORDER_ARRIVED,
    ORDER_PICKED_UP,
    ORDER_COMPLETED,
    ORDER_DEPARTED,
  ];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    filterData = FilterAttributeModel.fromJson(getJSONAsync(FILTER_DATA));
    if (filterData != null) {
      selectedStatus = filterData!.orderStatus;
      if (filterData!.fromDate != null) {
        fromDate = DateTime.tryParse(filterData!.fromDate!);
        if (fromDate != null) {
          fromDateController.text = fromDate.toString();
        }
      }
      if (filterData!.toDate != null) {
        toDate = DateTime.tryParse(filterData!.toDate!);
        if(toDate!=null) {
          toDateController.text = toDate.toString();
        }
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.clear).onTap(() {
                      finish(context);
                    }),
                    16.width,
                    Text(language.filter, style: boldTextStyle(size: 18)),
                  ],
                ),
                Text(language.reset, style: primaryTextStyle()).onTap(() {
                  selectedStatus = null;
                  fromDate = null;
                  toDate = null;
                  fromDateController.clear();
                  toDateController.clear();
                  FocusScope.of(context).unfocus();
                  setState(() {});
                }),
              ],
            ),
            30.height,
            Text(language.status, style: boldTextStyle()),
            16.height,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: statusList.map((item) {
                return Chip(
                  backgroundColor: selectedStatus == item ? colorPrimary : Colors.transparent,
                  label: Text(orderStatus(item)),
                  elevation: 0,
                  labelStyle: primaryTextStyle(color: selectedStatus == item ? white : Colors.grey),
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius),
                    side: BorderSide(color: selectedStatus == item ? colorPrimary : borderColor,width: appStore.isDarkMode ? 0.2 : 1),
                  ),
                ).onTap(() {
                  selectedStatus = item;
                  setState(() {});
                });
              }).toList(),
            ),
            16.height,
            Text(language.date, style: boldTextStyle()),
            16.height,
            Row(
              children: [
                Text(language.from, style: primaryTextStyle()).withWidth(50),
                16.width,
                DateTimePicker(
                  controller: fromDateController,
                  type: DateTimePickerType.date,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  onChanged: (value) {
                    fromDate = DateTime.parse(value);
                    fromDateController.text = value;
                    setState(() {});
                  },
                  decoration: commonInputDecoration(suffixIcon: Icons.calendar_today),
                ).expand(),
              ],
            ),
            16.height,
            Row(
              children: [
                Text(language.to, style: primaryTextStyle()).withWidth(50),
                16.width,
                DateTimePicker(
                  controller: toDateController,
                  type: DateTimePickerType.date,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  onChanged: (value) {
                    toDate = DateTime.parse(value);
                    toDateController.text = value;
                    setState(() {});
                  },
                  validator: (value) {
                    if (fromDate != null && toDate != null) {
                      Duration difference = fromDate!.difference(toDate!);
                      if (difference.inDays >= 0) {
                        return language.toDateValidationMsg;
                      }
                    }
                    return null;
                  },
                  decoration: commonInputDecoration(suffixIcon: Icons.calendar_today),
                ).expand(),
              ],
            ),
            16.height,
            commonButton(language.applyFilter, () {
              if (_formKey.currentState!.validate()) {
                finish(context);
                setValue(FILTER_DATA, FilterAttributeModel(orderStatus: selectedStatus, fromDate: fromDate.toString(), toDate: toDate.toString()).toJson());
                appStore.setFiltering(selectedStatus!=null || fromDate!=null || toDate!=null);
                LiveStream().emit("UpdateOrderData");
              }
            }, width: context.width()),
          ],
        ),
      ),
    );
  }
}
