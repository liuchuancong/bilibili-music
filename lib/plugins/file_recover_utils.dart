import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class FileRecoverUtils {
  ///获取后缀
  static String getName(String fullName) {
    return fullName.split(Platform.pathSeparator).last;
  }

  ///获取uuid
  static String getUUid() {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var randomValue = Random().nextInt(4294967295);
    var result = (currentTime % 10000000000 * 1000 + randomValue) % 4294967295;
    return result.toString();
  }

  ///验证URL
  static bool isUrl(String value) {
    final urlRegExp = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    List<String?> urlMatches = urlRegExp.allMatches(value).map((m) => m.group(0)).toList();
    return urlMatches.isNotEmpty;
  }

  ///验证URL
  static bool isHostUrl(String value) {
    final urlRegExp = RegExp(
        r"((https?:www\.)|(https?:\/\/))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    List<String?> urlMatches = urlRegExp.allMatches(value).map((m) => m.group(0)).toList();
    return urlMatches.isNotEmpty;
  }

  ///验证URL
  static bool isPort(String value) {
    final portRegExp = RegExp(r"\d+");
    List<String?> portMatches = portRegExp.allMatches(value).map((m) => m.group(0)).toList();
    return portMatches.isNotEmpty;
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isDenied) {
      final status = Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<String?> createBackup(String backupDirectory) async {
    final settings = Get.find<SettingsService>();
    if (Platform.isAndroid || Platform.isIOS) {
      final granted = await requestStoragePermission();
      if (!granted) {
        SnackBarUtil.error('请先授予读写文件权限');
        return null;
      }
    }

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      initialDirectory: backupDirectory.isEmpty ? '/' : backupDirectory,
    );
    if (selectedDirectory == null) return null;

    final dateStr = formatDate(
      DateTime.now(),
      [yyyy, '-', mm, '-', dd, 'T', HH, '_', nn, '_', ss],
    );
    final file = File('$selectedDirectory/bilibilimusic_backup_$dateStr.txt');
    if (settings.backup(file)) {
      SnackBarUtil.success("创建备份成功");
      // 首次同步备份目录
      if (settings.backupDirectory.isEmpty) {
        settings.backupDirectory.value = selectedDirectory;
      }
      return selectedDirectory;
    } else {
      SnackBarUtil.error("创建备份失败");
      return null;
    }
  }

  void recoverBackup() async {
    final settings = Get.find<SettingsService>();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "选择备份文件",
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    if (settings.recover(file)) {
      SnackBarUtil.success("恢复备份成功");
    } else {
      SnackBarUtil.error("恢复备份失败");
    }
  }

  // 选择备份目录
  Future<String?> selectBackupDirectory(String backupDirectory) async {
    final settings = Get.find<SettingsService>();
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return null;
    settings.backupDirectory.value = selectedDirectory;
    return selectedDirectory;
  }
}
