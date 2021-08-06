import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_products.dart';
import './screens/user_product_screen%20.dart';
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
//   final String auth = '';
// final List<Product> items = [];
//   final String userId = '';
//   final List<OrderItems> _orders = [];
  //ProductsProvider prod = ProductsProvider(auth , items);
  // Auth auth1 = Auth();
  //   ProductsProvider prod = ProductsProvider(auth1.token as String, items);
  //   prod.items as ProductsProvider;
  @override
  Widget build(BuildContext context) {
    //Auth auth1 = Auth();
    // ProductsProvider prod = ProductsProvider(auth1.token as String, items);
    //prod.items as ProductsProvider;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
              create: (_) => ProductsProvider(),
              update: (ctx, auth, previousProducts) {
                previousProducts!..authToken = auth.token;
                previousProducts..userId = auth.userId;
                return previousProducts;
              }),
          // ProductsProvider(Provider.of<Auth>(ctx,listen: false).token as String,Provider.of<ProductsProvider>(ctx,listen: false).items),

          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (ctx) => Orders(),
              update: (ctx, auth, previousOrders) {
              previousOrders!..authToken= auth.token;
              previousOrders..userId = auth.userId;
              return previousOrders;})
              
          
        ],

        //it is better to use ChangeNotifierProvider replace of ChangeNotifierProvider.value in instantiate a class
        //if the value constructor
        //when you create a new instance of object and you want to provide is used to create or the
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth
                ? ProductOverview()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapState) =>
                        authResultSnapState.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductOverview.routeName: (ctx) => ProductOverview(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProducts.routeName: (ctx) => EditProducts(),
            },
          ),
        ));
  }
}
