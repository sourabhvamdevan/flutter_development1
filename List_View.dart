import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KitchenScreen(),
    );
  }
}

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  final List<String> _items = [
    'Burger',
    'Sandwich',
    'Idly',
    'Dosa',
    'Uttapam',
    'Butter Roll',
  ];

  final List<int> _qty = List.filled(6, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyKitchen'),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return _MenuItemCard(
              itemName: _items[index],
              quantity: _qty[index],
            );
          },
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final String itemName;
  final int quantity;

  const _MenuItemCard({
    required this.itemName,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blueAccent),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          title: Text(
            itemName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            'Qty: $quantity',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
