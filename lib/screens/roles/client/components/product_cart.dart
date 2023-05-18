import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/loader.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/router/navigator/navigation_menu.dart';
import 'package:client/router/router.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:flutter/material.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480);

class ProductCart extends StatefulWidget {
  static const String id = Var.productcart;
  const ProductCart({Key? key}) : super(key: key);
  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  static final List<TextEditingController> _productQuantity = [];
  var productCarts = Var.productCarts.where((c) => c.userAddedBy == Var.currentUserID).toList();
  double totalPrice = 0;
  double updatedQuantity = 0;
  double updatedPrice = 0;

  @override
  void initState() {
    setNewPricesAndQuantities(true);
    super.initState();
  }

  @override
  void dispose() {
    _productQuantity.clear();
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
              margin: EdgeInsets.zero,
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
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      const Text(
                        Var.productcart,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: Var.defaultFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: ElevatedButton(
                            onPressed: () {
                              NavigationMenu.activeIndex = 7;
                              GlobalNavigator.navigateToScreen(const NavigationMenu());
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.success,
                              elevation: 0,
                              padding: 
                                const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 15
                                ),
                              shape: 
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                              side: const BorderSide(
                                width: 2.0,
                                color: Colors.black,
                              )
                            ),
                            child:
                              const Text(
                                "PROCEED TO CHECKOUT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: Var.defaultFont,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Divider(color: Colors.black),
                      const SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.zero,
                        height: 5000,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: productCarts.asMap().map((i, prod) 
                            => MapEntry(i, Column(
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
                                      fontSize: 19,
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
                                  child: const Text(
                                    "Quantity:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: Var.defaultFont,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.black
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: "Enter new quantity...",
                                          contentPadding: const EdgeInsets.all(8.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        controller: _productQuantity[i],
                                        keyboardType: const TextInputType.numberWithOptions(
                                          decimal: false,
                                          signed: true,
                                        ),
                                        onChanged: (value) 
                                          => updateProductQuantities(i, value),
                                      ),
                                    ),
                                    /*
                                    Container(
                                      margin: EdgeInsets.zero,
                                      height: 38.0,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            child: InkWell(
                                              child: const Icon(
                                                Icons.arrow_drop_up,
                                                size: 18.0,
                                              ),
                                              onTap: () 
                                                => updateProductQuantities(int.parse(_productQuantity[i].text), 1, true, null),
                                            ),
                                          ),
                                          InkWell(
                                            child: const Icon(
                                              Icons.arrow_drop_down,
                                              size: 18.0,
                                            ),
                                            onTap: () 
                                              => updateProductQuantities(int.parse(_productQuantity[i].text), 1, true, null),
                                          ),
                                        ],
                                      ),
                                    ),
                                    */
                                  ],
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
                                const Divider(color: Colors.black),
                                const SizedBox(height: 20),
                              ],
                          )
                          )).values.toList()
                        ),
                      ),
                    ],
                  ),
                )
              )
          ),
        ),
      ),
    );
  }

  void updateProductQuantities(
    int i,
    String? value
  ) {
    Loader.show(context, 0);
    if (value == null || value.isEmpty) {
      Loader.stop();
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (double.parse(value).toInt() != 0 || 
        double.parse(value) != 0.0
    ) {
      AppData.updateProductCart(
        docID: productCarts[i].docID,
        fieldName: Var.quantity,
        fieldValue: double.parse(value)
      );
      productCarts.clear();
      Var.productCarts.clear();
      AppData.getProductCarts();
      Future.delayed(const Duration(milliseconds: 8000), () {
        productCarts = Var.productCarts.where((c) 
          => c.userAddedBy == Var.currentUserID
        ).toList();
        setNewPricesAndQuantities(false);
        Toast.show("Product order - ${productCarts[i].title} successfully updated quantity into $value", null);
      });
    } else {
      Loader.stop();
    }
  }

  void setNewPricesAndQuantities(bool shouldUpdateTextField) {
    totalPrice = 0;
    for (var i = 0; i < productCarts.length; i++) {
      _productQuantity.add(TextEditingController());
      if (shouldUpdateTextField) {
        _productQuantity[i].text = productCarts[i].quantity.toInt().toString();
      }
      setState(() {
        updatedQuantity = productCarts[i].quantity;
        updatedPrice = productCarts[i].price;
        if (updatedQuantity.toInt() != 0 || updatedQuantity != 0.0) {
          totalPrice += (updatedPrice) * updatedQuantity.toInt();
          // print("updatedQuantity totalprice =>$totalPrice");
        }
        Loader.stop();
      });
    }
  }

}
