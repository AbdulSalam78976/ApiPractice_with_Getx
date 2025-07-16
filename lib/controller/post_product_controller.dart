import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostUpdateProductController extends GetxController {
  final idController = TextEditingController(); // Add this

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final Rx<File?> pickedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();

  var imageController = TextEditingController();

  @override
  void onClose() {
    idController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    categoryController.dispose();
    priceController.dispose();
    super.onClose();
  }

  void clearForm() {
    idController.clear();
    titleController.clear();
    descriptionController.clear();
    imageController.clear();
    categoryController.clear();
    priceController.clear();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }
}
