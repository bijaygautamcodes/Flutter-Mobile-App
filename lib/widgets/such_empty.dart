import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/font.dart';

class SuchEmpty extends StatelessWidget {
  const SuchEmpty({
    super.key,
    this.icon = Boxicons.bx_selection,
  });
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        direction: Axis.vertical,
        children: [
          const Icon(
            Boxicons.bx_area,
            color: Colors.white10,
            size: 64,
          ),
          Text("Wow! Such Empty?", style: RootNodeFontStyle.labelSmall)
        ],
      ),
    );
  }
}
