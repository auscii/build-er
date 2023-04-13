import 'package:client/core/utils/global.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../router/navigator/navigation_menu.dart';
import '../../../styles/ui/colors.dart';

class ContractorHome extends StatelessWidget {
  const ContractorHome({Key? key}) : super(key: key);

  static const String id = Var.contractorHome;

  Widget _buildAddItem({
    required BuildContext context,
    required String label,
    required GestureTapCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: DottedBorder(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          borderType: BorderType.RRect,
          dashPattern: const [4, 4],
          radius: const Radius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: Var.defaultFont,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 130, left: 36, right: 36),
      maintainBottomViewPadding: false,
      child: Center(
        child: ConstrainedBox(
          constraints: pageConstraints,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontFamily: Var.defaultFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class TabbedLayout extends StatelessWidget {
  const TabbedLayout({
    Key? key,
    required this.tabLabel,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabLabel;
  final List<Widget> tabs;

  List<Widget> _buildTabsLabel() => tabLabel
      .map(
        (e) => Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: Text(
            e,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: Var.defaultFont,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromRGBO(0, 0, 0, 0.1),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: AppColors.success,
              unselectedLabelColor: const Color(0x42000000),
              tabs: _buildTabsLabel(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: TabBarView(children: tabs)),
        ],
      ),
    );
  }
}