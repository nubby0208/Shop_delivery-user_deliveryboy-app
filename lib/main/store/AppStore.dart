import 'package:flutter/material.dart';
import 'package:mighty_delivery/main/language/AppLocalizations.dart';
import 'package:mighty_delivery/main/language/BaseLanguage.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoading = false;

  @observable
  bool isLoggedIn = false;

  @observable
  String userEmail = '';

  @observable
  int allUnreadCount = 0;

  @observable
  String selectedLanguage = "";

  @observable
  bool isDarkMode = false;

  @observable
  bool isFiltering = false;

  @observable
  String uid = '';

  @observable
  bool isOtpVerifyOnPickupDelivery = true;

  @observable
  String currencyCode = 'INR';

  @observable
  String currencySymbol = "₹";

  @observable
  String currencyPosition = CURRENCY_POSITION_LEFT;

  @action
  Future<void> setLoading(bool val) async {
    isLoading = val;
  }

  @action
  Future<void> setLogin(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitialization = false}) async {
    userEmail = val;
  }

  @action
  Future<void> setUId(String val, {bool isInitializing = false}) async {
    uid = val;
    if (!isInitializing) await setValue(UID, val);
  }

  @action
  Future<void> setAllUnreadCount(int val) async {
    allUnreadCount = val;
  }

  @action
  Future<void> setOtpVerifyOnPickupDelivery(bool val) async {
    isOtpVerifyOnPickupDelivery = val;
  }

  @action
  Future<void> setCurrencyCode(String val) async {
    currencyCode = val;
  }

  @action
  Future<void> setCurrencySymbol(String val) async {
    currencySymbol = val;
  }

  @action
  Future<void> setCurrencyPosition(String val) async {
    currencyPosition = val;
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultLanguage);
    selectedLanguage = getSelectedLanguageModel(defaultLanguage: defaultLanguage)!.languageCode!;

    if (context != null) language = BaseLanguage.of(context)!;
    language = await AppLocalizations().load(Locale(selectedLanguage));
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = viewLineColor;

      defaultLoaderBgColorGlobal = Colors.black26;
      defaultLoaderAccentColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = colorPrimary;
      shadowColorGlobal = Colors.black12;
    }
  }

  @action
  Future<void> setFiltering(bool val) async {
    isFiltering = val;
  }
}
