

import 'package:flutter/material.dart';

extension GetArgument on BuildContext {

  T? getArgument<T> () {
    final moduleRoute = ModalRoute.of(this);
    if (moduleRoute != null){
      final args = moduleRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
  }

}