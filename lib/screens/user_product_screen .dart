import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_items.dart';
import '../providers/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userProducts';
  Future<void>refreshData(BuildContext context) async{
    await Provider.of<ProductsProvider>(context,listen: false).fetchData();
  }
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
      body: RefreshIndicator(
        onRefresh: ()=>refreshData(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, i) => Column(
              children: [
                UserProductsItem(productData.items[i].id,
                    productData.items[i].title, productData.items[i].imageUrl),
                Divider(),
              ],
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
