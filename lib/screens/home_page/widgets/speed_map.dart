import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer/blocs/speed_bloc.dart';
import 'package:speedometer/config/my_functions.dart';
import 'package:speedometer/screens/home_page/widgets/map_controller_buttons.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class SpeedMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  const SpeedMap({required this.latitude, required this.longitude, super.key});

  @override
  State<SpeedMap> createState() => _SpeedMapState();
}

class _SpeedMapState extends State<SpeedMap>
    with AutomaticKeepAliveClientMixin {
  late List<MapObject<dynamic>> _mapObjects;
  late YandexMapController mapController;
  double zoom = 25;
  @override
  void initState() {
    super.initState();
    _mapObjects = [];
    AndroidYandexMap.useAndroidViewSurface = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<SpeedBloc, SpeedState>(
      buildWhen: (previous, current) => previous.speed != current.speed,
      listener: (context, state) async {
        final point = await MyFunctions.getMyPoint(
          Point(latitude: state.latitude, longitude: state.longitude),
          context,
        );
        _mapObjects.clear();
        _mapObjects.add(point);
      },
      builder: (context, state) {
        return Stack(
          children: [
            YandexMap(
              rotateGesturesEnabled: false,
              fastTapEnabled: true,
              // mode2DEnabled: true,
              // mapType: MapType.hybrid,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              onCameraPositionChanged:
                  (cameraPosition, updateReason, isStopped) async {
                await mapController.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: Point(
                        latitude: state.latitude,
                        longitude: state.longitude,
                      ),
                      zoom: 50,
                    ),
                  ),
                  animation: const MapAnimation(
                      duration: 0.15, type: MapAnimationType.smooth),
                );
              },
              onMapTap: (point) {
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              },
              mapObjects: _mapObjects,
              onMapCreated: (controller) async {
                print("map created");
                mapController = controller;

                final position = await MyFunctions.determinePosition();
                final point = await MyFunctions.getMyPoint(
                  Point(
                      latitude: position.latitude,
                      longitude: position.longitude),
                  context,
                );
                _mapObjects.clear();
                _mapObjects.add(point);
                print("point added ${_mapObjects}");
                // setState(() {});
                await mapController.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: Point(
                        latitude: position.latitude,
                        longitude: position.longitude,
                      ),
                      zoom: zoom,
                    ),
                  ),
                  animation: const MapAnimation(
                    duration: 0.15,
                    type: MapAnimationType.smooth,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: MapControllerButtons(onMinusTap: () {
                zoom = zoom - 1;
                setState(() {});
                mapController.moveCamera(
                  CameraUpdate.zoomTo(zoom),
                  animation: const MapAnimation(
                    duration: 0.2,
                    type: MapAnimationType.smooth,
                  ),
                );
              }, onPlusTap: () {
                zoom = zoom + 1;
                setState(() {});
                mapController.moveCamera(
                  CameraUpdate.zoomTo(zoom + 1),
                  animation: const MapAnimation(
                    duration: 0.2,
                    type: MapAnimationType.smooth,
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
