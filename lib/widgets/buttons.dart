import 'package:flutter/material.dart';

class RootNodeOutlinedButton extends StatelessWidget {
  const RootNodeOutlinedButton(
      {super.key, required this.child, required this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize:
            MaterialStateProperty.resolveWith((states) => const Size(40, 40)),
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => Colors.transparent,
        ),
        side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(color: Colors.white54)),
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: child,
    );
  }
}
