import 'package:easy_refresh/easy_refresh.dart';

void initRefresh() {
  EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
        armedText: '松开加载',
        dragText: '上拉刷新',
        readyText: '加载中...',
        processingText: '正在刷新...',
        noMoreText: '没有更多数据了',
        failedText: '加载失败',
        messageText: '上次加载时间 %T',
        processedText: '加载成功',
      );
  EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
        armedText: '松开加载',
        dragText: '下拉刷新',
        readyText: '加载中...',
        processingText: '正在刷新...',
        noMoreText: '没有更多数据了',
        failedText: '加载失败',
        messageText: '上次加载时间 %T',
        processedText: '加载成功',
      );
}
