part of 'speed_bloc.dart';

abstract class SpeedEvent extends Equatable {
  const SpeedEvent();
}

class CheckSpeedEvent extends SpeedEvent {
  final Position position;
  const CheckSpeedEvent(this.position);
  @override
  List<Object> get props => [position];
}

class ResetSpeedEvent extends SpeedEvent {
  const ResetSpeedEvent();
  @override
  List<Object> get props => [];
}

class StopSpeedEvent extends SpeedEvent {
  const StopSpeedEvent();
  @override
  List<Object> get props => [];
}

class PauseSpeedEvent extends SpeedEvent {
  const PauseSpeedEvent();
  @override
  List<Object> get props => [];
}

class ResumeSpeedEvent extends SpeedEvent {
  const ResumeSpeedEvent();
  @override
  List<Object> get props => [];
}

class StartSpeedEvent extends SpeedEvent {
  const StartSpeedEvent();
  @override
  List<Object> get props => [];
}

class GetHistoryEvent extends SpeedEvent {
  const GetHistoryEvent();
  @override
  List<Object> get props => [];
}

class ClearHistoryEvent extends SpeedEvent {
  const ClearHistoryEvent();
  @override
  List<Object> get props => [];
}
