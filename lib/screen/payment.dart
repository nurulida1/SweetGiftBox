import 'package:flutter/material.dart';
import 'dart:async';
import '../model/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  final User user;
  final double total;
  final int phone;

  const Payment({Key? key, required this.user, required this.total, required this.phone}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment'),
        ),
        body: Center(
            child: Container(
                child: Column(
          children: [
            Expanded(
                child: WebView(
                    initialUrl:
                        'https://nurulida1.com/272932/sweetgiftbox/php/generate_bill.php?email=' +
                            widget.user.email +
                            '&mobile=' +
                            widget.phone.toString()+
                            '&name=' +
                            widget.user.name +
                            '&amount=' +
                            widget.total.toStringAsFixed(2),
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    }))
          ],
        ))));
  }
}
