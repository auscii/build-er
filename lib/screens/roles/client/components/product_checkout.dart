import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/modal.dart';
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
  double totalPrice = 0;

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Modal.orderProductsPrompt(
                            context,
                            Var.e,
                            totalPrice
                          ),
                          child: Container(
                            height: 50,
                            width: 200,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 20),
                  const Text(
                    "ORDER PRODUCTS: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Var.defaultFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.zero,
                    height: 5000,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: Var.productCarts.where((c) 
                          => c.userAddedBy == Var.currentUserID
                        ).map((prod) {
                          setState(() => totalPrice += prod.price);
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
                                  "Product Name: ${prod.title}",
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
                                  "Price: ${prod.price}",
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
            )
          ),
        ),
      ),
    );
  }

}