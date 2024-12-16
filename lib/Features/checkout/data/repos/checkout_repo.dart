
import 'package:dartz/dartz.dart';
import 'package:google_maps_project/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:google_maps_project/core/errors/failures.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel});
}
