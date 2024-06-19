import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storage_management_app/models/category.dart' as kategori;
import 'package:storage_management_app/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.43.138:5000/api';

  static Future<List<kategori.Category>> getAllCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => kategori.Category.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat kategori');
    }
  }

  static Future<List<Product>> getAllProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  static Future<Product> createProduct(String name, int quantity, int categoryId, String imageUrl, int createdBy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? username = prefs.getString('username');

    if (token == null || username == null) {
      throw Exception('Token atau username tidak ditemukan');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'quantity': quantity,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'createdBy': int.parse(username), // Mengambil nilai dari SharedPreferences
        'updatedBy': int.parse(username), // Mengambil nilai dari SharedPreferences
      }),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal membuat produk');
    }
  }


  static Future<void> deleteProduct(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Produk berhasil dihapus');
    } else {
      throw Exception('Gagal menghapus produk: ${response.statusCode}');
    }
  }

  static Future<Product> getProductById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail produk');
    }
  }

  static Future<Product> updateProduct(int id, String name, int quantity, int categoryId, String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'quantity': quantity,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memperbarui produk');
    }
  }
}
