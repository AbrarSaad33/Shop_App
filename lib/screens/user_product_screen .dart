import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_items.dart';
import '../providers/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userProducts';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProducts.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (ctx, i) => Column(
            children: [
              UserProductsItem(
                  productData.items[i].title, productData.items[i].imageUrl),
              Divider(),
            ],
          ),
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
