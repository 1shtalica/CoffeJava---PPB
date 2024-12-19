import 'package:flutter/material.dart';
import 'shipping_address.dart';
import '../api/payment_service.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';

class CheckoutPage extends StatefulWidget {
  final int shippingId;

  const CheckoutPage({super.key, required this.shippingId});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String paymentType = '';
  

  Future<void> _processPayment(
    
      BuildContext context, int shippingId, String paymentType) async {
        print("payment typenya adalah ${paymentType}");
    try {
      final response = await PaymentService().fetchSnapToken(
        shippingId: shippingId,
        paymentType: paymentType,
      );

      if (response != null && response['transaction']['token'] != null) {
        final snapToken = response['transaction']['token'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MidtransSnap(
              mode: MidtransEnvironment.sandbox,
              token: snapToken,
              midtransClientKey: 'SB-Mid-client-gnQEOj0Jyg94-ps7',
              onPageFinished: (url) {
                print('Page Finished Loading: $url');
              },
              onPageStarted: (url) {
                print('Page Started Loading: $url');
              },
              onResponse: (result) {
                if (result.transactionStatus == "settlement") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment Successful!')),
                  );
                  print('Transaction Successful: ${result.toJson()}');
                } else if (result.transactionStatus == 'pending') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment Pending!')),
                  );
                  print('Transaction Pending: ${result.toJson()}');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment Failed!')),
                  );
                  print('Transaction Failed: ${result.toJson()}');
                }
              },
            ),
          ),
        );
      } else {
        throw Exception('Failed to get Snap Token');
      }
    } catch (e) {
      print('Error processing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process payment')),
      );
    }
  }

  Widget buildPaymentOption(String title, IconData icon, String type) {
    bool isSelected = paymentType == type;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: isSelected ? Colors.green : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.blue),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.check_circle,
          color: isSelected ? Colors.white : Colors.grey,
        ),
        onTap: () {
          setState(() {
            paymentType = type;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shipping address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            // delivery method
            const Text('Delivery method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDeliveryOption('FedEx', '2-3 days', '125\$'),
                _buildDeliveryOption('UPS', '2-3 days', '10\$'),
                _buildDeliveryOption('Sicepat', '2-3 days', '15\$'),
              ],
            ),
            const SizedBox(height: 16),
            //payment method
            const Text('Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: [
                buildPaymentOption('Credit Card', Icons.credit_card, 'ovo'),
                buildPaymentOption(
                    'Bank Virtual Account', Icons.account_balance, 'bca_va'),
              ],
            ),
            const Spacer(),

            //order summary
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Order:', style: TextStyle(fontSize: 16)),
                    Text('112\$', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Delivery:', style: TextStyle(fontSize: 16)),
                    Text('15\$', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Summary:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('127\$',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),

                //submit button
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (paymentType.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please select a payment method')),
                        );
                        return;
                      }
                      print(paymentType);

                      await _processPayment(
                          context, widget.shippingId, paymentType);
                    } catch (e) {
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to proceed with checkout')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffDDA86B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'SUBMIT ORDER',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOption(String title, String subtitle, String price) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(price,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
