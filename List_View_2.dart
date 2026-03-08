import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<MyApp> {
  List<String> items = ['Burger','Sandwich','Idly','Dosa','Uttapam','Butter Roll'];
  List<int> qty = [0, 0, 0, 0, 0, 0];

  int get totalItems => qty.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context)
  
  {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text('MyKitchen'),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
                if (totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('$totalItems', style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
              ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.blueAccent, width: 1),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15.0),
                          title: Text(
                            items[index],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                onPressed: qty[index] > 0
                                    ? () => setState(() => qty[index]--)
                                    : null,
                              ),
                              Text(
                                '${qty[index]}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () => setState(() => qty[index]++),
                            ),
                             ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

     
            if (totalItems > 0)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, -2))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$totalItems item${totalItems > 1 ? 's' : ''} in cart',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {},
                      child: Text('Place Order'),
                    ),
                  ],
                ),
              ),
      ],
        ),
      ),
    );
  }
}
