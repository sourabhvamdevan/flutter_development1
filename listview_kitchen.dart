import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}



class FoodItem {
  final String name;
  final int price;
  final String image;

  const FoodItem({
    required this.name,
    required this.price,
    required this.image,
  });
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.orange,
      ),
      home: KitchenApp(
        isDarkMode: _isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}


class KitchenApp extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const KitchenApp({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<KitchenApp> createState() => _KitchenAppState();
}

class _KitchenAppState extends State<KitchenApp> {
  final List<FoodItem> _menu = const [
    FoodItem(name: 'Burger', price: 120, image: 'asset/images/Cheeseburger.jpg'),
    FoodItem(name: 'Samosa', price: 25, image: 'asset/images/Samosa.jpg'),
    FoodItem(name: 'Sandwich', price: 120, image: 'asset/images/Sandwich.jpg'),
    FoodItem(name: 'Kachori', price: 25, image: 'asset/images/Kachori.jpg'),
    FoodItem(name: 'Momos', price: 80, image: 'asset/images/Momos.jpg'),
    FoodItem(name: 'Idly', price: 60, image: 'asset/images/Idli.JPG'),
    FoodItem(name: 'Dosa', price: 85, image: 'asset/images/Dosa.jpg'),
  ];

  final Map<FoodItem, int> _cart = {};
  int _currentIndex = 0;

  void _addToCart(FoodItem item) {
    setState(() {
      _cart[item] = (_cart[item] ?? 0) + 1;
    });
  }

  void _removeFromCart(FoodItem item) {
    setState(() {
      if (_cart[item]! > 1) {
        _cart[item] = _cart[item]! - 1;
      } else {
        _cart.remove(item);
      }
    });
  }

  int get _totalPrice {
    return _cart.entries.fold(
      0,
      (sum, e) => sum + (e.key.price * e.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(menu: _menu, cart: _cart, onAdd: _addToCart),
      CartPage(cart: _cart, onRemove: _removeFromCart),
      CheckoutPage(cart: _cart, total: _totalPrice),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Kitchen', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Text('My Kitchen', style: TextStyle(fontSize: 24)),
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: widget.isDarkMode,
              onChanged: (_) => widget.toggleTheme(),
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.menu_book), label: 'Menu'),
          NavigationDestination(
            icon: Badge(label: Text('${_cart.length}'), child: const Icon(Icons.shopping_cart)),
            label: 'Cart',
          ),
          const NavigationDestination(icon: Icon(Icons.payment), label: 'Checkout'),
        ],
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  final List<FoodItem> menu;
  final Map<FoodItem, int> cart;
  final void Function(FoodItem) onAdd;

  const HomePage({
    super.key,
    required this.menu,
    required this.cart,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menu.length,
      itemBuilder: (context, index) {
        final item = menu[index];
        final qty = cart[item] ?? 0;

        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Image.asset(item.image, width: 50),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('₹${item.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Qty: $qty'),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.orange),
                  onPressed: () => onAdd(item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



class CartPage extends StatelessWidget {
  final Map<FoodItem, int> cart;
  final void Function(FoodItem) onRemove;

  const CartPage({
    super.key,
    required this.cart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return ListView(
      children: cart.entries.map((e) {
        return ListTile(
          title: Text(e.key.name),
          subtitle: Text('Qty: ${e.value}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('₹${e.key.price * e.value}'),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => onRemove(e.key),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}



class CheckoutPage extends StatelessWidget {
  final Map<FoodItem, int> cart;
  final int total;

  const CheckoutPage({
    super.key,
    required this.cart,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Checkout', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text('No items to checkout'))
                : ListView(
              children: cart.entries.map((e) {
                return ListTile(
                  title: Text(e.key.name),
                  trailing: Text('₹${e.key.price * e.value}'),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Text('Total: ₹$total', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: cart.isEmpty ? null : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order Placed Successfully')),
              );
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}
