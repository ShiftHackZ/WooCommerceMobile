import 'package:html/parser.dart';
import 'package:intl/intl.dart' as intl;

const _dateFormatSeverDefault = "yyyy-MM-dd'T'HH:mm:SS";
const _dateFormatUiDefault = "dd MMMM yyyy',' HH:mm";

String parseHtml(String htmlDescription) {
  final document = parse(htmlDescription);
  return parse(document.body!.text).documentElement!.text;
}

String parseTotals(
  String totals, {
  int fraction = 2,
  String delimiter = '.',
}) {
  var partBase = totals.substring(0, totals.length - fraction);
  var partFraction = totals.substring(totals.length - fraction, totals.length);
  return '$partBase$delimiter$partFraction';
}

String convertDate(
  String? input, {
  String inFormat = _dateFormatSeverDefault,
  String outFormat = _dateFormatUiDefault,
  bool inFormatUTC = false,
  bool convertToLocal = false,
  String? locale,
}) {
  if (input == null || input.isEmpty) return '';
  try {
    DateTime dateUTC = intl.DateFormat(inFormat).parse(input, inFormatUTC);
    return intl
        .DateFormat(outFormat, locale)
        .format(convertToLocal ? dateUTC.toLocal() : dateUTC);
  } catch (e) {
    return '';
  }
}
