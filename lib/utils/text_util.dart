import 'package:intl/intl.dart';

String readableCount(String info) {
  if (info.isEmpty) {
    return '0';
  }

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
  // 如果秒数是负数，我们取其绝对值来计算小时、分钟和秒数，
  // 并在最终结果前加上负号。
  bool isNegative = seconds < 0;
  seconds = seconds.abs();

  final hours = seconds ~/ 3600; // 使用 ~/ 运算符得到整数除法的结果（每小时3600秒）
  final remainingSecondsAfterHours = seconds % 3600;
  final minutes = remainingSecondsAfterHours ~/ 60;
  final remainingSeconds = remainingSecondsAfterHours % 60;

  // 格式化输出，确保小时、分钟和秒数始终有两位数字
  String formattedTime =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

  // 如果原始输入是负数，在结果前面添加负号
  if (isNegative) {
    formattedTime = '-$formattedTime';
  }

  return formattedTime;
}

int convertToTimestampFromNow(String time) {
  // 检查输入是否有效
  if (time.isEmpty || !time.contains(':')) {
    return 0;
  }

  // 分割时间和计算总秒数
  List<String> parts = time.split(':');
  int minutes = int.parse(parts[0]);
  int seconds = int.parse(parts[1]);
  int totalSeconds = minutes * 60 + seconds;

  return totalSeconds;
}
