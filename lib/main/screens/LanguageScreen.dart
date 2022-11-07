import 'package:flutter/material.dart';
import 'package:mighty_delivery/main/components/BodyCornerWidget.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class LanguageScreen extends StatefulWidget {
  static String tag = '/LanguageScreen';

  @override
  LanguageScreenState createState() => LanguageScreenState();
}

class LanguageScreenState extends State<LanguageScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(language.language)),
      body: BodyCornerWidget(
        child: ListView(
          children: List.generate(localeLanguageList.length, (index) {
            LanguageDataModel data = localeLanguageList[index];
            return Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset(data.flag.validate(), width: 34),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${data.name.validate()}', style: boldTextStyle()),
                      8.height,
                      Text('${data.subTitle.validate()}', style: secondaryTextStyle()),
                    ],
                  ).expand(),
                  if (getStringAsync(SELECTED_LANGUAGE_CODE,defaultValue: defaultLanguage) == data.languageCode) Icon(Icons.check_circle, color: colorPrimary),
                ],
              ),
            ).onTap(
              () async {
                await setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
                selectedLanguageDataModel = data;
                appStore.setLanguage(data.languageCode!, context: context);
                setState(() {});
                LiveStream().emit('UpdateLanguage');
                finish(context);
              },
            );
          }),
        ),
      ),
    );
  }
}
