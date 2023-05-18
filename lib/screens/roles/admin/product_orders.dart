import 'package:client/core/utils/global.dart';
import 'package:client/core/utils/modal.dart';
import 'package:client/core/utils/sizes.dart';
import 'package:client/core/utils/toast.dart';
import 'package:client/router/navigator/navigation_menu.dart';
import 'package:client/router/router.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

BoxConstraints pageConstraints2 =
    const BoxConstraints(minWidth: 320, maxWidth: 480, maxHeight: 5000, minHeight: 500);

class AppDialog2 extends StatelessWidget {
  final Widget child;
  const AppDialog2({
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: pageConstraints2,
        child: Dialog(
          backgroundColor: AppColors.bgDark,
          insetPadding:
              const EdgeInsets.only(top: 24, bottom: 24, right: 10, left: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminProductOrders extends StatefulWidget {
  static const id = "PRODUCT ORDERS";
  final bool admin;
  const AdminProductOrders({
    Key? key,
    required this.admin
  }) : super(key: key);
  @override
  State<AdminProductOrders> createState() => _AdminProductOrdersState();
}

class _AdminProductOrdersState extends State<AdminProductOrders> {

  @override
  void initState() {
    print("Var.productOrders ->${Var.productOrders}");
    setState(() => Var.appTitle = "PRODUCT ORDERS");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          height: 5000,
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                Var.appTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 35),
              adminProductOrderApprovalPrompt(context),
              const SizedBox(height: 35),
            ],
          ),
        ),
      )
    );
  }

  Widget adminProductOrderApprovalPrompt(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      // height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 50),
          const Divider(color: Colors.black),
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.zero,
            height: 5000,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: Var.productOrders.map((order) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 50, right: 50),
                      child: Text(
                        "TRANSACTION NUMBER: ${order.transactionNumber}",
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
                      margin: EdgeInsets.only(left: 50, right: 50),
                      child: Text(
                        "CUSTOMER NAME: ${order.customerName}",
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
                      margin: EdgeInsets.only(left: 50, right: 50),
                      child: Text(
                        "TRANSACTION DATE & TIME CREATED: ${order.transactionDateTimeCreated}",
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
                      margin: EdgeInsets.only(left: 50, right: 50),
                      child: Text(
                        "GRAND TOTAL: ${order.grandTotal}",
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
                      margin: EdgeInsets.only(left: 50, right: 50),
                      child: DropdownButton<String>(
                        focusColor: Colors.white,
                        dropdownColor: Colors.white,
                        value: Var.orderStatuses.first,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_sharp,
                          color: Colors.black
                        ),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (String? value) {
                          // order.transactionNumber
                          Modal.adminProductOrderApproval(
                            context,
                            order.userAddedBy,
                            order.transactionNumber,
                            value ?? Var.na
                          );
                        },
                        items: Var.orderStatuses.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

}