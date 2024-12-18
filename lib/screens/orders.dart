import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../api/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String selectedTab = 'paid';
  List<dynamic> orders = [];
  bool isLoading = true;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();
  String id = "";

  @override
  void initState() {
    super.initState();
    _initializeProfile();
    fetchOrders();
  }

  void _initializeProfile() async {
    final result = await _authService.decodeProfile(context);
    setState(() {
      id = result['id'];
    });
  }

  Future<void> fetchOrders() async {
    final String? baseUrl = dotenv.env['BASE_URL'];
    final String apiUrl = '$baseUrl/order/$id';
    final token = await storage.read(key: 'accessToken');

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response data: $data");

        if (data != null && data is List) {
          setState(() {
            orders = data;
            isLoading = false;
          });
        } else {
          setState(() {
            orders = [];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching orders: $e');
    }
  }

  void updateTab(String status) {
    setState(() {
      selectedTab = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredOrders =
        orders.where((order) => order['status'] == selectedTab).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TabButton(
                  title: 'Paid',
                  selected: selectedTab == 'paid',
                  onTap: () => updateTab('paid'),
                ),
                TabButton(
                  title: 'Pending',
                  selected: selectedTab == 'pending',
                  onTap: () => updateTab('pending'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredOrders.isEmpty
                    ? const Center(child: Text("No orders available"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return OrderCard(
                              status: order['status'],
                              orderId: order['order_id'],
                              createdAt: order['createdAt'],
                              quantity: order['ordersItem'][0]['quantity'],
                              totalPrice: order['ordersItem'][0]['total_price'],
                              courier: order['shipping']['courier'],
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFDDA86B) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String status;
  final String orderId;
  final String createdAt;
  final int quantity;
  final double totalPrice;
  final String courier;

  const OrderCard({
    super.key,
    required this.status,
    required this.orderId,
    required this.createdAt,
    required this.quantity,
    required this.totalPrice,
    required this.courier,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Order ID: $orderId',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  createdAt.substring(0, 10),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Courier: $courier'),
            const SizedBox(height: 4),
            Text('Quantity: $quantity'),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount: ${totalPrice.toStringAsFixed(2)}\$',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: status == 'paid'
                        ? Colors.green
                        : status == 'pending'
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
