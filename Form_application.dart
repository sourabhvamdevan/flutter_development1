import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: LoginForm()));
}

class LoginForm extends StatefulWidget
{
  @override
  LoginFormState createState()=>LoginFormState();
}

class LoginFormState extends State<LoginForm>
{
  final _formKey = GlobalKey<FormState>();
  String message = '';
  bool _obscurePassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void myValidator()
  {
    if (_formKey.currentState!.validate()) {
      setState(()
               {
        message='Login successful';
      });
    } else
    {
      setState(() {
        message = 'Kindly fill all details';
      });
    }
    nameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Form')),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),

                  
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
              }
                  return null;
                   },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: myValidator,
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  color: message == 'Login successful'
                      ? Colors.green
                      : Colors.red,
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
