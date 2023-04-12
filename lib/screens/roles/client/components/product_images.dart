import 'package:client/core/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:client/core/utils/sizes.dart';

import '../../../../core/models/products.dart';

// ignore: must_be_immutable
class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    Product? products = Var.product;
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: products?.image.toString() ?? "",
              child: Image.network(products?.image ?? Var.noImageAvailable),
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        /* Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSmallProductPreview(widget.productImage ?? Var.noImageAvailable),
            // ...List.generate(widget.productImage.images.length,
            //     (index) => buildSmallProductPreview(index)),
          ],
        ) */
      ],
    );
  }

  GestureDetector buildSmallProductPreview(String image) {
    const defaultDuration = Duration(milliseconds: 250);
    return GestureDetector(
      onTap: () {},
      // onTap: () {
      //   setState(() {
      //     selectedImage = image;
      //   });
      // },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFFFF7643).withOpacity(0.5)),
        ),
        child: Image.asset(image),
      ),
    );
  }
}
