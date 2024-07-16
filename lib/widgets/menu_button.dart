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
    RoutePath.kSettingsAccount,
    RoutePath.kSettings,
    RoutePath.kAbout,
    RoutePath.kHistory,
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
        Get.toNamed(menuRoutes[index]);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: MenuListTile(
            leading: Icon(Icons.account_circle),
            text: "我的账户",
          ),
        ),
        const PopupMenuItem(
          value: 1,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: MenuListTile(
            leading: Icon(Icons.settings_rounded),
            text: "设置",
          ),
        ),
        const PopupMenuItem(
          value: 2,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: MenuListTile(
            leading: Icon(Icons.info_rounded),
            text: "关于",
          ),
        ),
        const PopupMenuItem(
          value: 3,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: MenuListTile(
            leading: Icon(Icons.history),
            text: "历史记录",
          ),
        ),
      ],
    );
  }
}
