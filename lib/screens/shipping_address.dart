// import 'package:flutter/material.dart';
// import 'shipping_details.dart';

// class ShippingAddressPage extends StatefulWidget {
//   const ShippingAddressPage({super.key});

//   @override
//   State<ShippingAddressPage> createState() => _ShippingAddressPageState();
// }

// class _ShippingAddressPageState extends State<ShippingAddressPage> {
//   // Mock shipping addresses
//   final List<Map<String, String>> addresses = [
//     {
//       "name": "Jane Doe",
//       "address": "3 Newbridge Court\nChino Hills, CA 91709, United States"
//     },
//     {
//       "name": "John Doe",
//       "address": "3 Newbridge Court\nChino Hills, CA 91709, United States"
//     },
//     {
//       "name": "John Doe",
//       "address": "51 Riverside\nChino Hills, CA 91709, United States"
//     },
//   ];

//   // Selected address index
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Shipping Addresses',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: addresses.length,
//                 itemBuilder: (context, index) {
//                   final address = addresses[index];
//                   return Card(
//                     elevation: 3,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         address["name"]!,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             address["address"]!,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: selectedIndex == index,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedIndex = index;
//                                   });
//                                 },
//                               ),
//                               const Text(
//                                 'Use as the shipping address',
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       trailing: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AddressDetailPage(
//                                 addressDetails: {
//                                   'label': 'Home',
//                                   'fullAddress': address["address"]!,
//                                   'courierNotes': '',
//                                   'recipientName': address["name"]!,
//                                   'phoneNumber': '1234567890',
//                                 },
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           'Edit',
//                           style: TextStyle(
//                             color: Color(0xffDDA86B),
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddressDetailPage(),
//             ),
//           );
//         },
//         backgroundColor: Colors.black,
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }
