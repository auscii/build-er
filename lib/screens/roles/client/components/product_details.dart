import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/router/router.dart';
import 'package:client/screens/roles/client/components/product_description.dart';
import 'package:client/screens/roles/client/components/product_images.dart';
import 'package:flutter/material.dart';
import 'package:client/core/models/products.dart';
import 'top_rounded_container.dart';
import 'package:client/core/utils/sizes.dart';
import 'default_button.dart';

BoxConstraints pageConstraints =
    const BoxConstraints(minWidth: 320, maxWidth: 480);

class ProductDetails extends StatefulWidget {
  static const String id = Var.productDetails;
  const ProductDetails({Key? key}) : super(key: key);
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  @override
  void initState() {
    AppData.getUserResultIfVerified(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Product? products = Var.product;
    return SafeArea(
      // minimum: const EdgeInsets.only(top: 0, left: 30, right: 30),
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
                  // colorFilter: ColorFilter.mode(
                  //   Colors.black.withOpacity(.6),
                  //   BlendMode.darken,
                  // ),
                ),
              ),
            child: 
              ListView(
                children: [
                  const SizedBox(height: 20),
                  const ProductImages(),
                  TopRoundedContainer(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        ProductDescription(
                          product: products!,
                          pressOnSeeMore: () {},
                        ),
                        TopRoundedContainer(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.15,
                              right: SizeConfig.screenWidth * 0.15,
                              bottom: getProportionateScreenWidth(40),
                              top: getProportionateScreenWidth(15),
                            ),
                            child: DefaultButton(
                              text: Var.addCart,
                              press: () {
                                Toast.show(Var.featureNotAvailable);
                              },
                            ),
                          ),
                        ),
                        TopRoundedContainer(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.15,
                              right: SizeConfig.screenWidth * 0.15,
                              bottom: getProportionateScreenWidth(40),
                              // top: getProportionateScreenWidth(2),
                            ),
                            child: DefaultButton(
                              text: Var.goBack,
                              press: () => GlobalNavigator.goBack(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30)
                        // TopRoundedContainer(
                        //   color: Colors.transparent,
                        //   child: Column(
                        //     children: const [
                        //       // Icon(
                        //       //   Icons.arrow_back,
                        //       //   size: 12,
                        //       //   color: Colors.black,
                        //       // ),
                        //       // SizedBox(width: 5),
                        //       Text(
                        //         Var.goBack,
                        //         style: TextStyle(
                        //           fontFamily: Var.defaultFont,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 25,
                        //         ),
                        //       ),
                        //       SizedBox(height: 30),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              )
            // ProductBody(productName: Var.productName),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ProductBody(productName: Var.productName),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    // Map arg = (ModalRoute.of(context)!.settings.arguments??{}) as Map;
    // final arg = ModalRoute.of(context)!.settings.arguments as Map;
    // final ProductDetailsArguments agrs =
    //     ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    // final agrs = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      // drawer: const MenuDrawer(),//customDrawer(context),
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   elevation: 0,
      //   backgroundColor: Colors.black,
      //   foregroundColor: Colors.white,
      //   title: const Text(
      //     Var.builder,
      //     textAlign: TextAlign.center,
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 22,
      //       fontFamily: Var.defaultFont,
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      //   centerTitle: true,
      //   // actions: [NotificationButton()],
      //   leading: Builder(builder: (context) {
      //     return IconButton(
      //       padding: const EdgeInsets.only(left: 16, right: 16),
      //       icon: const Icon(
      //         Icons.menu,
      //         color: Colors.white,
      //         size: 28,
      //       ),
      //       alignment: Alignment.centerLeft,
      //       onPressed: () => Scaffold.of(context).openDrawer(),
      //     );
      //   }),
      // ),
      body: ProductBody(productName: productName),
      // body: ProductBody(product: agrs.product),
    );
  }
  */
}

// class ProductDetailsArguments {
//   final Product product;
//   ProductDetailsArguments({required this.product});
// }
