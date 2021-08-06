import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItems(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders extends ChangeNotifier {
  List<OrderItems> _orders = [];
  String? _authToken;
 set authToken(String value) {
  _authToken = value;
 }
 
String? _userId;
 set userId(String userIdValue) {
  _userId = userIdValue;
 } 
  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://shopapp-468f2-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken');
    final response = await http.get(url);
    print(json.decode(response.body));
    final List<OrderItems> loadedOrders = [];
    final Map<String, dynamic> extractedData =
        json.decode(response.body) as Map<String, dynamic>;

    // if (extractedData=={}) {
    //   return;
    // }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItems(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
       print('user id here in orders is $_userId');

    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shopapp-468f2-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItems(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
  }
 
}
