import 'dart:convert';
import 'package:e_nusantara/api/checkLogin.dart';
import 'package:e_nusantara/screens/checkout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_nusantara/screens/shipping_address.dart';

class ShippingDetailsScreen extends StatefulWidget {
  @override
  _ShippingDetailsScreenState createState() => _ShippingDetailsScreenState();
}

class _ShippingDetailsScreenState extends State<ShippingDetailsScreen> {
  final Checklogin _checklogin = new Checklogin();
  final String? baseUrl = dotenv.env['BASE_URL'];
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalController = TextEditingController();
  final _courierController = TextEditingController();

  Future<void> _submitShippingDetails() async {
     _checklogin.checkAndNavigate(context);
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    final shippingDetails = {
      'address': _addressController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'postal': _postalController.text,
      'courier': _courierController.text,
      'cost': 20000
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shipping'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(shippingDetails),
      );

      if (response.statusCode == 201) {
        final shippingId =
            jsonDecode(response.body)['shippingAddress']['shipping_id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutPage(shippingId: shippingId),
          ),
        );
      } else {
        throw 'Failed to submit shipping details';
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }
  }

  void _navigateToShippingAddressPage() {
     _checklogin.checkAndNavigate(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingAddressPage(),
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
        title: const Text(
          'Detail Alamat',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Kota',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Negara',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _postalController,
              decoration: const InputDecoration(
                labelText: 'Kode Pos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _courierController,
              decoration: const InputDecoration(
                labelText: 'Kurir',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    
                    onPressed: _submitShippingDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffDDA86B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    child: Text('Pilih Alamat'),
                    onPressed: _navigateToShippingAddressPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
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
}
