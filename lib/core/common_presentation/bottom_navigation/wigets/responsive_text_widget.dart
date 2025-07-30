import 'package:flutter/cupertino.dart';

class ResponsiveTextWidget extends StatelessWidget {
  const ResponsiveTextWidget({
    super.key,
    this.textColor,
    this.fontWeight,
    this.fontSize,
    required this.text,
  });
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
        maxLines: 1, // ← tell Text it gets one line
        overflow: TextOverflow.ellipsis,
        softWrap: false, // ← optional, prevents automatic wrapping
      ),
    );
  }
}
