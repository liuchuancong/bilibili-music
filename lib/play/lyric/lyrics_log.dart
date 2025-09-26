import 'dart:developer';

///print log control
class LyricsLog {
  ///print switch
  static var lyricEnableLog = false;

  static const _defaultTag = "LyricReader->";

  static void logD(Object? obj) {
    _log(_defaultTag, obj);
  }

  static void logW(Object? obj) {
    _log("$_defaultTag♦️WARN♦️->", obj);
  }

  static void _log(String tag, Object? obj) {
    if (lyricEnableLog) log(tag + obj.toString());
  }
}
