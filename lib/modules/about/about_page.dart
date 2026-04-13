import 'package:get/get.dart';
import 'widgets/version_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/utils/version_util.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:bilibilimusic/widgets/section_listtile.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final AppSettingsService settings = Get.find<AppSettingsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          SectionTitle(title: '关于'),
          ListTile(
            title: Text("在线更新"),
            trailing: Text('当前版本：v${VersionUtil.version}', style: Get.textTheme.bodyMedium),
            onTap: () {
              Get.toNamed(RoutePath.kVersionPage);
            },
          ),
          ListTile(title: Text('新功能'), onTap: showNewFeaturesDialog),
          ListTile(
            title: const Text('历史记录'),
            subtitle: const Text('历史版本更新记录'),
            onTap: () => Get.toNamed(RoutePath.kVersionPage),
          ),
          SectionTitle(title: '项目'),
          ListTile(
            title: Text('项目地址'),
            subtitle: const Text(VersionUtil.projectUrl),
            onTap: () {
              launchUrl(Uri.parse(VersionUtil.projectUrl), mode: LaunchMode.externalApplication);
            },
          )
        ],
      ),
    );
  }

  void showCheckUpdateDialog(BuildContext context) async {
    showDialog(
      context: Get.context!,
      builder: (context) => VersionUtil.hasNewVersion() ? NewVersionDialog() : NoNewVersionDialog(),
    );
  }

  void showNewFeaturesDialog() {
    final config = Get.isDarkMode ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    final mediaQuery = MediaQuery.of(context);
    final maxWidth = mediaQuery.size.width * 0.9;
    final maxHeight = mediaQuery.size.height * 0.7;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('新功能'),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      launchUrl(
                        Uri.parse('https://github.com/liuchuancong/bilibili-music'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: const Text('本软件开源免费', style: TextStyle(fontSize: 20)),
                  ),
                  MarkdownBlock(data: VersionUtil.latestUpdateLog, config: config),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.start,
        );
      },
    );
  }
}
