import 'package:get/get.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/index.dart';
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
          const SectionTitle(title: "备份与恢复"),
          ListTile(
            leading: const Icon(Icons.backup_rounded, size: 32),
            title: const Text("备份与恢复"),
            subtitle: const Text("创建备份与恢复"),
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
