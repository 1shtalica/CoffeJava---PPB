import 'package:e_nusantara/api/checkLogin.dart';
import 'package:flutter/material.dart';
import 'shipping_address.dart';
import '../api/payment_service.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';
import 'package:e_nusantara/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class CheckoutPage extends StatefulWidget {
  final int shippingId;
  final int total;

  const CheckoutPage(
      {super.key, required this.shippingId, required this.total});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Map<String, dynamic>? shippingDetails;
  String paymentType = '';
  int deliveryCost = 0;
  String selectedDeliveryMethod = '';
  final Checklogin _checklogin = new Checklogin();

  @override
  void initState() {
    super.initState();
    fetchShippingDetails();
  }

  Future<void> fetchShippingDetails() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();

    final String? baseUrl = dotenv.env['BASE_URL'];

    try {
      if (this.mounted) {
        await _checklogin.checkAndNavigate(context);
      }
      String? accessToken = await storage.read(key: 'accessToken');
      final response = await http.get(
        Uri.parse('$baseUrl/shipping/${widget.shippingId}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          shippingDetails = jsonDecode(response.body);
        });
      }
    } catch (error) {
      print('Error fetching shipping details: $error');
      setState(() {
        shippingDetails = null;
      });
    }
  }

  Future<void> _processPayment(
      BuildContext context, int shippingId, String paymentType) async {
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeWidget()),
                    (Route<dynamic> route) => false,
                  );
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
        child: shippingDetails == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Shipping address',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 200,
                    height: 120,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address: ${shippingDetails!['address']}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'City: ${shippingDetails!['city']}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Postal Code: ${shippingDetails!['postal']}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Country: ${shippingDetails!['country']}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // // delivery method
                  // const Text('Delivery method',
                  //     style:
                  //         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // const SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     _buildDeliveryOption('FedEx', '2-3 days', 125),
                  //     _buildDeliveryOption('UPS', '2-3 days', 10),
                  //     _buildDeliveryOption('Sicepat', '2-3 days', 15),
                  //   ],
                  // ),
                  const SizedBox(height: 16),
                  //payment method
                  const Text('Payment Method',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildPaymentOption(
                              'Credit Card', Icons.credit_card, 'credit_card'),
                          buildPaymentOption(
                              'Qris', Icons.qr_code, 'other_qris'),
                          buildPaymentOption(
                              'Gopay', Icons.motorcycle, 'gopay'),
                          buildPaymentOption('Bank Transfer BCA',
                              Icons.account_balance, 'bca_va'),
                          buildPaymentOption('Bank Transfer BNI',
                              Icons.account_balance, 'bni_va'),
                          buildPaymentOption('Bank Transfer CIMB',
                              Icons.account_balance, 'cimb_va'),
                          buildPaymentOption('Mandiri Bill Payment',
                              Icons.account_balance, 'echannel'),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),

                  //order summary
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Order:', style: TextStyle(fontSize: 16)),
                      //     Text('Rp${widget.total}',
                      //         style: TextStyle(fontSize: 16)),
                      //   ],
                      // ),
                      // const SizedBox(height: 8),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Delivery:', style: TextStyle(fontSize: 16)),
                      //     Text('Rp$deliveryCost',
                      //         style: TextStyle(fontSize: 16)),
                      //   ],
                      // ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Summary:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Rp${widget.total}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      //submit button
                      ElevatedButton(
                        onPressed: () async {
                          _checklogin.checkAndNavigate(context);
                          print(paymentType);
                          try {
                            if (paymentType.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Please select a payment method')),
                              );
                              return;
                            }

                            await _processPayment(
                                context, widget.shippingId, paymentType);
                          } catch (e) {
                            print('Error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Failed to proceed with checkout')),
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

  Widget _buildDeliveryOption(String title, String subtitle, int cost) {
    bool isSelected = selectedDeliveryMethod == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDeliveryMethod = title;
          deliveryCost = cost;
        });
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: isSelected ? Colors.green : Colors.white,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey)),
              const SizedBox(height: 4),
              Text('\$${cost.toString()}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
