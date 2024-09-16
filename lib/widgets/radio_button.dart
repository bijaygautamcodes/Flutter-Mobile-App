import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/font.dart';

class RootNodeRadioButton<T> extends StatefulWidget {
  RootNodeRadioButton({
    super.key,
    required this.options,
    this.name,
    required this.onChanged,
    required this.selected,
    this.isColors = false,
    required this.value,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
  })  : assert(options.length == value.length),
        assert(isColors && value.isNotEmpty
            ? value[0].runtimeType == Color ||
                value[0].runtimeType == MaterialColor
            : true);
  final int selected;
  final List<T> value;
  final List<String> options;
  final String? name;
  final ValueChanged<T> onChanged;
  final bool isColors;
  final EdgeInsets padding;
  @override
  State<RootNodeRadioButton<T>> createState() => _RootNodeRadioButtonState<T>();
}

class _RootNodeRadioButtonState<T> extends State<RootNodeRadioButton<T>> {
  late final List<T> value;
  late final List<String> options;
  late int selected;
  @override
  void initState() {
    options = widget.options;
    value = widget.value;
    selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        runAlignment: widget.name != null
            ? WrapAlignment.spaceBetween
            : WrapAlignment.center,
        alignment: widget.name != null
            ? WrapAlignment.spaceBetween
            : WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          widget.name != null
              ? Text(widget.name!, style: RootNodeFontStyle.body)
              : const SizedBox.shrink(),
          Wrap(
            spacing: 10,
            children: _generateRadioCluster(),
          ),
        ],
      ),
    );
  }

  void _setChange() => widget.onChanged(widget.value[selected]);

  List<Widget> _generateRadioCluster() {
    final List<Widget> generated = [];

    for (int i = 0; i < options.length; i++) {
      Widget btn = OutlinedButton(
        onPressed: () => setState(() {
          selected = i;
          _setChange();
        }),
        style: ButtonStyle(
          minimumSize:
              MaterialStateProperty.resolveWith((states) => const Size(40, 40)),
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => _generateButtonBackgroundColor(index: i),
          ),
          side: MaterialStateBorderSide.resolveWith((states) =>
              BorderSide(color: _generateBorderButtonColor(index: i))),
          shape: MaterialStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: widget.isColors
            ? const SizedBox.shrink()
            : Text(
                options[i].toString(),
                style: RootNodeFontStyle.caption,
              ),
      );
      generated.add(btn);
    }
    return generated;
  }

  Color _generateButtonBackgroundColor({required int index}) {
    if (widget.isColors) {
      if (selected == index) return (value[index] as Color);
      return (value[index] as Color).withAlpha(125);
    }

    return selected == index
        ? const Color.fromRGBO(2, 116, 132, 1)
        : Colors.white10;
  }

  Color _generateBorderButtonColor({required int index}) {
    if (widget.isColors) {
      if (selected == index) return Colors.white70;
      return (value[index] as Color);
    }
    return selected == index ? Colors.cyan : Colors.white10;
  }
}
