import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../Services/AuthSertvices.dart';

class RegisterScreen extends StatefulWidget {
  final String? userType;
  static String tag = '/RegisterScreen';

  RegisterScreen({this.userType});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthServices authService = AuthServices();
  String countryCode = '+91';

  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    log(widget.userType);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> registerApiCall() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      appStore.setLoading(true);
      authService
          .signUpWithEmailPassword(context,
              lName: nameController.text,
              userName: userNameController.text,
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passController.text.trim(),
              mobileNumber: '$countryCode ${phoneController.text.trim()}',
              userType: widget.userType)
          .then((res) async {
        appStore.setLoading(false);
        //
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 90,
                        width: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/app_logo_primary.png', height: 70, width: 70)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 40, left: 16),
                    child: Icon(Icons.arrow_back, color: Colors.white).onTap(() {
                      finish(context);
                    }),
                  ),
                ],
              ).withHeight(
                context.height() * 0.25,
              ),
              Container(
                width: context.width(),
                padding: EdgeInsets.only(left: 24, right: 24),
                decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldColorDark : Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        30.height,
                        Text(language.signUp, style: boldTextStyle(size: headingSize)),
                        8.height,
                        Text(language.signUpWithYourCredential, style: secondaryTextStyle(size: 16)),
                        30.height,
                        Text(language.name, style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: nameController,
                          textFieldType: TextFieldType.NAME,
                          focus: nameFocus,
                          nextFocus: userNameFocus,
                          decoration: commonInputDecoration(),
                          errorThisFieldRequired: language.fieldRequiredMsg,
                        ),
                        16.height,
                        Text(language.username, style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: userNameController,
                          textFieldType: TextFieldType.USERNAME,
                          focus: userNameFocus,
                          nextFocus: emailFocus,
                          decoration: commonInputDecoration(),
                          errorThisFieldRequired: language.fieldRequiredMsg,
                          errorInvalidUsername: language.usernameInvalid,
                        ),
                        16.height,
                        Text(language.email, style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: emailController,
                          textFieldType: TextFieldType.EMAIL,
                          focus: emailFocus,
                          nextFocus: phoneFocus,
                          decoration: commonInputDecoration(),
                          errorThisFieldRequired: language.fieldRequiredMsg,
                          errorInvalidEmail: language.emailInvalid,
                        ),
                        16.height,
                        Text(language.contactNumber, style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: phoneController,
                          textFieldType: TextFieldType.PHONE,
                          focus: phoneFocus,
                          nextFocus: passFocus,
                          decoration: commonInputDecoration(
                            prefixIcon: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CountryCodePicker(
                                    initialSelection: countryCode,
                                    showCountryOnly: false,
                                    dialogSize: Size(context.width() - 60, context.height() * 0.6),
                                    showFlag: true,
                                    showFlagDialog: true,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    textStyle: primaryTextStyle(),
                                    dialogBackgroundColor: Theme.of(context).cardColor,
                                    barrierColor: Colors.black12,
                                    dialogTextStyle: primaryTextStyle(),
                                    searchDecoration: InputDecoration(
                                      iconColor: Theme.of(context).dividerColor,
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                                    ),
                                    searchStyle: primaryTextStyle(),
                                    onInit: (c) {
                                      countryCode = c!.dialCode!;
                                    },
                                    onChanged: (c) {
                                      countryCode = c.dialCode!;
                                    },
                                  ),
                                  VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                                ],
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) return language.fieldRequiredMsg;
                            if (value.trim().length < 10 || value.trim().length > 14) return language.contactLength;
                            return null;
                          },
                        ),
                        16.height,
                        Text(language.password, style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: passController,
                          textFieldType: TextFieldType.PASSWORD,
                          focus: passFocus,
                          decoration: commonInputDecoration(),
                          errorThisFieldRequired: language.fieldRequiredMsg,
                          errorMinimumPasswordLength: language.passwordInvalid,
                        ),
                        30.height,
                        commonButton(language.signUp, () {
                          registerApiCall();
                        }, width: context.width()),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(language.alreadyHaveAnAccount, style: primaryTextStyle()),
                            4.width,
                            Text(language.signIn, style: boldTextStyle(color: colorPrimary)).onTap(() {
                              finish(context);
                            }),
                          ],
                        ),
                        16.height,
                      ],
                    ),
                  ),
                ),
              ).expand(),
            ],
          ),
          Observer(builder: (context) => loaderWidget().visible(appStore.isLoading)),
        ],
      ).withHeight(context.height()),
    );
  }
}
