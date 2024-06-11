import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    
    setState(() {
      _isLoading = true;
    });
      try {
 
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      User? user = userCredential.user;
      MyApp.user = user;
      MyApp.uid = user?.uid??"null";
      
     
      print(user);

      MyApp.getUserInfo(user?.uid??"null");
          setState(() {
      _isLoading = false;
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    });
     
       }catch (e) {
        print(e);
         Navigator.pushNamed(context, "/auth");
      }
 


  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Login'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 6.0),
                  TextButton(
                    
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text('Register'),
                  ),

                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                    
                  ),
                ],
              ),
            ),
    );
  }
}