import 'package:flutter/material.dart';
import 'package:storage_management_app/models/product.dart';
import 'package:storage_management_app/services/api_service.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  ProductDetailsPage(this.product);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isLoading = false;

  late Product _editedProduct;

  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editedProduct = widget.product;
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController.text = _editedProduct.name;
    qtyController.text = _editedProduct.quantity.toString();
    imageUrlController.text = _editedProduct.imageUrl;
  }

  Future<void> _updateProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      Product updatedProduct = await ApiService.updateProduct(
        _editedProduct.id,
        nameController.text,
        int.parse(qtyController.text),
        _editedProduct.category.id, // Menggunakan _editedProduct.category.id
        imageUrlController.text,
      );

      setState(() {
        _editedProduct = updatedProduct;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil diperbarui')),
      );
    } catch (error) {
      print('Error updating product: $error');
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Gagal memperbarui produk. Silakan coba lagi nanti.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    _editedProduct.imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nama Produk'),
                    onChanged: (value) {
                      setState(() {
                        _editedProduct = _editedProduct.copyWith(name: value);
                      });
                    },
                  ),
                  TextField(
                    controller: qtyController,
                    decoration: InputDecoration(labelText: 'Jumlah'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _editedProduct = _editedProduct.copyWith(quantity: int.parse(value));
                      });
                    },
                  ),
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'URL Gambar'),
                    onChanged: (value) {
                      setState(() {
                        _editedProduct = _editedProduct.copyWith(imageUrl: value);
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProduct,
                    child: Text('Perbarui Produk'),
                  ),
                ],
              ),
            ),
    );
  }
}
