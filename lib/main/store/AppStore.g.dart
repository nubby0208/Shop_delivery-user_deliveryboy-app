// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: '_AppStore.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$allUnreadCountAtom =
      Atom(name: '_AppStore.allUnreadCount', context: context);

  @override
  int get allUnreadCount {
    _$allUnreadCountAtom.reportRead();
    return super.allUnreadCount;
  }

  @override
  set allUnreadCount(int value) {
    _$allUnreadCountAtom.reportWrite(value, super.allUnreadCount, () {
      super.allUnreadCount = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_AppStore.selectedLanguage', context: context);

  @override
  String get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(String value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$isDarkModeAtom =
      Atom(name: '_AppStore.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$isFilteringAtom =
      Atom(name: '_AppStore.isFiltering', context: context);

  @override
  bool get isFiltering {
    _$isFilteringAtom.reportRead();
    return super.isFiltering;
  }

  @override
  set isFiltering(bool value) {
    _$isFilteringAtom.reportWrite(value, super.isFiltering, () {
      super.isFiltering = value;
    });
  }

  late final _$uidAtom = Atom(name: '_AppStore.uid', context: context);

  @override
  String get uid {
    _$uidAtom.reportRead();
    return super.uid;
  }

  @override
  set uid(String value) {
    _$uidAtom.reportWrite(value, super.uid, () {
      super.uid = value;
    });
  }

  late final _$isOtpVerifyOnPickupDeliveryAtom =
      Atom(name: '_AppStore.isOtpVerifyOnPickupDelivery', context: context);

  @override
  bool get isOtpVerifyOnPickupDelivery {
    _$isOtpVerifyOnPickupDeliveryAtom.reportRead();
    return super.isOtpVerifyOnPickupDelivery;
  }

  @override
  set isOtpVerifyOnPickupDelivery(bool value) {
    _$isOtpVerifyOnPickupDeliveryAtom
        .reportWrite(value, super.isOtpVerifyOnPickupDelivery, () {
      super.isOtpVerifyOnPickupDelivery = value;
    });
  }

  late final _$currencyCodeAtom =
      Atom(name: '_AppStore.currencyCode', context: context);

  @override
  String get currencyCode {
    _$currencyCodeAtom.reportRead();
    return super.currencyCode;
  }

  @override
  set currencyCode(String value) {
    _$currencyCodeAtom.reportWrite(value, super.currencyCode, () {
      super.currencyCode = value;
    });
  }

  late final _$currencySymbolAtom =
      Atom(name: '_AppStore.currencySymbol', context: context);

  @override
  String get currencySymbol {
    _$currencySymbolAtom.reportRead();
    return super.currencySymbol;
  }

  @override
  set currencySymbol(String value) {
    _$currencySymbolAtom.reportWrite(value, super.currencySymbol, () {
      super.currencySymbol = value;
    });
  }

  late final _$currencyPositionAtom =
      Atom(name: '_AppStore.currencyPosition', context: context);

  @override
  String get currencyPosition {
    _$currencyPositionAtom.reportRead();
    return super.currencyPosition;
  }

  @override
  set currencyPosition(String value) {
    _$currencyPositionAtom.reportWrite(value, super.currencyPosition, () {
      super.currencyPosition = value;
    });
  }

  late final _$setLoadingAsyncAction =
      AsyncAction('_AppStore.setLoading', context: context);

  @override
  Future<void> setLoading(bool val) {
    return _$setLoadingAsyncAction.run(() => super.setLoading(val));
  }

  late final _$setLoginAsyncAction =
      AsyncAction('_AppStore.setLogin', context: context);

  @override
  Future<void> setLogin(bool val, {bool isInitializing = false}) {
    return _$setLoginAsyncAction
        .run(() => super.setLogin(val, isInitializing: isInitializing));
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val, {bool isInitialization = false}) {
    return _$setUserEmailAsyncAction
        .run(() => super.setUserEmail(val, isInitialization: isInitialization));
  }

  late final _$setUIdAsyncAction =
      AsyncAction('_AppStore.setUId', context: context);

  @override
  Future<void> setUId(String val, {bool isInitializing = false}) {
    return _$setUIdAsyncAction
        .run(() => super.setUId(val, isInitializing: isInitializing));
  }

  late final _$setAllUnreadCountAsyncAction =
      AsyncAction('_AppStore.setAllUnreadCount', context: context);

  @override
  Future<void> setAllUnreadCount(int val) {
    return _$setAllUnreadCountAsyncAction
        .run(() => super.setAllUnreadCount(val));
  }

  late final _$setOtpVerifyOnPickupDeliveryAsyncAction =
      AsyncAction('_AppStore.setOtpVerifyOnPickupDelivery', context: context);

  @override
  Future<void> setOtpVerifyOnPickupDelivery(bool val) {
    return _$setOtpVerifyOnPickupDeliveryAsyncAction
        .run(() => super.setOtpVerifyOnPickupDelivery(val));
  }

  late final _$setCurrencyCodeAsyncAction =
      AsyncAction('_AppStore.setCurrencyCode', context: context);

  @override
  Future<void> setCurrencyCode(String val) {
    return _$setCurrencyCodeAsyncAction.run(() => super.setCurrencyCode(val));
  }

  late final _$setCurrencySymbolAsyncAction =
      AsyncAction('_AppStore.setCurrencySymbol', context: context);

  @override
  Future<void> setCurrencySymbol(String val) {
    return _$setCurrencySymbolAsyncAction
        .run(() => super.setCurrencySymbol(val));
  }

  late final _$setCurrencyPositionAsyncAction =
      AsyncAction('_AppStore.setCurrencyPosition', context: context);

  @override
  Future<void> setCurrencyPosition(String val) {
    return _$setCurrencyPositionAsyncAction
        .run(() => super.setCurrencyPosition(val));
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('_AppStore.setLanguage', context: context);

  @override
  Future<void> setLanguage(String aCode, {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(aCode, context: context));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  late final _$setFilteringAsyncAction =
      AsyncAction('_AppStore.setFiltering', context: context);

  @override
  Future<void> setFiltering(bool val) {
    return _$setFilteringAsyncAction.run(() => super.setFiltering(val));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isLoggedIn: ${isLoggedIn},
userEmail: ${userEmail},
allUnreadCount: ${allUnreadCount},
selectedLanguage: ${selectedLanguage},
isDarkMode: ${isDarkMode},
isFiltering: ${isFiltering},
uid: ${uid},
isOtpVerifyOnPickupDelivery: ${isOtpVerifyOnPickupDelivery},
currencyCode: ${currencyCode},
currencySymbol: ${currencySymbol},
currencyPosition: ${currencyPosition}
    ''';
  }
}
