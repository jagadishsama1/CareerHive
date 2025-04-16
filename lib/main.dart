import 'package:career_hive/core/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Hive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Arial'),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<String> roles = ['Student', 'Employer', 'Admin'];
  String selectedRole = 'Student';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  
  void checkValues() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();


    if (email == "" || password == "") {
      Get.snackbar(
        "Message",
        "Please fill all the fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      signUp(email, password);
    }
  }

void signUp(String email, String password) async {
  UserCredential? credential;

  // UIHelper.showLoadingDialog(context, "Creating new account..");

  try {
    // Check if the email already exists in Firestore
    QuerySnapshot existingUserSnapshot = await FirebaseFirestore.instance
        .collection("Registered Users")
        .where("email", isEqualTo: email)
        .get();

    if (existingUserSnapshot.docs.isNotEmpty) {
      var existingUserData = existingUserSnapshot.docs.first.data() as Map<String, dynamic>;

      // If the user was deleted, prevent sign-up
      if (existingUserData.containsKey("isDeleted") &&
          existingUserData["isDeleted"] == true) {
        Navigator.pop(context);
        Get.snackbar(
          "Sign Up Error",
          "This email has been Blocked by an admin.",
          backgroundColor: Colors.red,
          colorText: Colors.black,
        );
        return;
      }

      // If email exists and not deleted, prevent new sign-up
      Navigator.pop(context);
      Get.snackbar(
        "Sign Up Error",
        "The email address is already in use by another account.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Create new account in FirebaseAuth
    credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (ex) {
    Navigator.pop(context);
    Get.snackbar(
      "Sign Up Error",
      ex.message!,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    print(ex.message.toString());
    return;
  }

  String uid = credential.user!.uid;
  UserModel newUser = UserModel(
    uid: uid,
    email: email,
    fullname: "",
    profilePic: "",
    role: "student",
    isDeleted: false,
    timeStamp: Timestamp.now(),
  );

  await FirebaseFirestore.instance
      .collection("Registered Users")
      .doc(uid)
      .set(newUser.tomap())
      .then((value) {

      print("👍👍👍👍👍👍User Created Successfully");
    // Navigator.popUntil(context, (route) => route.isFirst);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return CompleteProfile(
    //         userModel: newUser, firebaseUser: credential!.user!);
    //   }),
    // );
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top navigation
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/career_hive_logo.svg',
                          height: 40,
                          width: 40,
                          semanticsLabel: 'My Icon',
                        ),
                      ),
                    ),

                    const SizedBox(height: 120),

                    // ECA Logo
                    Center(
                      child: Image.asset('assets/images/eca.png', height: 45),
                    ),

                    const SizedBox(height: 20),

                    // Login Form
                    Center(
                      child: SizedBox(
                        width: 400,
                        child: Column(
                          children: [
                            Text(
                              '$selectedRole Login',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A2B5D),
                              ),
                            ),

                            const SizedBox(height: 30),

                            DropdownButtonFormField<String>(
                              value: selectedRole,
                              items:
                                  roles.map((String role) {
                                    return DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(role),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRole = newValue!;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Select Role',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            // Email input
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email Address',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Password input
                            TextField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                 checkValues();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFCDD0EA),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Log in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Forgot password
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Forgot your password?',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Reset here',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
