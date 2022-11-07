import 'package:flutter/material.dart';
import 'package:mighty_delivery/main/network/RestApis.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mighty_delivery/main/utils/DataProviders.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class CancelOrderDialog extends StatefulWidget {
  static String tag = '/CancelOrderDialog';

  final int orderId;
  final Function? onUpdate;

  CancelOrderDialog({required this.orderId, this.onUpdate});

  @override
  CancelOrderDialogState createState() => CancelOrderDialogState();
}

class CancelOrderDialogState extends State<CancelOrderDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController reasonController = TextEditingController();
  String? reason;

  List<String> userCancelOrderReasonList = getUserCancelReasonList();
  List<String> deliveryBoyCancelOrderReasonList = getDeliveryCancelReasonList();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on('UpdateLanguage', (p0) {
      userCancelOrderReasonList.clear();
      deliveryBoyCancelOrderReasonList.clear();
      userCancelOrderReasonList.addAll(getUserCancelReasonList());
      deliveryBoyCancelOrderReasonList.addAll(getDeliveryCancelReasonList());
      setState(() {});
    });
  }

  updateOrderApiCall() async {
    finish(context);
    appStore.setLoading(true);
    await updateOrder(
      orderId: widget.orderId,
      reason: reason!.validate().trim() != language.other.trim() ? reason : reasonController.text,
      orderStatus: ORDER_CANCELLED,
    ).then((value) {
      appStore.setLoading(false);
      widget.onUpdate!.call();
      toast(language.orderCancelledSuccessfully);
    }).catchError((error) {
      appStore.setLoading(false);

      log(error);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language.cancelOrder, style: boldTextStyle(size: 18)),
              Icon(Icons.clear).onTap(() {
                finish(context);
              }),
            ],
          ),
          16.height,
          Text(language.reason, style: boldTextStyle()),
          8.height,
          DropdownButtonFormField<String>(
            value: reason,
            isExpanded: true,
            decoration: commonInputDecoration(),
            items: (getStringAsync(USER_TYPE) == CLIENT ? userCancelOrderReasonList : deliveryBoyCancelOrderReasonList).map((e) {
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
          Align(
            alignment: Alignment.centerRight,
            child: commonButton(language.submit, () {
              if (formKey.currentState!.validate()) {
                updateOrderApiCall();
              }
            }),
          )
        ],
      ),
    );
  }
}
