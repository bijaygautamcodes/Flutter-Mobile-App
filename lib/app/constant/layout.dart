import 'package:flutter/material.dart';

class LayoutConstants {
  static const double postPadding = 16.0;
  static const double postOuterMargin = 10.0;
  static const double postInnerMargin = 16.0;

  static const double postTitle = 18.0;
  static const double postSubtitle = 16.0;
  static const double postMetaData = 14.0;

  static const double postIconBig = 24.0;
  static const double postIcon = 20.0;
  static const double postIconSmall = 18.0;

  static const double mainRadius = 12.0;
  static const double compRadius = 8.0;

  static const EdgeInsets postMarginTLR = EdgeInsets.only(
      top: postOuterMargin, left: postOuterMargin, right: postOuterMargin);
  static const EdgeInsets postPaddingTLR =
      EdgeInsets.only(top: postPadding, left: postPadding, right: postPadding);
  static const BorderRadius postCardBorderRadius =
      BorderRadius.all(Radius.circular(mainRadius));
  static const BorderRadius postContentBorderRadius =
      BorderRadius.all(Radius.circular(compRadius));

  static const EdgeInsets postActionPadding =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15);
}
