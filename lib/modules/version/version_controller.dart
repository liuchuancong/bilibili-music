import 'package:get/get.dart';
import 'package:bilibilimusic/utils/version_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:bilibilimusic/common/base/base_controller.dart';

class VersionController extends BaseController {
  final hasNewVersion = false.obs;
  final apkUrl = ''.obs;
  final apkUrl2 = ''.obs;
  final windowsUrl = ''.obs;
  final windowsUrl2 = ''.obs;
  late PackageInfo packageInfo;
  final loading = true.obs;
  @override
  void onInit() {
    super.onInit();
    checkNewVersion();
  }

  Future<void> getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<void> checkNewVersion() async {
    await VersionUtil.checkUpdate();
    await getPackageInfo();
    hasNewVersion.value = VersionUtil.hasNewVersion();
    apkUrl.value =
        '${VersionUtil.projectUrl}/releases/download/v${VersionUtil.latestVersion}/app-armeabi-v7a-release.apk';
    apkUrl2.value =
        '${VersionUtil.projectUrl}/releases/download/v${VersionUtil.latestVersion}/app-arm64-v8a-release.apk';
    var buildNumber = hasNewVersion.value ? int.parse(packageInfo.buildNumber) + 1 : int.parse(packageInfo.buildNumber);
    windowsUrl.value =
        '${VersionUtil.projectUrl}/releases/download/v${VersionUtil.latestVersion}/BilibiliMusic-${VersionUtil.latestVersion}+${buildNumber.toString()}-windows-x64-setup.exe';
    windowsUrl2.value =
        '${VersionUtil.projectUrl}/releases/download/v${VersionUtil.latestVersion}/BilibiliMusic-${VersionUtil.latestVersion}+${buildNumber.toString()}-windows-x64.msix';
    loading.value = false;
  }
}
