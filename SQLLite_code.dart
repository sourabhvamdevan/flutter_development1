import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for desktop
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class DBHelper {
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), "users.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          password TEXT NOT NULL
        )
        ''');
      },
    );
  }

  Future<int> insertUser(String name, String password) async {
    final db = await database;

    return await db.insert(
      "users",
      {"name": name, "password": password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  String message = "";

  Future<void> saveUser() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => message = "Please fill all fields");
      return;
    }

    try {
      await DBHelper.instance.insertUser(
        nameController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() => message = "User saved successfully");

      nameController.clear();
      passwordController.clear();
    } catch (e) {
      setState(() => message = "Database error: $e");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[200],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextFormField(
                controller: nameController,
                decoration: inputStyle("Username", Icons.person),
                validator: (value) =>
                    value!.isEmpty ? "Enter username" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: inputStyle("Password", Icons.lock),
                validator: (value) =>
                    value!.isEmpty ? "Enter password" : null,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveUser,
                  child: const Text("Login"),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
