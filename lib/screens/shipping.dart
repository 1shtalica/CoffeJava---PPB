import 'package:flutter/material.dart';

class ShippingAddress extends StatefulWidget {
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  String selectedAddress = 'Home';
  String defaultAddress = 'Home';

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Shipping Address',
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
                  title: 'Home',
                  selected: selectedAddress == 'Home',
                  onTap: () {
                    setState(() {
                      selectedAddress = 'Home';
                    });
                  },
                ),
                TabButton(
                  title: 'Office',
                  selected: selectedAddress == 'Office',
                  onTap: () {
                    setState(() {
                      selectedAddress = 'Office';
                    });
                  },
                ),
                TabButton(
                  title: 'Other',
                  selected: selectedAddress == 'Other',
                  onTap: () {
                    setState(() {
                      selectedAddress = 'Other';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  String addressTitle = selectedAddress + ' $index';
                  return AddressCard(
                    title: addressTitle,
                    isDefault: defaultAddress == addressTitle,
                    onSetDefault: () {
                      setState(() {
                        defaultAddress = addressTitle;
                      });
                    },
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

  TabButton({required this.title, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Color(0xFFDDA86B) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 8),
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

class AddressCard extends StatelessWidget {
  final String title;
  final bool isDefault;
  final VoidCallback onSetDefault;

  AddressCard({
    required this.title,
    required this.isDefault,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.contains('Home')
                  ? 'Home Address'
                  : title.contains('Office')
                      ? 'Office Address'
                      : 'Other Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text('123 Main St, Suite 1, City, Country'),
            SizedBox(height: 4),
            Text('Postal Code: 12345'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isDefault ? 'Default Address' : '',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isDefault)
                  OutlinedButton(
                    onPressed: onSetDefault,
                    child: Text('Set as Default'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
