import 'package:client/core/models/product_order.dart';
import 'package:client/core/models/products.dart';
import 'package:client/core/models/user.dart';
import 'package:client/core/providers/appdata.dart';
import 'package:client/core/providers/user.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/loader.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/router/navigator/navigation_menu.dart';
import 'package:client/router/router.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Modal {
  static final Modal _instance = Modal._internal();
    Modal._internal();

  factory Modal() => _instance;
  
  static Future<dynamic> promptLogin(
    BuildContext context, String msgValue,
    String positiveBtn, String negativeBtn
  ) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: 
          Text(
            msgValue,
            style: 
              const TextStyle(
                color: Colors.black,
                fontSize: 16.0
              ),
          ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              positiveBtn,
              style: const TextStyle(color: AppColors.primary)
            ),
            onPressed: ()
              => Provider.of<UserProvider>(
                  context, 
                  listen: false
                ).signOut(context)
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(negativeBtn),
          onPressed: () async => GlobalNavigator.goBack(),
        ),
      ),
    );
  }
  
  static Future<dynamic> promptUserVerify(
    BuildContext context, String msgValue,
    String positiveBtn, String negativeBtn,
    String id
  ) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: 
          Text(
            msgValue,
            style: 
              const TextStyle(
                color: Colors.black,
                fontSize: 16.0
              ),
          ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              positiveBtn,
              style: const TextStyle(color: AppColors.primary)
            ),
            onPressed: () {
              AppData().updateUserDetails(userId: id);
              GlobalNavigator.doubleGoBack();
            }
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(negativeBtn),
          onPressed: () {
            Toast.show(Var.userCancelled, null);
            GlobalNavigator.goBack();
          },
        ),
      ),
    );
  }
  
  static Future<dynamic> modalInfo(
    BuildContext context,
    String msgValue,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: 
              Text(
                Var.warning,
                style: TextStyle(
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.black
                ),
              )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.zero,
                child: Text(
                  msgValue,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.normal,
                    fontSize: 19,
                    color: Colors.black
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: 
                  Container(
                    height: 50,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 28),
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
                      color: Colors.black
                    ),
                    child: const Text(
                      Var.ok,
                      style: TextStyle(
                        backgroundColor: AppColors.primary,
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.white
                      ),
                    ),
                  ),       
                onTap: () {
                  NavigationMenu.activeIndex = 0;
                  GlobalNavigator.replaceScreen(const NavigationMenu(activeIndex: 0));
                }
              ),
            ],
          ),
        );
      });
  }

  static modalLoader(
    BuildContext context, String title, String subject) async {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(subject),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: 
                const SizedBox(
                  // child: CupertinoActivityIndicator(color: Colors.white),
                  height: 50,
                  width: 50,
                ),
              onPressed: () => GlobalNavigator.pop(context),
            ),
          ],
        );
      },
    );
  }
  
  static Future<dynamic> userApproval(
    BuildContext context,
    String userValidID,
    String name,
    String id,
    String phoneNumber,
    String emailAddress,
    String address
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: 
              Text(
                "Here's the Valid ID and user information before user approval:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.black
                ),
              )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.zero,
                height: 150,
                width: 150,
                child: 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(userValidID)
                  ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.zero,
                child: Text(
                  "Name: $name",
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
                  "ID No.: $id",
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
                  "Phone No.: $phoneNumber",
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
                  "Email Address: $emailAddress",
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
                  "Address: $address",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: EdgeInsets.zero,
                child: const Text(
                  Var.verifyThisUserMsg,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: Var.defaultFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  // top: getProportionateScreenWidth(2),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      child: 
                        Container(
                          height: 50,
                          width: 100,
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
                            Var.yes,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white
                            ),
                          ),
                        ),       
                      onTap: () {
                        AppData().updateUserDetails(userId: id);
                        GlobalNavigator.doubleGoBack();
                      }
                    ),
                    GestureDetector(
                      child: 
                        Container(
                          height: 50,
                          width: 100,
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
                            color: Colors.red
                          ),
                          child: const Text(
                            Var.no,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white
                            ),
                          ),
                        ),       
                      onTap: () => GlobalNavigator.goBack(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
  }
  
  static Future<dynamic> productCartConfirmation(
    BuildContext context,
    String productId,
    String productName,
    String productDetails,
    String productImage,
    String productCategory,
    String productCreatedBy,
    double productPrice
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: 
              Text(
                "Do you want to check or view the added products in your cart?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.black
                ),
              )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppData.getProductCarts();
                        Loader.show(context, 0);
                        Future.delayed(const Duration(milliseconds: 5000), () {
                          Loader.stop();
                          GlobalNavigator.doubleGoBack();
                          NavigationMenu.activeIndex = 9;
                          GlobalNavigator.navigateToScreen(const NavigationMenu());
                        });
                      },
                      child: 
                        Container(
                          height: 50,
                          width: 100,
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
                            Var.yes,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white
                            ),
                          ),
                        ),
                    ),
                    GestureDetector(
                      child: 
                        Container(
                          height: 50,
                          width: 100,
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
                            color: Colors.red
                          ),
                          child: const Text(
                            Var.no,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white
                            ),
                          ),
                        ),       
                      onTap: () => GlobalNavigator.goBack(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
  }
  
  static Future<dynamic> orderProductsPrompt(
    BuildContext context,
    String orderCustomerName,
    double orderGrandTotalPrice,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Are you sure you want to place your order(s)?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: Colors.black
              ),
            )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Toast.show("Product successfully placed order!", null);
                        Loader.show(context, 0);
                        Var.productOrders.clear();
                        AppData.storeProductOrder(
                          order: ProductOrder(
                            transactionNumber: Var.charRandomizer().toString(),
                            orderStatus: Var.orderConfirmed,
                            // products: Var.productCarts,
                            grandTotal: orderGrandTotalPrice,
                            customerName: Provider.of<UserProvider>(context, listen: false).user.name ?? Var.na,
                            transactionDateTimeCreated: Var.now.toString(),
                            userAddedBy: Var.currentUserID,
                            status: 1
                          )
                        );
                        Var.productCarts.where((c) 
                          => c.userAddedBy == Var.currentUserID
                        ).forEach((p) {
                          AppData.removeProductCart(docID: p.docID);
                        });
                        Future.delayed(const Duration(milliseconds: 5000), () {
                          Loader.stop();
                          NavigationMenu.activeIndex = 8;
                          GlobalNavigator.navigateToScreen(const NavigationMenu());
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 100,
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
                          Var.yes,
                          style: TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: 
                        Container(
                          height: 50,
                          width: 100,
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
                            color: Colors.red
                          ),
                          child: const Text(
                            Var.no,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white
                            ),
                          ),
                        ),       
                      onTap: () => GlobalNavigator.goBack(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
  }
  
  static Future<dynamic> adminProductOrderApproval(
    BuildContext context,
    String userId,
    String transactionNumber,
    String orderStatusCode
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "TRANSACTION NUMBER: $transactionNumber \n\nAre you sure you want to update this order into $orderStatusCode?",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: Var.defaultFont,
                fontWeight: FontWeight.normal,
                fontSize: 21,
                color: Colors.black
              ),
            )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Loader.show(context, 0);
                        AppData.updateProductOrder(
                          userId: userId,
                          fieldName: Var.orderStatus,
                          fieldValue: orderStatusCode
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 100,
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
                          Var.yes,
                          style: TextStyle(
                            fontFamily: Var.defaultFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: 
                        Container(
                          height: 50,
                          width: 100,
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
                            color: Colors.red
                          ),
                          child: const Text(
                            Var.no,
                            style: TextStyle(
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white
                            ),
                          ),
                        ),       
                      onTap: () => GlobalNavigator.goBack(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
  }
  
}