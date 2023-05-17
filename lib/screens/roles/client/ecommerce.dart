import 'package:client/core/providers/appdata.dart';
import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/loader.dart';
import 'package:client/core/utils/sizes.dart';
import 'package:client/screens/roles/admin/add_products.dart';
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
    var constructionMaterials = 
      Var.productLists.where((i) => i.category == Var.constructionMaterials).toList();
    var constructionTools = 
      Var.productLists.where((i) => i.category == Var.constructionTools).toList();

  @override
  void initState() {
    AppData.getUserResultIfVerified(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    initProducts();
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage(Var.lightBg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
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
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                      child: SectionTitle(
                        title: Var.constructionMaterials,
                        press: () => showDialog(
                          context: context,
                          builder: (context) => viewProductCategory(
                            constructionMaterials
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate(
                            constructionMaterials.length,
                            (index) {
                              return ProductCard(product: constructionMaterials[index]);
                            },
                          ),
                          SizedBox(width: getProportionateScreenWidth(20)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(30)),
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                      child: SectionTitle(title: Var.constructionTools, 
                        press: () => showDialog(
                          context: context,
                          builder: (context) => viewProductCategory(
                            constructionTools
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate(
                            constructionTools.length,
                            (index) {
                              return ProductCard(product: constructionTools[index]);
                            },
                          ),
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
        ),
      ),
    );
  }

  Widget viewProductCategory(List<Product> products) {
    return AppDialog(
      child: SingleChildScrollView(
        child: 
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Column(
                children: products.map((prod) {
                  return Container(
                    color: const Color(0xFF979797).withOpacity(0.1),
                    child: GestureDetector(
                      // onTap: () => showDialog(
                      //   context: context,
                      //   builder: (context) => viewProduct(
                      //     prod.id,
                      //     prod.title,
                      //     prod.image,
                      //     prod.category,
                      //     prod.description,
                      //     prod.price
                      //   ),
                      // ),
                      child: ListTile(
                        leading: Transform.translate(
                          offset: const Offset(0, 5),
                          child: Container(
                            height: 250,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                  image: NetworkImage(prod.image),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(width: 2, color: Colors.white)
                            ),
                          ),
                        ),
                        title: 
                          Text(
                            prod.title.toUpperCase(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        subtitle: 
                          Text(
                            "Description: ${prod.description}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: Var.defaultFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ),
                    )
                  );
                }).toList(),
              )
            ]
          ),
      )
    );
  }

  Future<void> _pullRefresh() async {
    Loader.show(context, 0);
    Var.productLists.clear();
    AppData.getProductLists();
    Future.delayed(const Duration(milliseconds: 10000), () {
      Loader.stop();
      setState(() {
        initProducts();
      });
    });
  }

  initProducts() {
    SizeConfig().init(context);
    constructionMaterials = 
      Var.productLists.where((i) => i.category == Var.constructionMaterials).toList();
    constructionTools = 
      Var.productLists.where((i) => i.category == Var.constructionTools).toList();
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
          child: const Text(
            "See More",
            style: TextStyle(color: Colors.black),
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
