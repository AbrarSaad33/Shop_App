import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  ProductItem(this.id, this.title, this.imageUrl,this.price);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailsScreen.routeName, arguments: id);
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        header: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              '\$$price',
              style: TextStyle(color: Colors.black87, fontSize: 15),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite),
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
