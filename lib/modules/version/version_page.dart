import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/update.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:bilibilimusic/utils/version_util.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:bilibilimusic/common/global/platform_utils.dart';
import 'package:bilibilimusic/modules/version/version_controller.dart';

class VersionPage extends GetView<VersionController> {
  const VersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('版本更新')),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        final hasAnyContent = (PlatformUtils.isDesktop && controller.windowsUrl.value.isNotEmpty == true) ||
            (PlatformUtils.isMobile &&
                (controller.apkUrl.value.isNotEmpty == true || controller.apkUrl2.value.isNotEmpty == true));
        if (!hasAnyContent) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                '暂无可用的更新地址',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (PlatformUtils.isDesktop) ...[
                  _buildDownloadSection(title: 'Windows (exe) 下载地址', urls: controller.windowsUrl.value),
                  _buildDownloadSection(title: 'Windows (msix) 下载地址', urls: controller.windowsUrl2.value),
                ],
                if (PlatformUtils.isMobile) ...[
                  _buildDownloadSection(title: 'ARM64 (arm64-v8a) 版本', urls: controller.apkUrl2.value),
                  const SizedBox(height: 24),
                  _buildDownloadSection(title: 'ARM32 (armeabi-v7a) 版本', urls: controller.apkUrl.value),
                ],
                MarkdownBlock(
                  data: VersionUtil.latestUpdateLog,
                  config: Get.isDarkMode ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDownloadSection({required String title, required String urls}) {
    final List<String> mirrorUrls = getMirrorUrls(urls);

    if (mirrorUrls.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        color: Theme.of(Get.context!).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            '暂无 $title',
            style: TextStyle(color: Theme.of(Get.context!).colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(Get.context!).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            // 桌面端 4 列，移动端 2 列（更易点击）
            final int maxColumns = PlatformUtils.isDesktop ? 4 : 2;
            const double spacing = 8.0;
            final double buttonWidth = (maxWidth - spacing * (maxColumns - 1)) / maxColumns;

            return Wrap(
              spacing: spacing,
              runSpacing: 10,
              children: [
                for (int i = 0; i < mirrorUrls.length; i++)
                  SizedBox(
                    width: buttonWidth,
                    child: Tooltip(
                      message: mirrorUrls[i],
                      child: ElevatedButton.icon(
                        onPressed: () {
                          downloadAndInstallApk(mirrorUrls[i]);
                        },
                        icon: const Icon(Icons.download, size: 16),
                        label: Flexible(
                          child: Text(
                            '地址 ${i + 1}',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 减小最小点击区域（可选）
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
