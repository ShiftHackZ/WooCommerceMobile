import 'package:html/parser.dart';

String parseHtml(String htmlDescription) {
  final document = parse(htmlDescription);
  return parse(document.body!.text).documentElement!.text;
}
