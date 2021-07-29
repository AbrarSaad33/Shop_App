import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavs?productsData.favoriteItems: productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (ctx, index) =>
          // Replace from ChangeNotifierProvider with ChangeNotifierProvider.value
          //in case of list and grid because widgets are recycled But the data that's attached to the widget changes when using change notifier provider value.

// You actually make sure that the provider works even if data changes
//for the widget.
// If you had a builder function that would not work correctly here, it will work correctly because now
// the provider is tied to its data and is attached and detached to and from the widget instead of changing
// data being attached to the same provider.

          ChangeNotifierProvider.value(
        value: products[index],
        child:ProductItem(),
      ),
      //create: (context) => products[index],

      itemCount: products.length,
    );
  }
}
