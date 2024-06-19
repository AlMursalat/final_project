import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/models/category.dart' as kategori;
import 'package:storage_management_app/models/product.dart';
import 'package:storage_management_app/pages/product_details_page.dart';
import 'package:storage_management_app/pages/profile_page.dart';
import 'package:storage_management_app/services/api_service.dart';

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  List<Product> products = [];
  List<kategori.Category> categories = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController deleteIdController = TextEditingController();
  int selectedCategoryId = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  @override
  void dispose() {
    nameController.dispose();
    qtyController.dispose();
    imageUrlController.dispose();
    deleteIdController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      List<Product> fetchedProducts = await ApiService.getAllProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (error) {
      print('Error loading products: $error');
      String errorMessage = 'Gagal memuat produk. Silakan coba lagi nanti.';
      if (error is Exception) {
        errorMessage = 'Gagal memuat produk: ${error.toString()}';
      }
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _loadCategories() async {
    try {
      List<kategori.Category> fetchedCategories =
          await ApiService.getAllCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (error) {
      print('Error loading categories: $error');
      _showErrorDialog('Gagal memuat kategori. Silakan coba lagi nanti.');
    }
  }

  Future<void> _addProduct() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null &&
        nameController.text.isNotEmpty &&
        qtyController.text.isNotEmpty) {

      int createdBy = int.parse(username);

      Product newProduct = await ApiService.createProduct(
        nameController.text,
        int.parse(qtyController.text),
        selectedCategoryId,
        imageUrlController.text,
        createdBy,
      );

      setState(() {
        products.add(newProduct);
        nameController.clear();
        qtyController.clear();
        imageUrlController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
    } else {
      _showErrorDialog(
          'Gagal mendapatkan username atau Nama Produk/Jumlah kosong.');
    }
  } catch (error) {
    print('Error adding product: $error');
    _showErrorDialog('Gagal menambahkan produk. Silakan coba lagi nanti.');
  }
}




  Future<void> _deleteProduct(int id) async {
  try {
    await ApiService.deleteProduct(id);
    setState(() {
      products.removeWhere((product) => product.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produk berhasil dihapus'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (error) {
    print('Error deleting product: $error');
    _showErrorDialog('Gagal menghapus produk. Silakan coba lagi nanti.');
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddProductDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Tambah Produk'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
              ),
              TextField(
                controller: qtyController,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value!;
                  });
                },
                items: categories.map((kategori.Category category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Pilih Kategori',
                ),
              ),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'URL Gambar'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Batal'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Tambah'),
            onPressed: () {
              _addProduct();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  void _showDeleteProductDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Hapus Produk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: deleteIdController,
              decoration: InputDecoration(labelText: 'Masukkan ID Produk'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Batal'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Hapus'),
            onPressed: () {
              int id = int.tryParse(deleteIdController.text) ?? -1;
              if (id != -1) {
                _deleteProduct(id); // Panggil fungsi _deleteProduct di sini
                Navigator.of(context).pop(); // Tutup dialog setelah berhasil menghapus produk
              } else {
                _showErrorDialog('Harap masukkan ID Produk yang valid.');
              }
            },
          ),
        ],
      );
    },
  );
}


  void _navigateToProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(username: username),
        ),
      );
    } else {
      _showErrorDialog('Gagal mendapatkan username.');
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Menu Utama'),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: _navigateToProfile,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddProductDialog,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteProductDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue.withOpacity(0.3),
              Colors.red.withOpacity(0.3),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('${products[index].id} - ${products[index].name}'),
                    subtitle: Text('Category: ${products[index].category.name}'),
                    leading: Image.network(products[index].imageUrl),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(products[index]),
                        ),
                      ).then((_) {
                        _loadProducts();
                      });
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.grey,
                    height: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
