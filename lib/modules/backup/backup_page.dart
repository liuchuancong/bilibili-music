import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/widgets/section_listtile.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:bilibilimusic/plugins/file_recover_utils.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  final settings = Get.find<SettingsService>();
  late String backupDirectory = settings.backupDirectory.value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SectionTitle(title: "备份与恢复"),
          ListTile(
            title: const Text("创建备份"),
            subtitle: const Text("可用于恢复当前数据"),
            onTap: () async {
              final selectedDirectory = await FileRecoverUtils().createBackup(backupDirectory);
              if (selectedDirectory != null) {
                setState(() {
                  backupDirectory = selectedDirectory;
                });
              }
            },
          ),
          ListTile(
            title: const Text("恢复备份成功，请重启"),
            subtitle: const Text(
              "从备份文件中恢复",
            ),
            onTap: () => FileRecoverUtils().recoverBackup(),
          ),
          const SectionTitle(title: "备份目录"),
          ListTile(
            title: const Text("备份目录"),
            subtitle: Text(backupDirectory),
            onTap: () async {
              final selectedDirectory = await FileRecoverUtils().selectBackupDirectory(backupDirectory);
              if (selectedDirectory != null) {
                setState(() {
                  backupDirectory = selectedDirectory;
                });
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}
