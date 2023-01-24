import 'package:flutter/material.dart';

class CardModel {
  late final String title;                  /// required
  late final String imagePath;            /// required  i.e "assets/images/image.png"
  late final String description;        /// (Optional)
  late final Color color;             /// (Optional) add this parameter if you want to have different color on each card
  late final List<Color> colorList; /// (Optional) add this parameter if you want to apply different gradient on each card
}