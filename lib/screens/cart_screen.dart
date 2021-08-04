import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_items.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Card'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .title!
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor),
                  FlatButton(
                      onPressed: (cart.totalAmount <= 0||_isLoading)
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrders(cart.items.values.toList(),
                                      cart.totalAmount);
                              setState(() {
                                _isLoading = false;
                              });
                              cart.clear();
                            },
                      child:_isLoading?CircularProgressIndicator(): Text(
                        'ORDER NOW',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].title,
                  cart.items.values.toList()[index].quantity),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}
