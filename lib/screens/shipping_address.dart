import 'package:flutter/material.dart';
import 'shipping_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:e_nusantara/screens/checkout.dart';
import 'package:e_nusantara/screens/shipping_details.dart';

int? selectedShippingId;

class ShippingAddressPage extends StatefulWidget {
  final int total;

  const ShippingAddressPage({super.key, required this.total});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final String? baseUrl = dotenv.env['BASE_URL'];
  List<Map<String, dynamic>> addresses = [];

  //selected address index
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    fetchShippingAddress();
  }

  Future<void> fetchShippingAddress() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/shipping'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          addresses = data
              .map((item) => {
                    'shipping_id': item['shipping_id'],
                    'address': item['address'],
                    'city': item['city'],
                    'country': item['country'],
                    'postal': item['postal'],
                    'courier': item['courier'],
                    'cost': item['cost'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to fetch shipping addresses');
      }
    } catch (error) {
      print('Error fetching shipping adddress $error');
    }
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
        title: const Text(
          'Shipping Addresses',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        address["city"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address: ${address["address"]!}',
                              style: const TextStyle(fontSize: 14)),
                          Text('Country: ${address["country"]!}',
                              style: const TextStyle(fontSize: 14)),
                          Text('Postal Code: ${address["postal"]!}',
                              style: const TextStyle(fontSize: 14)),
                          Text('Courier: ${address["courier"]!}',
                              style: const TextStyle(fontSize: 14)),
                          Text('Cost: RP${address["cost"]} ',
                              style: const TextStyle(fontSize: 14)),
                          Row(
                            children: [
                              Checkbox(
                                value: selectedIndex == index,
                                onChanged: (value) {
                                  setState(() {
                                    selectedIndex = index;
                                    selectedShippingId = address['shipping_id'];
                                  });
                                },
                              ),
                              const Text(
                                'Use as the shipping address',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: selectedShippingId == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              shippingId: selectedShippingId!,
                              total: widget.total,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffDDA86B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShippingDetailsScreen(total: widget.total),
            ),
          ).then((_) {
            fetchShippingAddress();
          });
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
