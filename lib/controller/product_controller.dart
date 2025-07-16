import 'dart:convert';
import 'package:api_practice/model/product_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  /// Fetch products from API
  Future<void> fetchProducts() async {
    isLoading.value = true;
    hasError.value = false;
    final url = Uri.parse('https://fakestoreapi.com/products');

    try {
      //http.get is used to fetch existing data
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List jsonData = jsonDecode(response.body);
        products.value = jsonData.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        print("❌ Failed to fetch products: ${response.statusCode}");
        hasError.value = true;
      }
    } catch (e) {
      print("🚨 Fetch Error: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh products
  Future<void> refreshProducts() async {
    hasError.value = false;
    isLoading.value = true;
    await fetchProducts();
  }

  /// Post a product to the API
  Future<void> postProduct({
    required int id,
    required String title,
    required String description,
    required String image,
    required String category,
    required double price,
  }) async {
    isLoading.value = true;
    hasError.value = false;

    final url = Uri.parse('https://fakestoreapi.com/products');

    try {
      //http.post is used to post new data
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": id,
          "title": title,
          "price": price,
          "description": description,
          "image": image,
          "category": category,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Product posted successfully");
        print("📦 Response Body: ${response.body}");

        final responseData = jsonDecode(response.body);
        print("🔍 Parsed Response: $responseData");

        await fetchProducts(); // Refresh list after posting
      } else {
        print("❌ Post failed: ${response.body}");
        hasError.value = true;
      }
    } catch (e) {
      print("🚨 Post Error: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update a product in the API
  Future<void> updateProduct({
    required int id,
    required String title,
    required String description,
    required String image,
    required String category,
    required double price,
  }) async {
    isLoading.value = true;
    hasError.value = false;

    final url = Uri.parse('https://fakestoreapi.com/products/$id');

    try {
      //http.put is used to update existing data
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": id,
          "title": title,
          "price": price,
          "description": description,
          "image": image,
          "category": category,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Product updated successfully");
        print("📦 Response Body: ${response.body}");

        final responseData = jsonDecode(response.body);
        print("🔍 Parsed Response: $responseData");

        await fetchProducts(); // Refresh list after update
      } else {
        print("❌ Update failed: ${response.body}");
        hasError.value = true;
      }
    } catch (e) {
      print("🚨 Update Error: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a product from the API
  Future<void> deleteProduct(int id) async {
    isLoading.value = true;
    hasError.value = false;

    final url = Uri.parse('https://fakestoreapi.com/products/$id');

    try {
      //http.delete is used to delete existing data
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print("✅ Product deleted successfully");
        await fetchProducts(); // Refresh list after delete
      } else {
        print("❌ Delete failed: ${response.body}");
        hasError.value = true;
      }
    } catch (e) {
      print("🚨 Delete Error: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
