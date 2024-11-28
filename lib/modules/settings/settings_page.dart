import 'package:get/get.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/plugins/local_http.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:bilibilimusic/widgets/section_listtile.dart';
import 'package:bilibilimusic/modules/backup/backup_page.dart';

class SettingsPage extends GetView<SettingsService> {
  const SettingsPage({super.key});

  BuildContext get context => Get.context!;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: screenWidth > 640 ? 0 : null,
        title: const Text("设置"),
      ),
      bottomNavigationBar: const BottomMusicControl(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const SectionTitle(title: '通用'),
          ListTile(
            leading: const Icon(Icons.dark_mode_rounded, size: 32),
            title: const Text("主题模式"),
            subtitle: const Text("切换系统/亮色/暗色主题模式"),
            onTap: showThemeModeSelectorDialog,
          ),
          ListTile(
            leading: const Icon(Icons.color_lens, size: 32),
            title: const Text("主题颜色"),
            subtitle: const Text("切换软件的主题颜色"),
            trailing: ColorIndicator(
              width: 44,
              height: 44,
              borderRadius: 4,
              color: HexColor(controller.themeColorSwitch.value),
              onSelectFocus: false,
            ),
            onTap: colorPickerDialog,
          ),
          const SectionTitle(title: "播放器"),
          Obx(() => SwitchListTile(
                title: const Text("开机自动播放"),
                subtitle: const Text("当程序启动时，自动播放"),
                value: controller.enableAutoPlay.value,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (bool value) => controller.enableAutoPlay.value = value,
              )),
          ListTile(
            title: const Text("定时关闭时间"),
            subtitle: const Text("定时关闭app"),
            trailing: Obx(() => Text('${controller.autoShutDownTime} minute')),
            onTap: showAutoShutDownTimeSetDialog,
          ),
          ListTile(
            title: const Text("歌词源"),
            subtitle: const Text("选择播放的歌词匹配源"),
            trailing: Obx(() => Text('歌词源${controller.lrcApiIndex.value + 1}')),
            onTap: showLyricsSelectorDialog,
          ),
          const SectionTitle(title: "备份与恢复"),
          ListTile(
            leading: const Icon(Icons.sync_rounded, size: 32),
            title: const Text("数据同步"),
            onTap: () {
              showImportSetDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup_rounded, size: 32),
            title: const Text("备份与恢复"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BackupPage()),
            ),
          ),
        ],
      ),
    );
  }

  void showThemeModeSelectorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("主题模式"),
            children: SettingsService.themeModes.keys.map<Widget>((name) {
              return RadioListTile<String>(
                activeColor: Theme.of(context).colorScheme.primary,
                groupValue: controller.themeModeName.value,
                value: name,
                title: Text(name),
                onChanged: (value) {
                  controller.changeThemeMode(value!);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          );
        });
  }

  void showLyricsSelectorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("歌词源"),
            children: controller.lrcApiUrl.map<Widget>((name) {
              int index = controller.lrcApiUrl.indexOf(name);
              return RadioListTile<String>(
                activeColor: Theme.of(context).colorScheme.primary,
                groupValue: controller.themeModeName.value,
                value: name,
                title: Text("歌词源${index + 1}"),
                onChanged: (value) {
                  if (value != null) {
                    int setIndex = controller.lrcApiUrl.indexOf(value);
                    controller.changeLrcApiIndex(setIndex);
                  }
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          );
        });
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: HexColor(controller.themeColorSwitch.value),
      onColorChanged: (Color color) {
        controller.themeColorSwitch.value = color.hex;
        var themeColor = color;
        var lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
        var darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
        Get.changeTheme(lightTheme);
        Get.changeTheme(darkTheme);
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        '主题颜色',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        '选择透明度',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        '主题颜色及透明度',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: false,
      showColorName: false,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      customColorSwatchesAndNames: controller.colorsNameMap,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      // customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 480, minWidth: 375, maxWidth: 420),
    );
  }

  Future<String?> showEditTextDialog() async {
    final TextEditingController urlEditingController = TextEditingController();
    urlEditingController.text = 'http://192.168.';
    var result = await Get.dialog(
        AlertDialog(
          title: const Text('请输入同步地址'),
          content: SizedBox(
            width: 400.0,
            height: 100.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  TextField(
                    controller: urlEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //prefixText: title,
                      contentPadding: EdgeInsets.all(12),
                      hintText: '同步地址:格式http://ip:port',
                    ),
                    autofocus: true,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(Get.context!).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () async {
                if (urlEditingController.text.isEmpty) {
                  SmartDialog.showToast('请输入下载链接');
                  return;
                }
                LocalHttpServer().importSyncData(urlEditingController.text);
                Navigator.of(Get.context!).pop();
              },
              child: const Text("确定"),
            ),
          ],
        ),
        barrierDismissible: false);
    return result;
  }

  void showImportSetDialog() {
    List<String> list = ["导入数据", "导出数据"];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('数据同步'),
          children: list.map<Widget>((name) {
            return RadioListTile<String>(
              activeColor: Theme.of(context).colorScheme.primary,
              groupValue: '',
              value: name,
              title: Text(name),
              onChanged: (value) {
                Navigator.of(context).pop();
                if (value == "导入数据") {
                  showEditTextDialog();
                } else if (value == "导出数据") {
                  Get.toNamed(RoutePath.kSync);
                }
              },
            );
          }).toList(),
        );
      },
    );
  }

  void showAutoShutDownTimeSetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title: Text(S.of(context).auto_refresh_time),
        content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text("定时关闭app"),
                  value: controller.enableAutoShutDownTime.value,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (bool value) => controller.enableAutoShutDownTime.value = value,
                ),
                Slider(
                  min: 1,
                  max: 1200,
                  label: "定时关闭时间",
                  value: controller.autoShutDownTime.toDouble(),
                  onChanged: (value) {
                    controller.autoShutDownTime.value = value.toInt();
                  },
                ),
                Text('定时关闭时间:'
                    ' ${controller.autoShutDownTime} minute'),
              ],
            )),
      ),
    );
  }
}
