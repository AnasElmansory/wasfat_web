import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/providers/auth_provider.dart';
import 'package:wasfat_web/providers/page_provider.dart';

class HomeSideBar extends StatelessWidget {
  const HomeSideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    final user = auth.wasfatUser;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? ''),
              accountEmail: Text(user?.email ?? ''),
            ),
            GFListTile(),
            GFListTile(),
            GFButton(
              text: 'log out',
              onPressed: () async => await auth.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}

class SideBarTab extends StatelessWidget {
  final SideBarTabs tab;

  const SideBarTab({Key? key, required this.tab}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final title = tab.toString().substring(12);
    final pageProvider = context.watch<PageProvider>();
    final isSelected = pageProvider.currentPage == tab.index;
    return GFListTile(
      title: Align(
        alignment: Alignment.center,
        child: Text(title),
      ),
      selected: isSelected,
    );
  }
}

enum SideBarTabs {
  Category,
  AddDish,
}
