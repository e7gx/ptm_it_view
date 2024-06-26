// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/home_page_admin.dart';
import 'package:first_time/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:first_time/Auth/reset_password.dart';

import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureTextSET = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final bool isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AdminHomePage(),
        ),
      );
    }
  }

  Future<void> signInAdmin(String email, String password) async {
    try {
      // عرض مربع الحوار "جارٍ التحميل"
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/animation/green.json', height: 200),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    S.of(context).Loading,
                    style: const TextStyle(
                        fontFamily: 'Cario',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // تحقق من Firestore إذا كان المستخدم لديه صلاحيات المسؤول
        QuerySnapshot<Map<String, dynamic>> adminSnapshot =
            await FirebaseFirestore.instance
                .collection('Admin')
                .where('email', isEqualTo: email)
                .limit(1)
                .get();

        // إغلاق مربع الحوار "جارٍ التحميل"
        Navigator.of(context).pop();

        if (adminSnapshot.docs.isNotEmpty) {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setBool('isLoggedIn', true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AdminHomePage(),
            ),
          );
        } else {
          showErrorDialog(S.of(context).Admin_Access);
        }
      }
    } on FirebaseAuthException catch (e) {
      // إغلاق مربع الحوار "جارٍ التحميل"
      Navigator.of(context).pop();
      showErrorDialog('${e.code}\n ${S.of(context).validData}');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animation/WOR.json',
                  width: 150, height: 200),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cario',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: S.of(context).validData,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).Okay,
                style: const TextStyle(
                    fontFamily: 'Cario',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).Admin,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cario',
          ),
        ),
        centerTitle: true,
        toolbarHeight: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(7000),
          ),
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Lottie.asset(
            'assets/animation/afterAfect.json',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Lottie.asset(
            'assets/animation/green.json',
            fit: BoxFit.fill,
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset(
                    'assets/animation/green.json',
                    width: 500.0,
                    height: 230.0,
                  ),
                  Text(
                    S.of(context).loginNew,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                      fontFamily: 'Cario',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 16,
                      shadowColor: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          showCursor: true,
                          style: const TextStyle(color: Colors.teal),
                          controller: emailController,
                          cursorColor: Colors.teal,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: S.of(context).email,
                            labelStyle: const TextStyle(
                                fontFamily: 'Cario',
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: Colors.teal),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 16,
                      shadowColor: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.teal),
                          controller: passwordController,
                          obscureText: obscureTextSET,
                          cursorColor: Colors.teal,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            suffix: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureTextSET = !obscureTextSET;
                                });
                              },
                              child: Icon(
                                size: 20,
                                color: Colors.teal,
                                obscureTextSET
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            labelText: S.of(context).password,
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cario',
                                color: Colors.teal),
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Colors.teal),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPasswordPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.teal,
                        ),
                        child: Text(
                          S.of(context).Forgot_password,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: 'Cario',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32.0),
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/animation/WOR.json',
                                      height: 200),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      S.of(context).LoginAlertEmailPassword,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cario',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    S.of(context).register_assets_Ok,
                                    style: const TextStyle(
                                        fontFamily: 'Cario',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      await signInAdmin(email, password);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 65.0),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      S.of(context).loginNew,
                      style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily: 'Cario',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
