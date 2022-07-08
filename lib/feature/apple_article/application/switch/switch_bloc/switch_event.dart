part of 'switch_bloc.dart';

abstract class SwitchEvent {
  const SwitchEvent();
}

class SwitchOnEvent extends SwitchEvent {}

class SwitchOffEvent extends SwitchEvent {}
