
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_project/Features/checkout/presentation/views/my_cart_view.dart';
import 'package:google_maps_project/core/utils/api_keyes.dart';

void main() {
  Stripe.publishableKey = ApiKeyes.publicKey;

  runApp(const CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCartView(),
    );
  }
}

// PaymentIntentModel create payment intent(amount , currency , customerId)
// keySecret createEphemeralKey( customerId)
// initPaymentSheet (merchantDisplayName , intentClientSecret , ephemeralKeySecret)
// presentPaymentSheet()
