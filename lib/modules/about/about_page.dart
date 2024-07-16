import 'package:get/get.dart';
import 'widgets/version_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/utils/version_util.dart';
import 'package:bilibilimusic/widgets/section_listtile.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final SettingsService settings = Get.find<SettingsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const SectionTitle(title: "关于"),
          ListTile(
            title: const Text("最新特性"),
            onTap: showNewFeaturesDialog,
          ),
          ListTile(
            title: const Text("检查更新"),
            onTap: () => showCheckUpdateDialog(context),
          ),
          const ListTile(
            title: Text("版本信息"),
            subtitle: Text(VersionUtil.version),
          ),
          ListTile(
            title: const Text('历史记录'),
            subtitle: const Text('历史版本更新记录'),
            onTap: () => Get.toNamed(RoutePath.kVersionHistory),
          ),
          const SectionTitle(
            title: "项目",
          ),
          ListTile(
            title: const Text("项目地址"),
            subtitle: const Text(VersionUtil.projectUrl),
            onTap: () {
              launchUrl(
                Uri.parse(VersionUtil.projectUrl),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          const ListTile(
            title: Text("项目声明"),
            subtitle: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text("本项目仅供学习交流使用，请勿用于商业用途。任何因使用本项目而产生的法律纠纷与本人无关。"),
            ),
          ),
        ],
      ),
    );
  }

  void showCheckUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => VersionUtil.hasNewVersion() ? const NewVersionDialog() : const NoNewVersionDialog(),
    );
  }

  void showNewFeaturesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("最新特性"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Version ${VersionUtil.latestVersion}'),
            const SizedBox(height: 20),
            Text(
              VersionUtil.latestUpdateLog,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
