import 'package:url_launcher/url_launcher.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/utils/version_util.dart';

class NoNewVersionDialog extends StatelessWidget {
  const NoNewVersionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("检查更新"),
      content: const Text("已在使用最新版本"),
      actions: <Widget>[
        TextButton(
          child: const Text("确认"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class NewVersionDialog extends StatelessWidget {
  const NewVersionDialog({super.key, this.entry});

  final OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("检查更新"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("发现新版本: ${VersionUtil.latestVersion}"),
          const SizedBox(height: 20),
          Text(
            VersionUtil.latestUpdateLog,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              if (entry != null) {
                entry!.remove();
              } else {
                Navigator.pop(context);
              }
              launchUrl(
                Uri.parse('https://www.123pan.com/s/Jucxjv-NwYYd.html'),
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('本软件开源免费,国内下载：123云盘'),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("取消"),
          onPressed: () {
            if (entry != null) {
              entry!.remove();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        ElevatedButton(
          child: const Text("下载"),
          onPressed: () {
            if (entry != null) {
              entry!.remove();
            } else {
              Navigator.pop(context);
            }
            launchUrl(
              Uri.parse('https://github.com/liuchuancong/pure_live/releases'),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }
}
