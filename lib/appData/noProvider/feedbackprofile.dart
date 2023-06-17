import 'dart:ui';

import 'package:flutter/material.dart';

class FeedbackProfile {
  String category = "";
  List<String> subcategories = [];
  String categoryImage = "";
  List<String> subcategoriesImage = [];
  List<Color> subcategoriesColor = [];
  Color categoryColor = Color.fromRGBO(255, 255, 255, 255);

  FeedbackProfile({category, subcategories});

  void setCategory(String category) {
    this.category = category;
  }

  void setSubcategory(String subcategory) {
    subcategories.add(subcategory);
  }

  void setImageCategory(String image) {
    categoryImage = image;
  }

  void setImageSubCategory(String image) {
    subcategoriesImage.add(image);
  }

  void setColorCategory(Color color) {
    categoryColor = color;
  }

  void setColorSubCategory(Color color) {
    subcategoriesColor.add(color);
  }

  String getCategory() {
    return category;
  }

  List<String> getSubcategories() {
    return subcategories;
  }

  String getImageCategory() {
    return categoryImage;
  }

  List<String> getImageSubCategory() {
    return subcategoriesImage;
  }

  Color getColorCategory() {
    return categoryColor;
  }

  List<Color> getSubcategoriesColor() {
    return subcategoriesColor;
  }
}
