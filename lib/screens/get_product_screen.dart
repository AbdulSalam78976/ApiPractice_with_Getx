import 'package:api_practice/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
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
            return Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: Image.network(
                          product.image.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // TODO: Call delete API if implemented
                            Get.defaultDialog(
                              title: "Delete Product",
                              middleText:
                                  "Are you sure you want to delete this product?",
                              textConfirm: "Yes",
                              textCancel: "No",
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                // deleting from list in which stored at run time
                                productController.products.removeAt(index);
                                // deleting from API
                                productController.deleteProduct(product.id!);
                                Get.back();
                                Get.snackbar(
                                  "Deleted",
                                  "Product removed from list",
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.title.toString(),
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
            );
          },
        ),
      ),
    );
  }
}
