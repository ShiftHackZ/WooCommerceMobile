import 'package:flutter/material.dart';

//region CONFIGURATION MODELS
enum _TypeAnimationOperation {
  print,
  keep,
  erase;
}

class TypeAnimationEntry {
  final String text;
  final Duration typeDuration;
  final Duration keepDuration;
  final Duration eraseDuration;

  TypeAnimationEntry({
    required this.text,
    this.typeDuration = const Duration(milliseconds: 150),
    this.keepDuration = const Duration(milliseconds: 1500),
    this.eraseDuration = const Duration(milliseconds: 50),
  });
}

enum TypeAnimationAlignmentMode {
  row,
  column;
}
//endregion

//region WIDGET LOGIC
class TypeAnimationText extends StatefulWidget {
  final List<TypeAnimationEntry> entries;
  final MainAxisAlignment mainAxisAlignment;
  final TypeAnimationAlignmentMode alignmentMode;
  final TextStyle textStyle;
  final Duration cursorBlinkDuration;
  final Color cursorColor;
  final String prefix;
  final bool loop;

  const TypeAnimationText({
    super.key,
    required this.entries,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.alignmentMode = TypeAnimationAlignmentMode.row,
    this.textStyle = const TextStyle(fontSize: 18),
    this.cursorBlinkDuration = const Duration(milliseconds: 400),
    this.cursorColor = Colors.blue,
    this.prefix = '',
    this.loop = true,
  });

  @override
  State<StatefulWidget> createState() => _TypeAnimationTextState();
}

class _TypeAnimationTextState extends State<TypeAnimationText>
    with TickerProviderStateMixin {
  late AnimationController _cursorAnimController;
  late AnimationController _typingAnimController;

  var _currentEntry = 0;
  var _currentContent = '';

  var _operation = _TypeAnimationOperation.print;

  @override
  void initState() {
    _cursorAnimController = AnimationController(
      vsync: this,
      duration: widget.cursorBlinkDuration,
    );
    _cursorAnimController.repeat(reverse: true);
    _printPhase();
    super.initState();
  }

  @override
  void dispose() {
    _cursorAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.alignmentMode == TypeAnimationAlignmentMode.column) {
      return Column(
        mainAxisAlignment: widget.mainAxisAlignment,
        children: [
          Text(
            widget.prefix,
            style: widget.textStyle,
          ),
          Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _currentContent,
                  style: widget.textStyle,
                ),
              ),
              FadeTransition(
                opacity: _cursorAnimController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: 2,
                    height: widget.textStyle.fontSize,
                    decoration: BoxDecoration(
                      color: widget.cursorColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: [
        Text(
          widget.prefix,
          style: widget.textStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            _currentContent,
            style: widget.textStyle,
          ),
        ),
        FadeTransition(
          opacity: _cursorAnimController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 2,
              height: widget.textStyle.fontSize,
              decoration: BoxDecoration(
                color: widget.cursorColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _printPhase() {
    _typingAnimController = AnimationController(
      vsync: this,
      duration: widget.entries[_currentEntry].typeDuration,
    );
    _typingAnimController.addListener(() {
      setState(() {
        if (_typingAnimController.value == 1.0 &&
            _operation == _TypeAnimationOperation.print) {
          _currentContent +=
          widget.entries[_currentEntry].text[_currentContent.length];
          if (_currentContent.length <
              widget.entries[_currentEntry].text.length) {
            _typingAnimController.reset();
            _typingAnimController.animateTo(1.0);
          } else {
            _operation = _TypeAnimationOperation.keep;
            _typingAnimController.reset();
            _keepPhase();
          }
        }
      });
    });
    _typingAnimController.animateTo(1.0);
  }

  void _keepPhase() {
    _typingAnimController = AnimationController(
      vsync: this,
      duration: widget.entries[_currentEntry].keepDuration,
    );
    _typingAnimController.addListener(() {
      setState(() {
        if (_typingAnimController.value == 1.0 &&
            _operation == _TypeAnimationOperation.keep) {
          _operation = _TypeAnimationOperation.erase;
          _typingAnimController.reset();
          _erasePhase();
        }
      });
    });
    _typingAnimController.animateTo(1.0);
  }

  void _erasePhase() {
    _typingAnimController = AnimationController(
      vsync: this,
      duration: widget.entries[_currentEntry].eraseDuration,
    );
    _typingAnimController.addListener(() {
      setState(() {
        if (_typingAnimController.value == 1.0 &&
            _operation == _TypeAnimationOperation.erase) {
          if (_currentContent.isNotEmpty) {
            _currentContent =
                _currentContent.substring(0, _currentContent.length - 1);
            _typingAnimController.reset();
            _typingAnimController.animateTo(1.0);
          } else {
            _operation = _TypeAnimationOperation.print;
            _typingAnimController.reset();
            _currentEntry++;
            if (_currentEntry >= widget.entries.length) _currentEntry = 0;
            if (_currentEntry > 0 || widget.loop) _printPhase();
          }
        }
      });
    });
    _typingAnimController.animateTo(1.0);
  }
}
//endregion
