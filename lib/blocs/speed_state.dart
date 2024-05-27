part of 'speed_bloc.dart';

class SpeedState extends Equatable {
  final int speed;
  final int maxSpeed;
  final int averageSpeed;
  final double distance;
  final double speedAccuracy;
  final double longitude;
  final double latitude;
  final bool isPlaying;
  final bool isPaused;
  final Stopwatch duration;
  final int durationInMillicesonds;
  final double initialLong;
  final double initialLat;
  const SpeedState({
    this.speed = 0,
    this.maxSpeed = 0,
    this.averageSpeed = 0,
    this.distance = 0,
    this.speedAccuracy = 0,
    this.longitude = 0,
    this.latitude = 0,
    this.isPlaying = false,
    this.isPaused = false,
    required this.duration,
    this.durationInMillicesonds = 0,
    this.initialLat = 0,
    this.initialLong = 0,
  });

  SpeedState copyWith({
    int? speed,
    int? maxSpeed,
    int? averageSpeed,
    double? distance,
    double? speedAccuracy,
    double? longitude,
    double? latitude,
    bool? isPlaying,
    bool? isPaused,
    Stopwatch? duration,
    int? durationInMillicesonds,
    double? initialLong,
    double? initialLat,
  }) {
    return SpeedState(
      speed: speed ?? this.speed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      distance: distance ?? this.distance,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      durationInMillicesonds:
          durationInMillicesonds ?? this.durationInMillicesonds,
      initialLong: initialLong ?? this.initialLong,
      initialLat: initialLat ?? this.initialLat,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object> get props => [
        speed,
        maxSpeed,
        averageSpeed,
        distance,
        speedAccuracy,
        longitude,
        latitude,
        isPlaying,
        duration,
        durationInMillicesonds,
        initialLong,
        initialLat,
        isPaused,
      ];
}
