// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';
import '../constant.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool visible = false;
  register() async {
    setState(() {
      visible = true;
      Loader.show(context,
          isAppbarOverlay: true,
          isBottomBarOverlay: false,
          progressIndicator: const CircularProgressIndicator(),
          themeData: Theme.of(context).copyWith(
              colorScheme:
                  ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
          overlayColor: const Color(0x99E8EAF6));
      Future.delayed(const Duration(seconds: 3), () {
        Loader.hide();
      });
    });
    // print(params);
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      try {
        final res = await http.post(Uri.parse(BaseURL.register), body: {
          "username": userNameController.text,
          "password": passwordController.text,
          "email": emailController.text,
        });
        if (res.statusCode == 200) {
          var response = json.decode(res.body);
          if (response['value'] != 1) {
            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white70,
                          child: const Icon(
                            Icons.password_rounded,
                            size: 60,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.redAccent,
                          child: SizedBox.expand(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Username telah digunakan",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            50), // <-- Radius
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Text('Ok',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black87)),
                                    onPressed: () => {
                                      setState(() {
                                        visible = false;
                                      }),
                                      Navigator.of(context).pop()
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (response['value'] == 1) {
            setState(
              () {
                visible = false;
              },
            );
            //alertdialog
            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white70,
                          child: const Icon(
                            Icons.password_rounded,
                            size: 60,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: kgreen,
                          child: SizedBox.expand(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Akun berhasil di daftarkan",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            50), // <-- Radius
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Text('Ok',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black87)),
                                    onPressed: () => {
                                      setState(() {
                                        visible = false;
                                      }),
                                      Navigator.of(context).pop()
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
      } catch (e) {
        return null;
      }
    } else {
      setState(
        () {
          visible = false;
        },
      );
      //alertdialog
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white70,
                    child: const Icon(
                      Icons.password_rounded,
                      size: 60,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.redAccent,
                    child: SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Data tidak boleh kosong !",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(50), // <-- Radius
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Text('Ok',
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.black87)),
                              onPressed: () => {
                                setState(() {
                                  visible = false;
                                }),
                                Navigator.of(context).pop()
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    Loader.hide();
    print("Called dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.sp,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.sp,
            ),
            Text(
              "Buat Akun,",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              "Daftar untuk memulai!",
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Column(
                children: <Widget>[
                  TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.people_alt_outlined, color: kgrey),
                      labelText: "Username",
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline, color: kgrey),
                      labelText: "Email ID",
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, color: kgrey),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: InkWell(
                      onTap: register,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        decoration: BoxDecoration(
                            color: kgreen,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: kwhite,
                                ),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Icon(
                                Icons.arrow_forward_sharp,
                                color: kwhite,
                              )
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sudah punya akun ? ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Sign in.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 12.sp),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
