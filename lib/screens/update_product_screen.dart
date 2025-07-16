import 'package:api_practice/controller/post_product_controller.dart';
import 'package:api_practice/controller/product_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final ProductController productController = Get.put(ProductController());
  final PostUpdateProductController postController = Get.put(
    PostUpdateProductController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Products")),
      body: Obx(
        () => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 4,
          ),
          padding: const EdgeInsets.all(10),
          itemCount: productController.products.length,
          itemBuilder: (BuildContext context, int index) {
            final product = productController.products[index];
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    postController.clearForm();

                    // Pre-fill form
                    postController.idController.text = product.id.toString();
                    postController.titleController.text = product.title!;
                    postController.descriptionController.text =
                        product.description!;
                    postController.imageController.text = product.image!;
                    postController.categoryController.text = product.category!;
                    postController.priceController.text = product.price
                        .toString();
                    postController.pickedImage.value =
                        null; // reset picked image

                    return AlertDialog(
                      title: const Text("Update Product"),
                      content: SizedBox(
                        width: 400,
                        child: SingleChildScrollView(
                          child: Form(
                            key: postController.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() {
                                  final pickedFile =
                                      postController.pickedImage.value;
                                  if (kIsWeb && pickedFile != null) {
                                    return Image.network(
                                      pickedFile.path,
                                    ); // Web-compatible path
                                  } else if (pickedFile != null) {
                                    return Image.file(pickedFile);
                                  } else {
                                    return Image.network(product.image!);
                                  }
                                }),
                                TextFormField(
                                  controller: postController.titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Title',
                                  ),
                                ),
                                TextFormField(
                                  controller:
                                      postController.descriptionController,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                  ),
                                ),
                                TextFormField(
                                  controller: postController.categoryController,
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                  ),
                                ),
                                TextFormField(
                                  controller: postController.priceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final id = product.id;
                            final title = postController.titleController.text;
                            final desc =
                                postController.descriptionController.text;
                            final cat = postController.categoryController.text;
                            final price =
                                double.tryParse(
                                  postController.priceController.text,
                                ) ??
                                0.0;
                            final img = postController.pickedImage.value != null
                                ? 'https://i.pravatar.cc/150?img=${id}' // simulate updated image
                                : product.image;

                            productController.updateProduct(
                              id: id!,
                              title: title,
                              description: desc,
                              image: img!,
                              category: cat,
                              price: price,
                            );

                            Get.back();
                            Get.snackbar(
                              "Updated",
                              "Product updated successfully",
                            );
                          },
                          child: const Text("Update"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "\$${product.price}",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
