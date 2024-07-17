import 'package:bilibilimusic/play/lyric/lyrics_reader_model.dart';
import 'package:bilibilimusic/play/lyric/lyric_parser/parser_lrc.dart';
import 'package:bilibilimusic/play/lyric/lyric_parser/parser_qrc.dart';
import 'package:bilibilimusic/play/lyric/lyric_parser/lyrics_parse.dart';

///smart parser
///Parser is automatically selected
class ParserSmart extends LyricsParse {
  ParserSmart(super.lyric);

  @override
  List<LyricsLineModel> parseLines({bool isMain = true}) {
    var qrc = ParserQrc(lyric);
    if (qrc.isOK()) {
      return qrc.parseLines(isMain: isMain);
    }
    return ParserLrc(lyric).parseLines(isMain: isMain);
  }
}
