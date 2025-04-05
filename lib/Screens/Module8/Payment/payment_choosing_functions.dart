import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PaymentChoosingFunctions {
  /*Future<void> stripeMakePayment() async {
    try {
      communitiesVariables.paymentIntent = await createPaymentIntent('100', 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            merchantDisplayName: 'Flutter Stripe Store Demo',
            customFlow: false,
            billingDetails: const BillingDetails(
              name: 'KAPIL DEV',
              email: 'KAPILDEV@GMAIL>COM',
              phone: '8123044464',
              address:
                  Address(city: 'CHENNAI', country: 'INDIA', line1: 'YAMUNA STREET', line2: 'VELACHERY', postalCode: '600042', state: 'TAMIL NADU'),
            ),
            paymentIntentClientSecret: communitiesVariables.paymentIntent!['client_secret'],
            customerEphemeralKeySecret: communitiesVariables.paymentIntent!['ephemeralKey'],
            customerId: communitiesVariables.paymentIntent!['customer'],
            *//*applePay: const PaymentSheetApplePay(
              merchantCountryCode: 'US',
            ),*//*
            *//* googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              testEnv: true,
            ),*//*
            allowsDelayedPaymentMethods: true,
            style: ThemeMode.dark,
          ))
          .then((value) {});
      displayPaymentSheet();
    } catch (e) {
      if (kDebugMode) {
        print("hello");
        print(e.toString());
      }
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Fluttertoast.showToast(msg: 'Payment successfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: $e');
      }
    }
  }*/

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
