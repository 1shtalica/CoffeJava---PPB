// import 'package:flutter/material.dart';

// import '../services/api_service.dart';

// class PaymentScreen extends StatefulWidget {
//   final String authToken;

//   const PaymentScreen({Key? key, required this.authToken}) : super(key: key);

//   @override
//   PaymentScreenState createState() => PaymentScreenState();
// }

// class PaymentScreenState extends State<PaymentScreen> {
//   final ApiService apiService = ApiService();
//   bool isloading = false;

//   void initiateTransaction() async {
//     setState(() {
//       isloading = true;
//     });

//     final transactionData = {
//       "shipping_id": "1", //replace with user input
//       "payment_type": "ovo",
//     };

//     try {
//       final response = await apiService.processTransaction(
//           widget.authToken, transactionData);

//       final snapRedirectUrl = response['transaction']['redirect_url'];
//       showSnapPaymentPage(snapRedirectUrl);
//     } catch (error) {
//       print('Error initiating transaction $error');
//       showErrorDialog('Transaction failed');
//     } finally {
//       setState(() {
//         isloading = false;
//       });
//     }
//   }

//   void showSnapPaymentPage(String snapRedirectUrl) {
//     print('Redirecting to Snap payment page: $snapRedirectUrl');
//   }

//   void showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: initiateTransaction,
//           child: Text('Initiate Transaction'),
//         ),
//       ),
//     );
//   }
// }
