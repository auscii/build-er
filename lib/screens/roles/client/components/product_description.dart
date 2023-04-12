import 'package:flutter/material.dart';
import 'package:client/core/models/products.dart';
import 'package:client/core/utils/sizes.dart';
import '../../../../core/utils/global.dart';

class ProductDescription extends StatelessWidget {
  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            product.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: Var.defaultFont,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: Text(
            "₱ ${product.price.toStringAsFixed(2)}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontFamily: Var.defaultFont,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
          ),
        ),
        const SizedBox(height: 30),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Container(
        //     padding: EdgeInsets.all(getProportionateScreenWidth(15)),
        //     width: getProportionateScreenWidth(64),
        //     decoration: BoxDecoration(
        //       color:
        //           product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
        //       borderRadius: const BorderRadius.only(
        //         topLeft: Radius.circular(20),
        //         bottomLeft: Radius.circular(20),
        //       ),
        //     ),
        //     child: SvgPicture.asset(
        //       "assets/images/res/products/icons/Heart Icon_2.svg",
        //       color:
        //           product.isFavourite ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
        //       height: getProportionateScreenWidth(16),
        //     ),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: Text(
            product.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: Var.defaultFont,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
            maxLines: 3,
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: getProportionateScreenWidth(20),
        //     vertical: 10,
        //   ),
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Row(
        //       children: [
        //         Text(
        //           "See More Detail",
        //           style: TextStyle(
        //               fontWeight: FontWeight.w600, color: Color(0xFFFF4848)),
        //         ),
        //         SizedBox(width: 5),
        //         Icon(
        //           Icons.arrow_forward_ios,
        //           size: 12,
        //           color: Color(0xFFFF4848),
        //         ),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
