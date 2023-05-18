import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/loader.dart';
import 'package:flutter/material.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480);

class ProductOrderDetails extends StatefulWidget {
  static const String id = Var.productOrderDetails;
  const ProductOrderDetails({Key? key}) : super(key: key);
  @override
  State<ProductOrderDetails> createState() => _ProductOrderDetailsState();
}

class _ProductOrderDetailsState extends State<ProductOrderDetails> {
  var productOrders = Var.productOrders.toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: false,
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Container(
          constraints: pageConstraints,
          margin: EdgeInsets.zero,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(Var.lightBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: productOrders.where((c) 
                      => c.userAddedBy == Var.currentUserID
                  ).map((order) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "ORDER DETAILS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 20),
                        Text(
                          "Order Transaction Date & Time: \n ${order.transactionDateTimeCreated}".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.normal,
                            fontSize: 19,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 20),
                        Text(
                          "Customer Name: ${order.customerName}".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.normal,
                            fontSize: 19,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 20),
                        Text(
                          "Transaction Number: ${order.transactionNumber}".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.normal,
                            fontSize: 19,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 20),
                        Text(
                          "Order Status:".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.normal,
                            fontSize: 19,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          order.orderStatus.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.green
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 20),
                        Text(
                          "PRODUCT ORDER(S) GRAND TOTAL: \n${Var.p}${Var.e}${Var.formatter.format(order.grandTotal)}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 500),
                      ],
                    );
                }).toList(),
              ),
            )
          ),
        ),
      ),
    );
  }

  initProductOrders() {
    productOrders = Var.productOrders.toList();
  }

  Future<void> _pullRefresh() async {
    Loader.show(context, 0);
    setState(() {
      Var.productOrders.clear();
      AppData.getProductOrder();
    });
    Future.delayed(const Duration(milliseconds: 10000), () {
      Loader.stop();
      setState(() => initProductOrders());
    });
  }

}