import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/auth_controller.dart';


class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});
  static String verify = "";

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController=TextEditingController();

  void phoneVerification() {
    ref.read(authControllerProvider.notifier).
    phoneSignIn(context: context, phoneNumber: "+91${phoneController.text.trim()}");
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/phone_icon.png",height: h*0.15,),
              SizedBox(height: h*0.03,),
              const Row(
                children: [
                  Text("Enter Phone Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
              SizedBox(height: h*0.01,),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value?.length != 10) {
                    return 'Please enter valid No';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: w*0.03,bottom: w*0.01),
                    hintText: "Enter Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w*0.02),
                    )
                ),
              ),
              SizedBox(height: h*0.01,),
              RichText(
                text: const TextSpan(
                  text: 'By Continuing, I agree to TotalX\'s',
                  style: TextStyle(
                    color: Colors.black
                  ),
                  children: <TextSpan>[
                    TextSpan(text: ' Terms and condition',
                        style: TextStyle(
                            color: Colors.blue
                        )),
                    TextSpan(text: ' & '),
                    TextSpan(text: 'privacy policy',
                        style: TextStyle(
                            color: Colors.blue
                        )),
                  ],
                ),
              ),
              SizedBox(height: h*0.02,),
              ElevatedButton(
                onPressed: () {
                  print("bbtoon prrrtyfed");
                  if(_formKey.currentState!.validate()) {
                    // FirebaseFirestore.instance.collection("aaa").add({"data":"22"});
                    phoneVerification();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(w*0.9, h*0.065),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w*0.08),
                  ),
                ),
                child:  Text("Get OTP",
                    style: TextStyle(color: Colors.white,
                        fontSize: w*0.045,
                        fontWeight: FontWeight.bold)),
              ),
          ],),
        ),
      ),
    );
  }
}
