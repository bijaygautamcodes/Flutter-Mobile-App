import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/font.dart';

class SelectionTile extends StatelessWidget {
  const SelectionTile({
    super.key,
    required this.title,
    required this.tileButton,
    this.widthFraction = 0.8,
    this.heightFraction = 0.8,
    this.column = 2,
    this.hideTitle = false,
    required this.bottomLabel,
  })  : assert(widthFraction <= 1 && widthFraction >= 0),
        assert(heightFraction <= 1 && heightFraction >= 0);
  final String title;
  final List<TileButton> tileButton;
  final double widthFraction;
  final double heightFraction;
  final int column;
  final bool hideTitle;
  final String bottomLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      runSpacing: 10,
      spacing: 10,
      children: [
        hideTitle
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.only(
                    top: 5, left: 15, right: 15, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  title,
                  style: RootNodeFontStyle.caption
                      .copyWith(color: Colors.white70, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
        Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * heightFraction),
          width: MediaQuery.of(context).size.width * widthFraction,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10)),
          child: GridView.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: column,
            shrinkWrap: true,
            children: tileButton,
          ),
        ),
        Text(
          bottomLabel,
          style: RootNodeFontStyle.label,
        )
      ],
    );
  }
}

enum RNContentType { image, video, text, markdown }

class TileButton extends StatelessWidget {
  const TileButton({
    super.key,
    required this.type,
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final RNContentType type;
  final IconData icon;
  final String label;
  final Function(RNContentType type) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(type),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white10),
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 26, weight: 0.5),
            Text(
              label,
              style: RootNodeFontStyle.body.copyWith(
                color: Colors.white70,
              ),
            )
          ],
        ),
      ),
    );
  }
}
