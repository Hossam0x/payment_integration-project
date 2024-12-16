
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_project/Features/checkout/data/models/ephemeral_key_model/ephemeral_key_model.dart';
import 'package:google_maps_project/Features/checkout/data/models/init_payment_sheet_input_model.dart';
import 'package:google_maps_project/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:google_maps_project/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:google_maps_project/core/utils/api_keyes.dart';
import 'package:google_maps_project/core/utils/api_service.dart';

class StripeService {
  final ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
      body: paymentIntentInputModel.toJson(),
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/payment_intents',
      token: ApiKeyes.secretKey,
    );

    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);

    return paymentIntentModel;
  }

  Future initPaymentSheet(
      {required InitiPaymentSheetInputModel
          initiPaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initiPaymentSheetInputModel.clientSecret,
        customerEphemeralKeySecret:
            initiPaymentSheetInputModel.ephemeralKeySecret,
        customerId: initiPaymentSheetInputModel.customerId,
        merchantDisplayName: 'hossam',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    var ephemeralKeyModel =
        await createEphemeralKey(customerId: paymentIntentInputModel.cusomerId);
    var initPaymentSheetInputModel = InitiPaymentSheetInputModel(
        clientSecret: paymentIntentModel.clientSecret!,
        customerId: paymentIntentInputModel.cusomerId,
        ephemeralKeySecret: ephemeralKeyModel.secret!);
    await initPaymentSheet(
        initiPaymentSheetInputModel: initPaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphemeralKeyModel> createEphemeralKey(
      {required String customerId}) async {
    var response = await apiService.post(
        body: {'customer': customerId},
        contentType: Headers.formUrlEncodedContentType,
        url: 'https://api.stripe.com/v1/ephemeral_keys',
        token: ApiKeyes.secretKey,
        headers: {
          'Authorization': "Bearer ${ApiKeyes.secretKey}",
          'Stripe-Version': '2024-11-20.acacia',
        });

    var ephermeralKey = EphemeralKeyModel.fromJson(response.data);

    return ephermeralKey;
  }
}
