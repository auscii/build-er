// library shopping_cart;
import 'package:flutter/material.dart';
import '../../../styles/icons/builder_icons.dart';
export '../../../core/providers/item_models.dart';
import '../../../router/navigator/roles.dart';

class ShoppingCart extends StatelessWidget {
  // const ShoppingCart({super.key});
  static const String id = "Shopping Cart";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 130, left: 27, right: 27),
      maintainBottomViewPadding: false,
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(ProjectBuilder.logo, size: 100),
              const SizedBox(height: 24),
              Text(
                'SHOPPING CART',
                style: Theme.of(context).textTheme.bodyText2!,
              ),
              const SizedBox(height: 4),
              TextButton(
                child: Text(
                  'ADD TO CART',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                onPressed: () {
                  
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

}