import 'package:client/core/utils/global.dart';
import 'package:client/router/navigator/navigation_menu.dart';
import 'package:client/router/router.dart';
import 'package:client/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client/core/utils/sizes.dart';
import '../../../../core/models/products.dart';
import 'product_details.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () {
            Var.product = product;
            Var.previousRoute = PagesRoutes.productDetails;
            NavigationMenu.activeIndex = 5;
            GlobalNavigator.navigateToScreen(const NavigationMenu());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF979797).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: product.id.toString(),
                    child: Image.network(product.image),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\₱ ${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF7643),
                    ),
                  ),
                  /* InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                      height: getProportionateScreenWidth(28),
                      width: getProportionateScreenWidth(28),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF7643).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/images/res/products/icons/Heart Icon_2.svg",
                        color: Color(0xFFFF4848)
                      ),
                    ),
                  ), */
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
