import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedometer/config/my_functions.dart';
import 'package:speedometer/config/storage.dart';
import 'package:vibration/vibration.dart';

part 'speed_event.dart';
part 'speed_state.dart';

class SpeedBloc extends Bloc<SpeedEvent, SpeedState> {
  SpeedBloc() : super(SpeedState(duration: Stopwatch())) {
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    )).listen((position) async {
      if (state.duration.isRunning) {
        add(CheckSpeedEvent(position));
      }
    });
    on<CheckSpeedEvent>((event, emit) async {
      try {
        if (event.position.speed >
            int.parse(StorageRepository.getString(StoreKeys.speed,
                defValue: "100"))) {
          if (StorageRepository.getBool(StoreKeys.vibration, defValue: true)) {
            Vibration.vibrate();
          }
          if (StorageRepository.getBool(StoreKeys.sound, defValue: true)) {
            FlutterRingtonePlayer().playNotification();
          }
        } else {
          if (StorageRepository.getBool(StoreKeys.vibration, defValue: true)) {
            final hasVibrate = await Vibration.hasVibrator();
            if (hasVibrate ?? false) {
              Vibration.cancel();
            }
          }
          if (StorageRepository.getBool(StoreKeys.sound, defValue: true)) {
            FlutterRingtonePlayer().stop();
          }
        }
        emit(
          state.copyWith(
            speed: event.position.speed.toInt(),
            speedAccuracy: event.position.speedAccuracy,
            longitude: event.position.longitude,
            latitude: event.position.latitude,
            maxSpeed: state.maxSpeed < event.position.speed
                ? event.position.speed.toInt()
                : state.maxSpeed,
            durationInMillicesonds: state.duration.elapsedMilliseconds,
            distance: state.distance +
                Geolocator.distanceBetween(
                  state.initialLat,
                  state.initialLong,
                  event.position.latitude,
                  event.position.longitude,
                ),
          ),
        );
      } catch (e) {}
    });
    on<ResumeSpeedEvent>((event, emit) async {
      state.duration.start();
      emit(state.copyWith(isPaused: false));
    });
    on<ResetSpeedEvent>((event, emit) async {
      state.duration.reset();
      final Position geolocator = await MyFunctions.determinePosition();
      emit(
        state.copyWith(
          isPlaying: true,
          distance: 0,
          speed: 0,
          initialLat: geolocator.latitude,
          initialLong: geolocator.longitude,
          maxSpeed: 0,
        ),
      );
    });
    on<StopSpeedEvent>((event, emit) async {
      state.duration.stop();
      emit(state.copyWith(isPlaying: false));
      final Position geolocator = await MyFunctions.determinePosition();
      final double distance = Geolocator.bearingBetween(state.initialLat,
          state.initialLong, geolocator.latitude, geolocator.longitude);
      emit(
        state.copyWith(
          distance: state.distance + distance,
        ),
      );
    });
    on<PauseSpeedEvent>((event, emit) async {
      state.duration.stop();
      final Position geolocator = await MyFunctions.determinePosition();
      final double distance = Geolocator.bearingBetween(state.initialLat,
          state.initialLong, geolocator.latitude, geolocator.longitude);
      emit(
        state.copyWith(
          isPaused: true,
          distance: state.distance + distance,
        ),
      );
    });
    on<StartSpeedEvent>((event, emit) async {
      try {
        state.duration.start();
        final Position geolocator = await MyFunctions.determinePosition();
        emit(
          state.copyWith(
            initialLat: geolocator.latitude,
            initialLong: geolocator.longitude,
            isPlaying: true,
          ),
        );
      } catch (e) {}
    });
  }
}
