import 'package:flutter/material.dart';
import 'package:mighty_delivery/main.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Colors.dart';

Widget commonButton(String title, Function() onTap, {double? width, Color? color}) {
  return SizedBox(
    width: width,
    child: AppButton(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
      elevation: 0,
      child: Text(
        title,
        style: boldTextStyle(color: white),
      ),
      color: color ?? colorPrimary,
      onTap: onTap,
    ),
  );
}

Widget outlineButton(String title, Function() onTap, {double? width}) {
  return SizedBox(
    width: width,
    child: TextButton(
      child: Text(
        title,
        style: boldTextStyle(),
      ),
      onPressed: onTap,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius), side: BorderSide(color: borderColor)),
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        backgroundColor: Colors.transparent,
      ),
    ),
  );
}

Widget scheduleOptionWidget(BuildContext context, bool isSelected, String imagePath, String title) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: boxDecorationWithRoundedCorners(
        border: Border.all(
            color: isSelected
                ? colorPrimary
                : appStore.isDarkMode
                    ? Colors.transparent
                    : borderColor),
        backgroundColor: context.cardColor),
    child: Row(
      children: [
        ImageIcon(AssetImage(imagePath), size: 20, color: isSelected ? colorPrimary : Colors.grey),
        16.width,
        Text(title, style: boldTextStyle()).expand(),
      ],
    ),
  );
}
