import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_products.dart';
import 'package:shop_app/screens/user_product_screen%20.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './providers/products_provider.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './providers/cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx)=>Orders()),
      ],

      //it is better to use ChangeNotifierProvider replace of ChangeNotifierProvider.value in instantiate a class
      //if the value constructor
      //when you create a new instance of object and you want to provide is used to create or the
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductOverview(),
        
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName:(ctx)=>CartScreen(),
          OrdersScreen.routeName:(ctx)=>OrdersScreen(),
          UserProductScreen.routeName:(ctx)=>UserProductScreen(),
          EditProducts.routeName:(ctx)=>EditProducts(),
        },
      ),
    );
  }
}
