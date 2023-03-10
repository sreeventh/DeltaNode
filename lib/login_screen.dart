import 'package:flutter/material.dart';
import 'package:delta/sign_up.dart';
import 'package:delta/setup.dart';
import 'package:delta/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text('Sign-Up'),
                  ),
                ],
              ),
            ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        setData(_emailController.text.trim());
        // ignore: avoid_print
        print('Login successful');
        // Navigate to home page or set-up after successful login
        getto();
      } on FirebaseAuthException catch (e) {
        // ignore: avoid_print
        print('Login failed: $e');
        // Display a snackbar with an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password!')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> setData(useremail) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('uid', useremail);
  }

// navigation to set-up or home??
  final CollectionReference myCollectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> getto() async {
    try {
      DocumentSnapshot docSnapshot =
          await myCollectionRef.doc(_emailController.text.trim()).get();

      if (docSnapshot.exists) {
        // navigate to home
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Set()),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting field: $e');
    }
  }
}
