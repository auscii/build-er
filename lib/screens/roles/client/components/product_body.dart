import 'package:client/core/models/products.dart';
import 'package:flutter/material.dart';
import 'package:client/core/utils/sizes.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import 'product_description.dart';
import 'color_dots.dart';
import 'default_button.dart';

class ProductBody extends StatelessWidget {
  final String productName;

  const ProductBody({
    Key? key,
    required this.productName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              // ProductDescription(
              //   product: product,
              //   pressOnSeeMore: () {},
              // ),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    // ColorDots(product: product),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(40),
                          top: getProportionateScreenWidth(15),
                        ),
                        child: DefaultButton(
                          text: "Add To Cart",
                          press: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
