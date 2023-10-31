import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  @override
  _RazorpayPaymentScreenState createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    // Initialize Razorpay with your API key
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success here
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");
    // You can navigate to a success screen or perform other actions.
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure here
    print("Error Code: ${response.code}");
    print("Error Message: ${response.message}");
    // You can show an error message or handle the error as needed.
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment
    print("External Wallet Name: ${response.walletName}");
    // You can navigate to a screen for external wallet payments.
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() {
    var options = {
      'key': 'YOUR_RAZORPAY_API_KEY',
      'amount': 1000, // Payment amount in paisa (e.g., 1000 paisa = 10 INR)
      'name': 'Your App Name',
      'description': 'Sample Payment',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@example.com',
      },
      'external': {
        'wallets': ['paytm'],
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total Amount: ₹10.00',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                openCheckout();
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
