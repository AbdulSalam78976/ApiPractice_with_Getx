import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:api_practice/controller/post_product_controller.dart';
import 'package:api_practice/controller/product_controller.dart';

class PostProductScreen extends StatelessWidget {
  PostProductScreen({super.key});

  final PostUpdateProductController postController = Get.put(
    PostUpdateProductController(),
  );
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Product")),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: postController.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Obx(() {
                              final imageFile =
                                  postController.pickedImage.value;
                              return GestureDetector(
                                onTap: () async {
                                  await postController.pickImage();
                                },
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: imageFile != null
                                      ? FileImage(imageFile)
                                      : null,
                                  child: imageFile == null
                                      ? const Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await postController.pickImage();
                              },
                              icon: const Icon(Icons.image),
                              label: const Text('Pick Image'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: postController.idController,
                            decoration: const InputDecoration(
                              labelText: 'ID',
                              prefixIcon: Icon(Icons.numbers),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter ID'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: postController.titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              prefixIcon: Icon(Icons.title),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter title'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: postController.descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter description'
                                : null,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: postController.categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: postController.priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              prefixIcon: Icon(Icons.attach_money),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter price'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.send),
                            label: const Text("Submit"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: productController.isLoading.value
                                ? null
                                : () async {
                                    if (postController.formKey.currentState!
                                        .validate()) {
                                      productController.isLoading.value = true;
                                      await productController.postProduct(
                                        id:
                                            int.tryParse(
                                              postController.idController.text,
                                            ) ??
                                            0,
                                        title:
                                            postController.titleController.text,
                                        description: postController
                                            .descriptionController
                                            .text,
                                        image:
                                            postController.pickedImage.value !=
                                                null
                                            ? '' // You may want to upload the image and get a URL here
                                            : '',
                                        category: postController
                                            .categoryController
                                            .text,
                                        price:
                                            double.tryParse(
                                              postController
                                                  .priceController
                                                  .text,
                                            ) ??
                                            0.0,
                                      );
                                      if (productController.hasError.value) {
                                        Get.snackbar(
                                          "Error",
                                          "Failed to post product",
                                          backgroundColor: Colors.red[100],
                                          colorText: Colors.red[900],
                                        );
                                      } else {
                                        postController.clearForm();
                                        postController.pickedImage.value = null;
                                        Get.snackbar(
                                          "Success",
                                          "Product Posted",
                                          backgroundColor: Colors.green[100],
                                          colorText: Colors.green[900],
                                        );
                                      }
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (productController.isLoading.value)
              Container(
                color: Colors.black.withAlpha(128),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }
}
