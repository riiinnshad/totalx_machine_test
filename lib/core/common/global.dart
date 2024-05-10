import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final searchUserProvider = StateProvider<String>((ref) {
  return '';
});

void showMessage(BuildContext context,{required String text,required Color color}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          content: Text(text))
  );
}

Future pickImage() async {
  final imageFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  return imageFile;
}