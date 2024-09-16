import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loginscreen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool _isObscured = true;

  void register() async {
    setState(() {
      isLoading = true;
    });

    // Assign values from the controllers
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful. Please log in.')),
        );
        Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
      }
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'The email address is badly formatted.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'Registration failed. ${e.message}';
        }
      } else {
        errorMessage = 'An unknown error occurred.';
      }

      print('Registration Error: $errorMessage');

      // Show the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: _emailController,
              decoration: InputDecoration(
                label: Text(
                  'Email',
                  style: TextStyle(color: Colors.black),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.email_sharp,
                    color: Colors.black,
                    size: 15,
                  ),
                  onPressed: () {},
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Email Id';
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: _passwordController,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                label: Text(
                  'Password',
                  style: TextStyle(color: Colors.black),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
              obscureText: _isObscured,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: Text('Register'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text('Click if user has already Registered'),
            ),
          ],
        ),
      ),
    );
  }
}
