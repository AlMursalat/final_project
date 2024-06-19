// import 'package:flutter/material.dart';
// import 'package:storage_management_app/models/product.dart';
// import 'package:storage_management_app/services/product_service.dart';

// class CategoryListScreen extends StatefulWidget {
//   @override
//   _CategoryListScreenState createState() => _CategoryListScreenState();
// }

// class _CategoryListScreenState extends State<CategoryListScreen> {
//   List<Product> products = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     try {
//       List<Product> fetchedProducts = await ApiService.getAllProducts();
//       setState(() {
//         products = fetchedProducts;
//       });
//     } catch (e) {
//       // Handle error
//       print('Failed to load products: $e');
//       // You might want to show a snackbar or dialog to inform the user
//     }
//   }

//   Future<void> _confirmDelete(int id) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Product'),
//           content: Text('Are you sure you want to delete this product?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Delete'),
//               onPressed: () async {
//                 try {
//                   await ApiService.deleteProduct(id);
//                   fetchProducts();
//                   Navigator.of(context).pop();
//                 } catch (e) {
//                   // Handle error
//                   print('Failed to delete product: $e');
//                   // You might want to show a snackbar or dialog to inform the user
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product List'),
//       ),
//       body: ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(products[index].name),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 _confirmDelete(products[index].id);
//               },
//             ),
//             onTap: () {
//               // Navigate to product details or edit page
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to screen to add new product
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
