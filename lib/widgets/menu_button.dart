import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';

class MenuListTile extends StatelessWidget {
  final Widget? leading;
  final String text;
  final Widget? trailing;

  const MenuListTile({
    super.key,
    required this.leading,
    required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 12),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        if (trailing != null) ...[
          const SizedBox(width: 24),
          trailing!,
        ],
      ],
    );
  }
}

class MenuButton extends GetView<SettingsService> {
  const MenuButton({super.key});

  final menuRoutes = const [
    RoutePath.kSettings,
    RoutePath.kAbout,
    RoutePath.kContact,
    RoutePath.kHistory,
    RoutePath.kSignIn,
    RoutePath.kSettingsAccount,
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'menu',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(12, 0),
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.menu_rounded),
      onSelected: (int index) {
        if (index == 4) {
          if (controller.bilibiliCookie.isEmpty) {
            Get.toNamed(RoutePath.kMine);
          } else {
            Get.toNamed(RoutePath.kSignIn);
          }
        } else {
          Get.toNamed(menuRoutes[index]);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 5,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: MenuListTile(
            leading: Icon(Icons.assignment_ind_sharp),
            text: '三方认证',
          ),
        ),
      ],
    );
  }
}
