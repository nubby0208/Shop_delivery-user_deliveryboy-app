import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart' as payTab;
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterwave_standard/core/TransactionCallBack.dart';
import 'package:flutterwave_standard/core/navigation_controller.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/requests/standard_request.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:flutterwave_standard/view/view_utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:mighty_delivery/main/components/BodyCornerWidget.dart';
import 'package:mighty_delivery/main/models/PaymentGatewayListModel.dart';
import 'package:mighty_delivery/main/network/NetworkUtils.dart';
import 'package:mighty_delivery/main/network/RestApis.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:mighty_delivery/user/screens/DashboardScreen.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paytm/paytm.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../main.dart';
import '../../main/models/CityListModel.dart';
import '../../main/models/CountryListModel.dart';
import '../../main/models/StripePayModel.dart';

class PaymentScreen extends StatefulWidget {
  static String tag = '/PaymentScreen';
  final num totalAmount;
  final int orderId;

  PaymentScreen({required this.totalAmount, required this.orderId});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> implements TransactionCallBack {
  String? razorKey,
      stripPaymentKey,
      stripPaymentPublishKey,
      flutterWavePublicKey,
      flutterWaveSecretKey,
      flutterWaveEncryptionKey,
      payStackPublicKey,
      payPalTokenizationKey,
      mercadoPagoPublicKey,
      mercadoPagoAccessToken,
      payTabsProfileId,
      payTabsServerKey,
      payTabsClientKey,
      paytmMerchantId,
      paytmMerchantKey,
      myFatoorahToken;
  List<PaymentGatewayData> paymentGatewayList = [];
  late NavigationController controller;
  String? selectedPaymentType;
  bool isTestType = true;
  late Razorpay _razorpay;


  bool isDisabled = false;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    await paymentListApiCall();
    Stripe.publishableKey = stripPaymentPublishKey.validate();
    await Stripe.instance.applySettings().catchError((e) {
      log("${e.toString()}");
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Get Payment Gateway Api Call
  Future<void> paymentListApiCall() async {
    appStore.setLoading(true);
    await getPaymentGatewayList().then((value) {
      appStore.setLoading(false);
      paymentGatewayList.addAll(value.data!);
      if (paymentGatewayList.isNotEmpty) {
        paymentGatewayList.forEach((element) {
          if (element.type == PAYMENT_TYPE_STRIPE) {
            stripPaymentKey = element.isTest == 1 ? element.testValue!.secretKey : element.liveValue!.secretKey;
            stripPaymentPublishKey = element.isTest == 1 ? element.testValue!.publishableKey : element.liveValue!.publishableKey;
          } else if (element.type == PAYMENT_TYPE_PAYSTACK) {
            payStackPublicKey = element.isTest == 1 ? element.testValue!.publicKey : element.liveValue!.publicKey;
          } else if (element.type == PAYMENT_TYPE_RAZORPAY) {
            razorKey = element.isTest == 1 ? element.testValue!.keyId.validate() : element.liveValue!.keyId.validate();
          } else if (element.type == PAYMENT_TYPE_FLUTTERWAVE) {
            flutterWavePublicKey = element.isTest == 1 ? element.testValue!.publicKey : element.liveValue!.publicKey;
            flutterWaveSecretKey = element.isTest == 1 ? element.testValue!.secretKey : element.liveValue!.secretKey;
            flutterWaveEncryptionKey = element.isTest == 1 ? element.testValue!.encryptionKey : element.liveValue!.encryptionKey;
          } else if (element.type == PAYMENT_TYPE_PAYPAL) {
            payPalTokenizationKey = element.isTest == 1 ? element.testValue!.tokenizationKey : element.liveValue!.tokenizationKey;
          } else if (element.type == PAYMENT_TYPE_PAYTABS) {
            payTabsProfileId = element.isTest == 1 ? element.testValue!.profileId : element.liveValue!.profileId;
            payTabsClientKey = element.isTest == 1 ? element.testValue!.clientKey : element.liveValue!.clientKey;
            payTabsServerKey = element.isTest == 1 ? element.testValue!.serverKey : element.liveValue!.serverKey;
          } else if (element.type == PAYMENT_TYPE_MERCADOPAGO) {
            mercadoPagoPublicKey = element.isTest == 1 ? element.testValue!.publicKey : element.liveValue!.publicKey;
            mercadoPagoAccessToken = element.isTest == 1 ? element.testValue!.accessToken : element.liveValue!.accessToken;
          } else if (element.type == PAYMENT_TYPE_PAYTM) {
            paytmMerchantId = element.isTest == 1 ? element.testValue!.merchantId : element.liveValue!.merchantId;
            paytmMerchantKey = element.isTest == 1 ? element.testValue!.merchantKey : element.liveValue!.merchantKey;
          } else if (element.type == PAYMENT_TYPE_MYFATOORAH) {
            myFatoorahToken = element.isTest == 1 ? element.testValue!.accessToken : element.liveValue!.accessToken;
          }
        });
        setState(() {});
      }
    }).catchError((error) {
      appStore.setLoading(false);
      log(error.toString());
    });
  }

  /// Save Payment
  Future<void> savePaymentApiCall({String? paymentType, String? txnId, String? paymentStatus = PAYMENT_PENDING, Map? transactionDetail}) async {
    Map req = {
      "id": "",
      "order_id": widget.orderId.toString(),
      "client_id": getIntAsync(USER_ID).toString(),
      "datetime": DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
      "total_amount": widget.totalAmount.toString(),
      "payment_type": paymentType,
      "txn_id": txnId,
      "payment_status": paymentStatus,
      "transaction_detail": transactionDetail ?? {}
    };

    appStore.setLoading(true);

    savePayment(req).then((value) {
      appStore.setLoading(false);
      toast(value.message.toString());
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((error) {
      appStore.setLoading(false);
      print(error.toString());
    });
  }

  /// Razor Pay
  void razorPayPayment() async {
    var options = {
      'key': razorKey.validate(),
      'amount': (widget.totalAmount * 100).toInt(),
      'theme.color': '#5957b0',
      'name': 'Mighty Delivery',
      'description': 'On Demand Local Delivery System',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': getStringAsync(USER_CONTACT_NUMBER), 'email': getStringAsync(USER_EMAIL)},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
    Map<String, dynamic> req = {
      'order_id': response.orderId ?? widget.orderId.toString(),
      'txn_id': response.paymentId,
      'signature': response.signature,
    };
    savePaymentApiCall(paymentType: PAYMENT_TYPE_RAZORPAY, paymentStatus: 'paid', txnId: response.paymentId, transactionDetail: req);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR: " + response.code.toString() + " - " + response.message!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }

  /// FlutterWave Payment
  void flutterWaveCheckout() {
    if (isDisabled) return;
    _showConfirmDialog();
  }

  final style = FlutterwaveStyle(
      buttonColor: Color(0xFF5957b0),
      buttonTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      dialogCancelTextStyle: TextStyle(color: Colors.grey, fontSize: 18),
      dialogContinueTextStyle: TextStyle(color: Color(0xFF5957b0), fontSize: 18));

  void _showConfirmDialog() {
    FlutterwaveViewUtils.showConfirmPaymentModal(
      context,
      appStore.currencyCode,
      widget.totalAmount.toString(),
      style.getMainTextStyle(),
      style.getDialogBackgroundColor(),
      style.getDialogCancelTextStyle(),
      style.getDialogContinueTextStyle(),
      _handlePayment,
    );
  }

  void _handlePayment() async {
    final Customer customer = Customer(name: getStringAsync(NAME), phoneNumber: getStringAsync(USER_CONTACT_NUMBER), email: getStringAsync(USER_EMAIL));

    final request = StandardRequest(
      txRef: DateTime.now().millisecond.toString(),
      amount: widget.totalAmount.toString(),
      customer: customer,
      paymentOptions: "card, payattitude",
      customization: Customization(title: "Test Payment"),
      isTestMode: isTestType,
      publicKey: flutterWavePublicKey.validate(),
      currency: appStore.currencyCode,
      redirectUrl: "https://www.google.com",
    );

    try {
      Navigator.of(context).pop();
      _toggleButtonActive(false);
      controller.startTransaction(request);
      _toggleButtonActive(true);
    } catch (error) {
      _toggleButtonActive(true);
      _showErrorAndClose(error.toString());
    }
  }

  void _toggleButtonActive(final bool shouldEnable) {
    setState(() {
      isDisabled = !shouldEnable;
    });
  }

  void _showErrorAndClose(final String errorMessage) {
    FlutterwaveViewUtils.showToast(context, errorMessage);
  }

  @override
  onTransactionError() {
    _showErrorAndClose("transaction error");
    toast(errorMessage);
  }

  @override
  onCancelled() {
    toast("Transaction Cancelled");
  }

  @override
  onTransactionSuccess(String id, String txRef) {
    final ChargeResponse chargeResponse = ChargeResponse(status: "success", success: true, transactionId: id, txRef: txRef);
    Map<String, dynamic> req = {
      "txn_id": chargeResponse.transactionId.toString(),
      "status": chargeResponse.status.toString(),
      "reference": chargeResponse.txRef.toString(),
    };
    savePaymentApiCall(paymentStatus: PAYMENT_PAID, txnId: chargeResponse.transactionId, paymentType: PAYMENT_TYPE_FLUTTERWAVE, transactionDetail: req);
  }

  /// StripPayment
  void stripePay() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer ${stripPaymentKey.validate()}',
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    var request = http.Request('POST', Uri.parse(stripeURL));

    request.bodyFields = {
      'amount': '${(widget.totalAmount * 100).toInt()}',
      'currency': "${appStore.currencyCode}",
    };

    log(request.bodyFields);
    request.headers.addAll(headers);

    log(request);

    appStore.setLoading(true);

    await request.send().then((value) {
      appStore.setLoading(false);
      http.Response.fromStream(value).then((response) async {
        if (response.statusCode == 200) {
          var res = StripePayModel.fromJson(await handleResponse(response));

          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: res.clientSecret.validate(),
              style: ThemeMode.light,
              applePay: true,
              googlePay: true,
              testEnv: isTestType,
              merchantCountryCode: 'IN',
              merchantDisplayName: 'Mighty Delivery',
              customerId: getIntAsync(USER_ID).toString(),
              setupIntentClientSecret: res.clientSecret.validate(),
            ),
          );
          await Stripe.instance.presentPaymentSheet(parameters: PresentPaymentSheetParameters(clientSecret: res.clientSecret!, confirmPayment: true)).then(
            (value) async {
              savePaymentApiCall(paymentType: PAYMENT_TYPE_STRIPE, paymentStatus: PAYMENT_PAID, txnId: res.id);
            },
          ).catchError((e) {
            log("presentPaymentSheet ${e.toString()}");
          });
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Paypal Payment
  void payPalPayment() async {
    final request = BraintreePayPalRequest(amount: widget.totalAmount.toString(), currencyCode: appStore.currencyCode, displayName: getStringAsync(USER_NAME));
    final result = await Braintree.requestPaypalNonce(
      payPalTokenizationKey!,
      request,
    );
    if (result != null) {
      var request = <String, String?>{
        "txn_id": result.nonce,
        "description": result.description,
        "paypal_payer_id": result.paypalPayerId,
      };
      savePaymentApiCall(paymentType: PAYMENT_TYPE_PAYPAL, paymentStatus: PAYMENT_PAID, txnId: result.nonce, transactionDetail: request);
    }
  }

  /// PayTabs Payment
  void payTabsPayment() {
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          var transactionDetails = event["data"];
          if (transactionDetails["isSuccess"]) {
            toast("successful transaction");
            savePaymentApiCall(txnId: transactionDetails['transactionReference'], paymentType: PAYMENT_TYPE_PAYTABS, paymentStatus: 'paid');
          } else {
            toast("failed transaction");
          }
          toast("successful transaction");
        } else if (event["status"] == "error") {
          print("error");
        } else if (event["status"] == "event") {
          //
        }
      });
    });
  }

  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = payTab.BillingDetails(getStringAsync(NAME), getStringAsync(USER_EMAIL), getStringAsync(USER_CONTACT_NUMBER), getStringAsync(USER_ADDRESS), CountryModel.fromJson(getJSONAsync(COUNTRY_DATA)).name.validate(),
        CityModel.fromJson(getJSONAsync(CITY_DATA)).name.validate(), "", "");
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.STC_PAY);
    var configuration = PaymentSdkConfigurationDetails(
        profileId: payTabsProfileId,
        serverKey: payTabsServerKey,
        clientKey: payTabsClientKey,
        cartId: widget.orderId.toString(),
        screentTitle: "Pay with Card",
        amount: widget.totalAmount.toDouble(),
        showBillingInfo: true,
        forceShippingInfo: false,
        currencyCode: appStore.currencyCode,
        merchantCountryCode: "IN",
        billingDetails: billingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);

    var theme = IOSThemeConfigurations();

    theme.logoImage = "assets/app_logo_white.png";

    configuration.iOSThemeConfigurations = theme;

    return configuration;
  }

  /// Mercado Pago payment
  void mercadoPagoPayment() async {
    var body = json.encode({
      "items": [
        {"title": "Courier", "description": "Courier Delivery", "quantity": 1, "currency_id": appStore.currencyCode, "unit_price": widget.totalAmount}
      ],
      "payer": {"email": getStringAsync(USER_EMAIL)}
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.mercadopago.com/checkout/preferences?access_token=${mercadoPagoAccessToken.toString()}'),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      String preferenceId = json.decode(response.body)['id'];
      PaymentResult result = await MercadoPagoMobileCheckout.startCheckout(
        mercadoPagoPublicKey!,
        preferenceId,
      );
      if (result.status == 'approved') {
        savePaymentApiCall(paymentStatus: 'paid', paymentType: PAYMENT_TYPE_MERCADOPAGO, txnId: result.id.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  /// PayTm Payment
  void paytmPayment() async {
    setState(() {
      loading = true;
    });

    String callBackUrl = (isTestType ? 'https://securegw-stage.paytm.in' : 'https://securegw.paytm.in') + '/theia/paytmCallback?ORDER_ID=' + widget.orderId.toString();

    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var body = json.encode({
      "mid": paytmMerchantId,
      "key_secret": paytmMerchantKey,
      "website": isTestType ? "WEBSTAGING" : "DEFAULT",
      "orderId": widget.orderId,
      "amount": widget.totalAmount.toString(),
      "callbackUrl": callBackUrl,
      "custId": getIntAsync(USER_ID).toString(),
      "testing": isTestType ? 0 : 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );

      String txnToken = response.body;

      var paytmResponse = Paytm.payWithPaytm(
        mId: paytmMerchantId!,
        orderId: widget.orderId.toString(),
        txnToken: txnToken,
        txnAmount: widget.totalAmount.toString(),
        callBackUrl: callBackUrl,
        staging: isTestType,
        appInvokeEnabled: false,
      );

      paytmResponse.then((value) {
        setState(() {
          loading = false;
          if (value['error']) {
            toast(value['errorMessage']);
          } else {
            if (value['response'] != null) {
              toast(value['response']['RESPMSG']);
              if (value['response']['STATUS'] == 'TXN_SUCCESS') {
                savePaymentApiCall(paymentType: PAYMENT_TYPE_PAYTM, paymentStatus: 'paid', txnId: value['response']['TXNID']);
              }
            }
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  /// My Fatoorah Payment
  Future<void> myFatoorahPayment() async {
    PaymentResponse response = await MyFatoorah.startPayment(
      context: context,
      successChild: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 50, color: Colors.green),
            SizedBox(height: 16),
            Text(language.success, style: boldTextStyle(color: Colors.green, size: 24)),
          ],
        ),
      ),
      errorChild: Center(child: Text(language.failed, style: boldTextStyle(color: Colors.red, size: 24))),
      request: isTestType
          ? MyfatoorahRequest.test(
              currencyIso: Country.SaudiArabia,
              successUrl: 'https://pub.dev/packages/get',
              errorUrl: 'https://www.google.com/',
              invoiceAmount: widget.totalAmount.toDouble(),
              language: defaultLanguage == 'ar' ? ApiLanguage.Arabic : ApiLanguage.English,
              token: myFatoorahToken!,
            )
          : MyfatoorahRequest.live(
              currencyIso: Country.SaudiArabia,
              successUrl: 'https://pub.dev/packages/get',
              errorUrl: 'https://www.google.com/',
              invoiceAmount: widget.totalAmount.toDouble(),
              language: defaultLanguage == 'ar' ? ApiLanguage.Arabic : ApiLanguage.English,
              token: myFatoorahToken!,
            ),
    );
    if (response.isSuccess) {
      savePaymentApiCall(paymentType: PAYMENT_TYPE_MYFATOORAH, txnId: response.paymentId, paymentStatus: 'paid');
    } else if (response.isError) {
      toast('Payment Failed');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    controller = NavigationController(Client(), style, this);
    return Scaffold(
      appBar: AppBar(title: Text(language.payment)),
      body: BodyCornerWidget(
        child: Observer(builder: (context) {
          return Stack(
            children: [
              paymentGatewayList.isNotEmpty
                  ? Stack(
                      children: [
                        SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.paymentMethod, style: boldTextStyle()),
                              16.height,
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: paymentGatewayList.map((mData) {
                                  return GestureDetector(
                                    child: Container(
                                      width: (context.width() - 50) * 0.5,
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                      alignment: Alignment.center,
                                      decoration: boxDecorationWithRoundedCorners(
                                        backgroundColor: context.cardColor,
                                        borderRadius: BorderRadius.circular(defaultRadius),
                                        border: Border.all(
                                            color: mData.type == selectedPaymentType
                                                ? colorPrimary
                                                : appStore.isDarkMode
                                                    ? Colors.transparent
                                                    : borderColor),
                                      ),
                                      child: Row(
                                        children: [
                                          commonCachedNetworkImage('${mData.gatewayLogo}', width: 40, height: 40),
                                          12.width,
                                          Text('${mData.title}', style: primaryTextStyle(), maxLines: 2).expand(),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      selectedPaymentType = mData.type;
                                      isTestType = mData.isTest == 1;
                                      setState(() {});
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: commonButton(language.payNow, () {
                            if (selectedPaymentType == PAYMENT_TYPE_STRIPE) {
                              stripePay();
                            } else if (selectedPaymentType == PAYMENT_TYPE_RAZORPAY) {
                              razorPayPayment();
                            } else if (selectedPaymentType == PAYMENT_TYPE_FLUTTERWAVE) {
                              flutterWaveCheckout();
                            } else if (selectedPaymentType == PAYMENT_TYPE_PAYPAL) {
                              payPalPayment();
                            } else if (selectedPaymentType == PAYMENT_TYPE_PAYTABS) {
                              payTabsPayment();
                            } else if (selectedPaymentType == PAYMENT_TYPE_MERCADOPAGO) {
                              mercadoPagoPayment();
                            } else if (selectedPaymentType == PAYMENT_TYPE_PAYTM) {
                              paytmPayment();
                            } else if (selectedPaymentType == PAYMENT_TYPE_MYFATOORAH) {
                              myFatoorahPayment();
                            }
                          }, width: context.width())
                              .paddingAll(16),
                        ),
                      ],
                    )
                  : !appStore.isLoading
                      ? emptyWidget()
                      : SizedBox(),
              loaderWidget().visible(appStore.isLoading),
            ],
          );
        }),
      ),
    );
  }
}
