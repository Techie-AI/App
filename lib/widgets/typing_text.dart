import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final String text;
  final String highlightText;
  final LinearGradient highlightColor;
  final TextStyle textStyle; // Add this

  const TypingText({
    required this.text,
    required this.highlightText,
    required this.highlightColor,
    required this.textStyle, // Add this
    Key? key,
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String displayedText = '';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _typeText();
  }

  void _typeText() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (currentIndex < widget.text.length) {
        setState(() {
          displayedText += widget.text[currentIndex];
          currentIndex++;
        });
        _typeText();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textSpans = <TextSpan>[];

    if (displayedText.contains(widget.highlightText)) {
      final startIndex = displayedText.indexOf(widget.highlightText);
      final endIndex = startIndex + widget.highlightText.length;

      textSpans.add(TextSpan(
        text: displayedText.substring(0, startIndex),
        style: widget.textStyle,
      ));

      textSpans.add(TextSpan(
        text: displayedText.substring(startIndex, endIndex),
        style: widget.textStyle.copyWith(
          foreground: Paint()
            ..shader = widget.highlightColor.createShader(
              Rect.fromLTWH(
                  0, 0, widget.highlightText.length.toDouble() * 10, 0),
            ),
        ),
      ));

      textSpans.add(TextSpan(
        text: displayedText.substring(endIndex),
        style: widget.textStyle,
      ));
    } else {
      textSpans.add(TextSpan(text: displayedText, style: widget.textStyle));
    }

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }
}
