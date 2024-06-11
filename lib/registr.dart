import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes/main.dart';
import 'package:recipes/user_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();


  

  Future<void> _register() async {
    final formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      formState.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
    
          
    
    
  


        User? user = userCredential.user;
        MyApp.user = user;
        print(MyApp.user!.uid + _usernameController.text +_emailController.text);
        await FirebaseFirestore.instance.collection('users').doc(MyApp.user!.uid.toString()).set({"username":_usernameController.text, "email":_emailController.text, "following": [], "followers": []});


        

        // Registration successful
      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UserPage(uidd: MyApp.user!.uid.toString()), //// работало пока не было ыекштпп
  ),
);
      } catch (e) {
        // Handle registration error
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                
                style: TextStyle(color: Colors.white),
              ),

            TextFormField(  
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'username'),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'Please enter an username';
                  }
                  return null;
                },
                
                style: TextStyle(color: Colors.white),
              ),


              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (input) {
                  if (input == null || input.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white),
                obscureText: true,
              ),
              TextFormField(
                controller: _password2Controller,
                decoration: InputDecoration(labelText: 'Repeat Password'),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return 'Please repeat the password';
                  } else if (input != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white),
                obscureText: true,
                cursorColor: Colors.white,
              ),
              SizedBox(height: 20),
              ElevatedButton(
            
                
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
