import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart=Provider.of<Cart>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        header: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.black87, fontSize: 15),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {cart.addItem(product.id,product.price, product.title);},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}