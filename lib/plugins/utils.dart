import 'dart:convert';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:bilibilimusic/common/index.dart';

class Utils {
  static int getRandomId() {
    const uuid = Uuid();
    final hashValue = sha256.convert(utf8.encode(uuid.v8())).toString();
    return int.parse(hashValue.substring(0, 12), radix: 16) & 0xffffffff;
  }

  static Future<bool> showAlertDialog(
    String content, {
    String title = '',
    String confirm = '',
    String cancel = '',
    bool selectable = false,
    List<Widget>? actions,
  }) async {
    var result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Container(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: selectable ? SelectableText(content) : Text(content),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: (() => Navigator.of(Get.context!).pop(false)),
            child: Text(cancel.isEmpty ? "取消" : cancel),
          ),
          TextButton(
            onPressed: (() => Navigator.of(Get.context!).pop(true)),
            child: Text(confirm.isEmpty ? "确定" : confirm),
          ),
          ...?actions,
        ],
      ),
    );
    return result ?? false;
  }

  /// 提示弹窗
  /// - `content` 内容
  /// - `title` 弹窗标题
  /// - `confirm` 确认按钮内容，留空为确定
  static Future<bool> showMessageDialog(String content,
      {String title = '', String confirm = '', bool selectable = false}) async {
    var result = await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: selectable ? SelectableText(content) : Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(Get.context!).pop(true);
            },
            child: Text(confirm.isEmpty ? "确定" : confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<Map<String, String?>?> showEditDialog({
    String title = '',
    String author = '',
    String titleHint = '请输入标题',
    String authorHint = '请输入作者',
    String confirm = '确定',
    String cancel = '取消',
    bool isEdit = false,
  }) async {
    final TextEditingController titleController = TextEditingController(text: title);
    final TextEditingController authorController = TextEditingController(text: author);

    var result = await Get.dialog(
      AlertDialog(
        title: Text(
          isEdit ? '编辑专辑' : '添加专辑',
          style: const TextStyle(fontSize: 16),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: titleHint,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: authorController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: authorHint,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(Get.context!).pop();
            },
            child: Text(cancel),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty) {
                SmartDialog.showToast('标题不能为空');
                return;
              }
              Navigator.of(Get.context!).pop({
                'title': titleController.text,
                'author': isEdit
                    ? authorController.text
                    : authorController.text.isNotEmpty
                        ? authorController.text
                        : '佚名'
              });
            },
            child: Text(confirm),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result as Map<String, String?>?;
  }

  static void showRightDialog({
    required String title,
    Function()? onDismiss,
    required Widget child,
    double width = 320,
    bool useSystem = false,
  }) {
    SmartDialog.show(
      alignment: Alignment.topRight,
      animationBuilder: (controller, child, animationParam) {
        //从右到左
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(controller.view),
          child: child,
        );
      },
      useSystem: useSystem,
      maskColor: Colors.transparent,
      animationTime: const Duration(milliseconds: 200),
      builder: (context) => Container(
        width: width + MediaQuery.of(context).padding.right,
        padding: EdgeInsets.only(right: MediaQuery.of(context).padding.right),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: SafeArea(
          left: false,
          right: false,
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.zero),
            child: Column(
              children: [
                ListTile(
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  leading: IconButton(
                    onPressed: () {
                      SmartDialog.dismiss(status: SmartStatus.allCustom).then(
                        (value) => onDismiss?.call(),
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    title,
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.withValues(alpha: .1),
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hideRightDialog() {
    SmartDialog.dismiss(status: SmartStatus.allCustom);
  }

  /// 文本编辑的弹窗
  /// - `content` 编辑框默认的内容
  /// - `title` 弹窗标题
  /// - `confirm` 确认按钮内容
  /// - `cancel` 取消按钮内容
  static Future<String?> showEditTextDialog(String content,
      {String title = '', String? hintText, String confirm = '', String cancel = ''}) async {
    final TextEditingController textEditingController = TextEditingController(text: content);
    var result = await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              //prefixText: title,
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText ?? title,
            ),
            // style: TextStyle(
            //     height: 1.0,
            //     color: Get.isDarkMode ? Colors.white : Colors.black),
            autofocus: true,
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
            onPressed: () {
              Navigator.of(Get.context!).pop(textEditingController.text);
            },
            child: const Text("确定"),
          ),
        ],
      ),
      // barrierColor:
      //     Get.isDarkMode ? Colors.grey.withValues(alpha:.3) : Colors.black38,
    );
    return result;
  }

  static Future<T?> showOptionDialog<T>(
    List<T> contents,
    T value, {
    String title = '',
  }) async {
    var result = await Get.dialog(
      SimpleDialog(
        title: Text(title),
        children: contents
            .map(
              (e) => RadioListTile<T>(
                title: Text(e.toString()),
                value: e,
                // ignore: deprecated_member_use
                groupValue: value,
                // ignore: deprecated_member_use
                onChanged: (e) {
                  Navigator.of(Get.context!).pop(e);
                },
              ),
            )
            .toList(),
      ),
    );
    return result;
  }

  static Future<String?> showBottomSheet() async {
    var result = await Get.bottomSheet(
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Center(child: Text('置顶')),
                onTap: () {
                  Navigator.of(Get.context!).pop('1');
                },
              ),
              ListTile(
                title: const Center(child: Text('编辑')),
                onTap: () {
                  Navigator.of(Get.context!).pop('2');
                },
              ),
              ListTile(
                title: const Center(child: Text('删除')),
                onTap: () {
                  Navigator.of(Get.context!).pop('3');
                },
              ),
              ListTile(
                title: const Center(child: Text('取消')),
                onTap: () {
                  Navigator.of(Get.context!).pop('4');
                },
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
    );
    return result;
  }
}
