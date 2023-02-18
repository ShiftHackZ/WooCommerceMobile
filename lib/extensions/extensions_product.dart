import 'package:html/parser.dart';

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
