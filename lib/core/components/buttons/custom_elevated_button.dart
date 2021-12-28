import 'package:flutter/material.dart';
import 'package:coflow_app/core/extension/context_extension.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(context.colors.onPrimary),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              context.mediumValue,
            ),
          ),
        ),
        padding: MaterialStateProperty.all(context.paddingNormal),
      ),
    );
  }
}
