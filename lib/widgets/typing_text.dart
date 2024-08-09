import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final String text;
  final String highlightText;
  final LinearGradient highlightColor;

  const TypingText({
    required this.text,
    required this.highlightText,
    required this.highlightColor,
    Key? key,
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  String displayText = '';

  @override
  void initState() {
    super.initState();
    _typeText();
  }

  Future<void> _typeText() async {
    for (var char in widget.text.split('')) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        displayText += char;
      });
    }

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      displayText += ' ${widget.highlightText}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> textParts = displayText.split(widget.highlightText);
    return Row(
      children: [
        Text(
          textParts[0],
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        if (textParts.length > 1) ...[
          ShaderMask(
            shaderCallback: (bounds) {
              return widget.highlightColor.createShader(bounds);
            },
            child: Text(
              widget.highlightText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            textParts[1],
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ],
    );
  }
}
