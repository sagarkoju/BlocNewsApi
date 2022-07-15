import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapi/app_setup/dependency_injection.dart';
import 'package:newsapi/feature/apple_article/application/switch/switch_bloc/switch_bloc.dart';

class Utils {
  bool get getTheme => inject<SwitchBloc>().state.switchValue;
  Color get getColor => getTheme ? Colors.white : Colors.black;
}
