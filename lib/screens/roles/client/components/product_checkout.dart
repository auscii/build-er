import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/loader.dart';
import 'package:client/core/utils/modal.dart';
import 'package:client/router/router.dart';
import 'package:flutter/material.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480);

class ProductCheckout extends StatefulWidget {
  static const String id = Var.productCheckout;
  const ProductCheckout({Key? key}) : super(key: key);
  @override
  State<ProductCheckout> createState() => _ProductCheckoutState();
}

class _ProductCheckoutState extends State<ProductCheckout> {
  var productCarts = Var.productCarts.where((c) => c.userAddedBy == Var.currentUserID).toList();
  double totalPrice = 0;
  String grandTotalPrice = Var.e;
  bool hasData = false;

  @override
  void initState() {
    setNewPricesAndQuantities();
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
      child: ConstrainedBox(
        constraints: pageConstraints,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage(Var.lightBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Visibility(
                  maintainSize: true, 
                  maintainAnimation: true,
                  maintainState: true,
                  visible: hasData, 
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => GlobalNavigator.goBack(),
                              icon: const Icon(Icons.arrow_back),
                            )
                          ],
                        ),
                        const Text(
                          "PRODUCT CHECKOUT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Note: Please confirm your product order(s).",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () => Modal.orderProductsPrompt(
                            context,
                            Var.e,
                            totalPrice
                          ),
                          child: Container(
                            height: 50,
                            width: 200,
                            margin: EdgeInsets.zero,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(25)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: const Color.fromARGB(255, 255, 255, 255).withAlpha(100),
                                  offset: const Offset(1, 1),
                                  blurRadius: 8,
                                  spreadRadius: 2
                                )
                              ],
                              color: Colors.green
                            ),
                            child: const Text(
                              "PLACE ORDER",
                              style: TextStyle(
                                fontFamily: Var.defaultFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          grandTotalPrice,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.zero,
                          height: 5000,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: productCarts.where((c) 
                                => c.userAddedBy == Var.currentUserID
                              ).map((prod) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.zero,
                                      height: 150,
                                      width: 150,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(prod.image)
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        prod.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: Var.defaultFont,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        "Description: ${prod.description}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontFamily: Var.defaultFont,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          color: Colors.black
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        "Price: ${Var.p + Var.e + Var.formatter.format(prod.price)}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontFamily: Var.defaultFont,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          color: Colors.black
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      margin: EdgeInsets.zero,
                                      child: Text(
                                        "Quantity: ${prod.quantity.toInt()}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontFamily: Var.defaultFont,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          color: Colors.black
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Divider(color: Colors.black),
                                    const SizedBox(height: 20),
                                  ],
                                );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }

  void setNewPricesAndQuantities() {
    productCarts.clear();
    Var.productCarts.clear();
    AppData.getProductCarts();
    Loader.show(context, 0);
    Future.delayed(const Duration(milliseconds: 5000), () {
      productCarts = Var.productCarts.where((c) 
        => c.userAddedBy == Var.currentUserID
      ).toList();
      for (var i = 0; i < productCarts.length; i++) {
        setState(() {
          var updatedQuantity = productCarts[i].quantity;
          var updatedPrice = productCarts[i].price;
          if (updatedQuantity.toInt() != 0 || updatedQuantity != 0.0) {
            totalPrice += (updatedPrice) * updatedQuantity.toInt();
          }
          grandTotalPrice = "GRAND TOTAL PRICE: ${Var.p}${Var.e}${Var.formatter.format(totalPrice)}";
        });
      }
      Loader.stop();
      hasData = true;
    });
  }

}