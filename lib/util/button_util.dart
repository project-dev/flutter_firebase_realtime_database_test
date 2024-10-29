import 'package:flutter/material.dart';

class ButtonUtil{

  /// ボタンの作成
  static TextButton create({
    required void Function() onPressed,
    required IconData? icon,
    required String label,
    double? size = 24,
  }){
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: size),
      label: Text(label, style: TextStyle(fontSize: size),),
    );
  }

}