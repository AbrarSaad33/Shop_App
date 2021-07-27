import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProducts=Provider.of<ProductsProvider>(context).findByID(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProducts.title),
      ),
    );
  }
}
