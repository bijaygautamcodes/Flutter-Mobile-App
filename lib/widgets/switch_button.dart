import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/font.dart';

class RootNodeSwitchButton extends StatefulWidget {
  const RootNodeSwitchButton(
      {super.key,
      required this.isChecked,
      required this.name,
      required this.onChanged});
  final bool isChecked;
  final String name;
  final ValueChanged<bool> onChanged;

  @override
  State<RootNodeSwitchButton> createState() => _RootNodeSwitchButtonState();
}

class _RootNodeSwitchButtonState extends State<RootNodeSwitchButton> {
  late bool isChecked;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(widget.name, style: RootNodeFontStyle.body),
          CupertinoSwitch(
            onChanged: (x) => setState(() {
              isChecked = !isChecked;
              widget.onChanged(isChecked);
            }),
            value: isChecked,
            activeColor: Colors.cyan,
            trackColor: Colors.white10,
            thumbColor: const Color(0xFFeeeeee),
          ),
        ],
      ),
    );
  }
}
