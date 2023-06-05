import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mySignUp extends StatefulWidget {
  const mySignUp({Key? key}) : super(key: key);

  @override
  _mySignUpState createState() => _mySignUpState();
}

class _mySignUpState extends State<mySignUp> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Image.asset(
              'assets/images/tel.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 240,
            ),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),
              myTextField("Enter Email id", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 30,
              ),
              myTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 30,
              ),

              mySignInButton(context, false, () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignIn()));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User Already Exists !',
                          textAlign: TextAlign.center,),
                        backgroundColor: Colors.red, // Couleur de fond personnalisée
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  print(e);
                }
              }),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}