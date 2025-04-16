import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool passwordVisible = false.obs;
  final RxString selectedRole = 'Student'.obs;
  final List<String> roles = ['Student', 'Employer', 'Admin'];

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
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

  //   UserCredential? credential;

  // // UIHelper.showLoadingDialog(context, "Creating new account..");

  // try {
  //   // Check if the email already exists in Firestore
  //   QuerySnapshot existingUserSnapshot = await FirebaseFirestore.instance
  //       .collection("Registered Users")
  //       .where("email", isEqualTo: email)
  //       .get();

  //   if (existingUserSnapshot.docs.isNotEmpty) {
  //     var existingUserData = existingUserSnapshot.docs.first.data() as Map<String, dynamic>;

  //     // If the user was deleted, prevent sign-up
  //     if (existingUserData.containsKey("isDeleted") &&
  //         existingUserData["isDeleted"] == true) {
  //       Navigator.pop(context);
  //       Get.snackbar(
  //         "Sign Up Error",
  //         "This email has been Blocked by an admin.",
  //         backgroundColor: Colors.red,
  //         colorText: Colors.black,
  //       );
  //       return;
  //     }

  //     // If email exists and not deleted, prevent new sign-up
  //     Navigator.pop(context);
  //     Get.snackbar(
  //       "Sign Up Error",
  //       "The email address is already in use by another account.",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   // Create new account in FirebaseAuth
  //   credential = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(email: email, password: password);
  // } on FirebaseAuthException catch (ex) {
  //   Navigator.pop(context);
  //   Get.snackbar(
  //     "Sign Up Error",
  //     ex.message!,
  //     backgroundColor: Colors.red,
  //     colorText: Colors.white,
  //   );
  //   print(ex.message.toString());
  //   return;
  // }

  // String uid = credential.user!.uid;
  // UserModel newUser = UserModel(
  //   uid: uid,
  //   email: email,
  //   fullname: "",
  //   profilePic: "",
  //   role: "student",
  //   isDeleted: false,
  //   timeStamp: Timestamp.now(),
  // );

  // await FirebaseFirestore.instance
  //     .collection("Registered Users")
  //     .doc(uid)
  //     .set(newUser.tomap())
  //     .then((value) {

  //     print("👍👍👍👍👍👍User Created Successfully");
  //   // Navigator.popUntil(context, (route) => route.isFirst);
  //   // Navigator.pushReplacement(
  //   //   context,
  //   //   MaterialPageRoute(builder: (context) {
  //   //     return CompleteProfile(
  //   //         userModel: newUser, firebaseUser: credential!.user!);
  //   //   }),
  //   // );
  // });
    // Add your sign-up logic here
    Get.snackbar(
      "Sign Up",
      "Sign-up logic not implemented yet",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}