import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget

{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );


    
  }

  
}

class HomePage extends StatefulWidget

{
  const HomePage({Key? key}):super(key: key);

  @override

  _HomePageState createState()=>_HomePageState();

  
}

class _HomePageState extends State<HomePage>

{
  @override
  Widget build(BuildContext context)
  
  {
    return Scaffold
      (
      appBar: AppBar(
        title: const Text("GeeksForGeeks"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),

            
          ),
          onPressed: () {
            
            showDialog(
              context: context,
              builder: (ctx)=>AlertDialog(
                title:const Text("Alert Dialog Box"),
                content:const Text("You have raised an Alert Dialog Box"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    
                child: const Text("okay"),
                  ),

                  
          ],
              ),
            );
          },
          child: const Text("Show alert Dialog box"),
    ),
      ),
    );
  }
}
