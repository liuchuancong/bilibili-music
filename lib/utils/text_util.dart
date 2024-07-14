import 'package:intl/intl.dart';

String readableCount(String info) {
  try {
    int count = int.parse(info);
    if (count > 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    }
  } catch (e) {
    return info;
  }
  return info;
}

transformData(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  // Format the date
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
}

String formatDuration(int seconds) {
  final minutes = seconds ~/ 60; // 使用 ~/ 运算符得到整数除法的结果
  final remainingSeconds = seconds % 60; // 使用 % 运算符获取剩余的秒数

  // 格式化输出，确保秒数始终有两位数字
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}
