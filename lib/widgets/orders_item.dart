import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItems extends StatefulWidget {
  final ord.OrderItems orders;
  OrderItems(this.orders);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(duration: Duration(milliseconds: 300),
    height:expanded? min(widget.orders.products.length * 20 + 110, 200):95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.orders.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd-MM-yyyy hh:mm').format(widget.orders.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
            
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                height:expanded? min(widget.orders.products.length * 20 + 10, 100):0,
                child: ListView(
                    children: widget.orders.products
                        .map((pro) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pro.title,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${pro.quantity}x \$${pro.price}',
                                  style:
                                      TextStyle(fontSize: 18, color: Colors.grey),
                                )
                              ],
                            ))
                        .toList()),
              )
          ],
        ),
      ),
    );
  }
}
