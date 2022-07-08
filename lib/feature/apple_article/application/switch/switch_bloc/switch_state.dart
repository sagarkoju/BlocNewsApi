part of 'switch_bloc.dart';

class SwitchState {
  final bool switchValue;
  SwitchState({required this.switchValue});
}

class SwitchInitial extends SwitchState {
  SwitchInitial({required bool switchValue}) : super(switchValue: switchValue);
}
