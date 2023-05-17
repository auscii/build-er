import 'package:client/core/utils/global.dart';
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
                children: Var.productOrders.where((c) 
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
                        "GRAND TOTAL:  ₱ ${order.grandTotal.toStringAsFixed(2)}".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: Var.defaultFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.black),
                      const SizedBox(height: 500),
                    ],
                  );
              }).toList(),
              /*
              children: <Widget>[
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
                const SizedBox(height: 40),
                const Divider(color: Colors.black),
                const SizedBox(height: 40),
                Text(
                  "Order Transaction Date & Time: \n ${Var.now.toString()}",
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
                const Text(
                  "Customer Name: ${Var.about}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                  "Transaction Number: ${Var.charRandomizer().toString()}",
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
                const Text(
                  "Order Status: PREPARING",
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                  "Grand Total: ${Var.charRandomizer().toString()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.black),
                const SizedBox(height: 500),
              ],
              */
            ),
          )
        ),
      ),
    );
  }

}