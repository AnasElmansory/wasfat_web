import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/navigation.dart';
import 'package:wasfat_web/providers/auth_provider.dart';
import 'package:wasfat_web/providers/page_provider.dart';

class HomeSideBar extends StatelessWidget {
  const HomeSideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    final user = auth.wasfatUser;
    return GFDrawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? ''),
              accountEmail: Text(user?.email ?? ''),
              decoration: const BoxDecoration(color: const Color(0xFFFFA000)),
              currentAccountPicture: CircularProfileAvatar(
                corsBridge + (user?.photoURL ?? ''),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, color: Colors.amber),
              ),
            ),
            const SideBarTab(tab: SideBarTabs.Category),
            const SideBarTab(tab: SideBarTabs.Dishes),
            const SideBarTab(tab: SideBarTabs.AddDish),
            const SizedBox(height: 50),
            GFButton(
              text: 'log out',
              onPressed: () async {
                await auth.signOut();
                await navigateToSignPage();
              },
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
    final page = tab.index;
    final isSelected = pageProvider.currentPage == page;
    return GFListTile(
      onTap: () async {
        await pageProvider.toPage(page);
      },
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: isSelected ? GFColors.FOCUS : null,
      title: Align(
        alignment: Alignment.center,
        child: Text(title,
            style: TextStyle(color: isSelected ? Colors.white : null)),
      ),
      selected: isSelected,
    );
  }
}

enum SideBarTabs {
  Category,
  Dishes,
  AddDish,
}
