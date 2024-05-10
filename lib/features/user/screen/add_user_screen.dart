import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/global.dart';
import '../controller/user_controller.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key});

  @override
  ConsumerState<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  addUser(){
    ref.read(userControllerProvider.notifier).
    addUsers(name: nameController.text.trim(),
        age: int.tryParse(ageController.text.trim())??0,
        file: ref.watch(imageFile)!,
        phoneNumber: numberController.text.trim(),
        context: context);
  }

  TextEditingController nameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  TextEditingController numberController=TextEditingController();

  final imageFile=StateProvider<File?>((ref) => null);
  void selectImage() async {
    final res= await pickImage();
    if(res !=null){
      ref.watch(imageFile.notifier).update((state) => File(res.path));
    }
  }
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final file=ref.watch(imageFile);
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;

    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h*0.01,),
                 Text("Add A New User",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: w*0.05
                ),),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      file!=null?
                      Container(
                        height: h*0.15,
                        width: w*0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                            image: DecorationImage(image: FileImage(file),fit: BoxFit.fill)
                        ),
                      ):
                      CircleAvatar(
                        radius: w*0.2,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(Icons.person,color: Colors.blue,size: w*0.25,),
                      ),
                      Positioned(
                        bottom: 0,
                        right: w*0.04,
                        left: w*0.04,
                        child: InkWell(
                          onTap: () {
                            selectImage();
                          },
                          child: Container(
                            height: h*0.04,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.only(
                                  bottomLeft:Radius.circular(w*0.1),
                                  bottomRight:Radius.circular(w*0.1),
                              )
                            ),
                            child: const Icon(Icons.camera_alt_outlined,color: Colors.white,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: h*0.02,),
                const Text("Name",
                style: TextStyle(
                  color: Colors.grey
                ),),
                SizedBox(height: h*0.01,),
                TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    var val = value ?? '';
                    if (val.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: w*0.03,bottom: w*0.01),
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.02),
                      )
                  ),
                ),
                SizedBox(height: h*0.015,),
                const Text("Age",
                style: TextStyle(
                  color: Colors.grey
                ),),
                SizedBox(height: h*0.01,),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    var val = value ?? '';
                    if (val.isEmpty) {
                      return 'Please enter Age';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: w*0.03,bottom: w*0.01),
                      hintText: "Enter Age",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.02),
                      )
                  ),
                ),
                SizedBox(height: h*0.015,),
                const Text("Phone No.",
                style: TextStyle(
                  color: Colors.grey
                ),),
                SizedBox(height: h*0.01,),
                TextFormField(
                  controller: numberController,
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
                      hintText: "Enter Phone No.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w*0.02),
                      )
                  ),
                ),
                SizedBox(height: h*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: h*0.045,
                        width: w*0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(w*0.03),
                        ),
                        child: const Center(child: Text("Cancel",
                        style: TextStyle(
                          color: Colors.grey
                        ),),),
                      ),
                    ),
                    SizedBox(width: w*0.03,),
                    InkWell(
                      onTap: () {
                        if(_formKey.currentState!.validate() && file!=null){
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              contentTextStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: w*0.05
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(w*0.05)
                              ),
                              actionsPadding: EdgeInsets.only(bottom: h*0.05),
                              content: SizedBox(
                                height: h*0.07,
                                width: w*0.25,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Are you sure Upload?"),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(w*0.1, h*0.06),
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(h*0.02),
                                        side: const BorderSide(color: Colors.white)
                                    ),
                                  ),
                                  child:  Text('Cancel',
                                    style: TextStyle(
                                        fontSize: w*0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    addUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(w*0.1, h*0.06),
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(h*0.02),
                                        side: const BorderSide(color: Colors.white)
                                    ),
                                  ),
                                  child:  Text("Upload",
                                    style: TextStyle(
                                        fontSize: w*0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }else{
                          file==null? showMessage(context, text: "Please Select Image", color: Colors.red):null;
                        }

                      },
                      child: Container(
                        height: h*0.045,
                        width: w*0.3,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(w*0.03),
                        ),
                        child: const Center(child: Text("Save",
                        style: TextStyle(
                          color: Colors.white
                        ),),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}