import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../core/common/error_text.dart';
import '../../../core/common/global.dart';
import '../../../core/common/loader.dart';
import '../../../model/user_model.dart';
import '../controller/user_controller.dart';
import 'add_user_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController searchController=TextEditingController();
  final radioVal=StateProvider<String>((ref) => "All") ;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final radioValue=ref.watch(radioVal);
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.location_on,color: Colors.white,),
        title: const Text("Nilambur",
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add,color: Colors.white,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUserScreen(),));
          },),
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      // height: h * 0.055,
                      // width: w,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          ref.watch(searchUserProvider.notifier)
                              .update((state) => value.trim());
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: w * 0.02, vertical: w * 0.02),
                          hintText: 'search by name & no.',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF1F4F8),
                          prefixIcon: const Icon(
                            Icons.search_outlined,
                            color: Color(0xFF57636C),
                          ),
                          suffixIcon:
                          ref.watch(searchUserProvider).isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              ref.read(searchUserProvider.notifier).update((state) => "");
                            },
                          )
                              : const Icon(
                            Icons.shop,
                            color: Colors.transparent,
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF1D2429),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: w*0.03,),
                  Expanded(
                    flex: 1,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(w * 0.06),
                                    topRight: Radius.circular(w * 0.06))),
                            builder: (context) {
                              return Container(
                                height: h*0.35,
                                width: w,
                                padding: EdgeInsets.only(top: h*0.02,left: w*0.03),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("  Sort",
                                      style: TextStyle(
                                          fontSize: w*0.05,
                                          fontWeight: FontWeight.w800
                                      ),),
                                    SizedBox(height: h*0.01,),
                                    Row(children: [
                                      Radio(
                                        value: "All",
                                        activeColor: Colors.blue,
                                        groupValue: radioValue,
                                        onChanged: (value) {
                                          ref.watch(radioVal.notifier).update((state) => value!);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      const Text("All"),
                                    ],),
                                    Row(children: [
                                      Radio(
                                        value: "Elder",
                                        activeColor: Colors.blue,
                                        groupValue: radioValue,
                                        onChanged: (value) {
                                          ref.watch(radioVal.notifier).update((state) => value!);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      const Text("Age: Elder"),
                                    ],),
                                    Row(children: [
                                      Radio(
                                        value: "Younger",
                                        activeColor: Colors.blue,
                                        groupValue: radioValue,
                                        onChanged: (value) {
                                          ref.watch(radioVal.notifier).update((state) => value!);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      const Text("Age: Younger"),
                                    ],),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: h*0.05,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(w*0.03)
                          ),
                            child: const Icon(Icons.sort,color: Colors.white,)),
                      ))
                ],
              ),
              SizedBox(height: h*0.015,),
              Row(
                children: [
                  Text("Users Lists",
                  style: TextStyle(
                    fontSize: w*0.04,
                    fontWeight: FontWeight.w800
                  ),),
                ],
              ),
              SizedBox(height: h*0.01,),
              Consumer(
                builder: (context, ref, child) {
                  var searchData=ref.watch(searchUserProvider);
                  Map map={
                    "search":searchData,
                    "sort":radioValue
                  };
                  var userData=ref.watch(getUserProvider(jsonEncode(map)));
                return userData.when(data: (data) {
                  return data.isEmpty? const Center(
                    child: Text("No Data.!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                  ):SizedBox(
                    height: h*0.5,
                    width: w*1,
                    child: ListView.separated(
                      itemCount: data.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                        UserModel user=data[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(w*0.03)
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: w*0.08,
                                backgroundImage: NetworkImage(user.image),
                              ),
                              title: Text(user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600
                              ),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Age: ${user.age}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),),
                                  Text("Mob: ${user.phoneNumber}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),),
                                ],
                              ),
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: h*0.01,);
                    },),
                  );
                },
                  error: (error, stackTrace){
                  print(error);
                    if(kDebugMode){
                      print(error);
                      print(stackTrace);
                    }
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                );
              },)
            ],
          ),
        ),
      ),
    );
  }
}
