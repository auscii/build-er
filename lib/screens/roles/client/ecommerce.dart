import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/sizes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../../core/models/products.dart';
import 'components/product_card.dart';

class Ecommerce extends StatefulWidget {
  static const String id = Var.ecommerce;
  const Ecommerce({Key? key}) : super(key: key);
  @override
  State<Ecommerce> createState() => _EcommerceState();
}

class _EcommerceState extends State<Ecommerce> {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/images/res/products/icons/Flash Icon.svg", "text": "Flash Deal"},
      {"icon": "assets/images/res/products/icons/Bill Icon.svg", "text": "Bill"},
      {"icon": "assets/images/res/products/icons/Game Icon.svg", "text": "Game"},
      {"icon": "assets/images/res/products/icons/Gift Icon.svg", "text": "Daily Gift"},
      {"icon": "assets/images/res/products/icons/Discover.svg", "text": "More"},
    ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            // Padding(
            //   padding:
            //       EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       SearchField(),
            //       IconBtnWithCounter(
            //         svgSrc: "assets/icons/Cart Icon.svg",
            //         press: () => Navigator.pushNamed(context, CartScreen.routeName),
            //       ),
            //       IconBtnWithCounter(
            //         svgSrc: "assets/icons/Bell.svg",
            //         numOfitem: 3,
            //         press: () {},
            //       ),
            //     ],
            //   ),
            // );
            SizedBox(height: getProportionateScreenWidth(10)),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(getProportionateScreenWidth(20)),
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(15),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 195, 201, 24),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    const TextSpan(text: Var.ecommerceTagLine1),
                    TextSpan(
                      text: Var.ecommerceTagLine2,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  categories.length,
                  (index) => CategoryCard(
                    icon: categories[index]["icon"],
                    text: categories[index]["text"],
                    press: () {},
                  ),
                ),
              ),
            ),
            // Column(
            //   children: [
            //     Padding(
            //       padding:
            //           EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            //       child: SectionTitle(
            //         title: "Special for you",
            //         press: () {},
            //       ),
            //     ),
            //     SizedBox(height: getProportionateScreenWidth(20)),
            //     SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Row(
            //         children: [
            //           Ecommerce(
            //             image: "assets/images/Image Banner 2.png",
            //             category: "Smartphone",
            //             numOfBrands: 18,
            //             press: () {},
            //           ),
            //           Ecommerce(
            //             image: "assets/images/Image Banner 3.png",
            //             category: "Fashion",
            //             numOfBrands: 24,
            //             press: () {},
            //           ),
            //           SizedBox(width: getProportionateScreenWidth(20)),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: getProportionateScreenWidth(30)),
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                  child: SectionTitle(title: Var.ourProducts, press: () {}),
                ),
                SizedBox(height: getProportionateScreenWidth(20)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // ...List.generate(
                      //   demoProducts.length,
                      //   (index) {
                      //     if (demoProducts[index].isPopular) {
                      //       return ProductCard(product: demoProducts[index]);
                      //     }
                      //     return const SizedBox.shrink();
                      //   },
                      // ),
                      SizedBox(width: getProportionateScreenWidth(20)),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }

}

class IconBtnWithCounter extends StatelessWidget {
  const IconBtnWithCounter({
    Key? key,
    required this.svgSrc,
    this.numOfitem = 0,
    required this.press,
  }) : super(key: key);

  final String svgSrc;
  final int numOfitem;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: press,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            height: getProportionateScreenWidth(46),
            width: getProportionateScreenWidth(46),
            decoration: BoxDecoration(
              color: Color(0xFF979797).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(svgSrc),
          ),
          if (numOfitem != 0)
            Positioned(
              top: -3,
              right: 0,
              child: Container(
                height: getProportionateScreenWidth(16),
                width: getProportionateScreenWidth(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numOfitem",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            "See More",
            style: TextStyle(color: Color(0xFFBBBBBB)),
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String? icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon!),
            ),
            SizedBox(height: 5),
            Text(text!, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
