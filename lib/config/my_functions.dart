import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiffy/jiffy.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

abstract class MyFunctions {
  static String? returnNullIfEmpty(
          {required String? v, required String? origin}) =>
      v == null
          ? origin
          : v.isEmpty
              ? null
              : v;

  static Future<ImageInfo> getImageInfo(
      BuildContext context, String image) async {
    AssetImage assetImage = AssetImage(image);
    ImageStream stream =
        assetImage.resolve(createLocalImageConfiguration(context));
    Completer<ImageInfo> completer = Completer();
    stream.addListener(ImageStreamListener((ImageInfo imageInfo, _) {
      return completer.complete(imageInfo);
    }));
    return completer.future;
  }

  static Future<Uint8List> getBytesFromCanvas(
      {required int width,
      required int height,
      required int placeCount,
      required BuildContext context,
      Offset? offset,
      required String image,
      bool shouldAddText = true}) async {
    final pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.red;
    canvas.drawImage(
        await getImageInfo(context, image).then((value) => value.image),
        offset ?? const Offset(0, 3),
        paint);

    if (shouldAddText) {
      TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
      painter.text = TextSpan(
        text: placeCount.toString(),
        style: const TextStyle(fontSize: 100.0, color: Colors.white),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset((width * 0.47) - painter.width * 0.2,
            (height * 0.1) - painter.height * 0.1),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List() ?? Uint8List(0);
  }

  static Future<Uint8List> myLocationCanvas({
    required double radius,
    required BuildContext context,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.cyanAccent.withOpacity(0.12);
    final Paint paint2 = Paint();
    paint2.style = PaintingStyle.stroke;
    paint2.color = Colors.cyanAccent;
    paint2.strokeWidth = 10;
    canvas.drawCircle(Offset(radius + 10, radius + 10), radius, paint);
    canvas.drawCircle(Offset(radius + 10, radius + 10), radius, paint2);

    final img = await pictureRecorder
        .endRecording()
        .toImage((2 * radius + 20).toInt(), (2 * radius + 20).toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List() ?? Uint8List(0);
  }

  static Future<MapObject<dynamic>> getMyPoint(
      Point point, BuildContext context) async {
    final myIconData = await getBytesFromCanvas(
        placeCount: 0,
        image: "assets/car.png",
        width: 48,
        //offset: const Offset(0, -30),
        height: 48,
        context: context,
        shouldAddText: false);
    final myPoint = PlacemarkMapObject(
      opacity: 1,
      mapId: const MapObjectId('my-point'),
      point: point,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          scale: 0.6,
          image: BitmapDescriptor.fromBytes(myIconData),
        ),
      ),
    );
    return myPoint;
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (!serviceEnabled || permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const FormatException('location_permission_disabled');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const FormatException('location_permission_disabled');
        } else if (permission == LocationPermission.deniedForever) {
          throw const FormatException('location_permission_permanent_disabled');
        }
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  static String formatTime(int time) =>
      Jiffy.parseFromMillisecondsSinceEpoch(time, isUtc: true)
          .format(pattern: "HH:mm:ss");

  static double getRadiusFromZoom(double zoom) {
    return 40000 / pow(2, zoom) > 1 ? 40000 / pow(2, zoom) : 1;
  }
}
