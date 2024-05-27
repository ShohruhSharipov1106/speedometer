import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:speedometer/config/my_functions.dart';
import 'package:speedometer/screens/home_page/screens/horizontal_home.dart';
import 'package:speedometer/screens/home_page/screens/vertical_home.dart';
import 'package:speedometer/screens/settings_page/settings_page.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ValueNotifier rotateNotifier;
  late Database _database;
  late ValueNotifier<List> avgSpeed;
  @override
  void initState() {
    super.initState();

    rotateNotifier = ValueNotifier(false)
      ..addListener(() {
        if (rotateNotifier.value) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
      });
    avgSpeed = ValueNotifier([])
      ..addListener(() async {
        try {
          List<Map<String, dynamic>> usageData =
              await _database.query('avg_speed');

          for (var data in usageData) {
            avgSpeed.value.add(data['speed'] as int);
          }
        } catch (e) {
          print('Error sending data to server: $e');
        }
      });
    MyFunctions.determinePosition();

    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'avg_speed.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS usage_data(id INTEGER PRIMARY KEY, duration INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> _insertUsageData({required int speed}) async {
    await _database.insert(
      'avg_speed',
      {'speed': speed},
    );
  }

  @override
  void dispose() {
    _insertUsageData(speed: 0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Speedometer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          /// ROTATE
          IconButton(
            onPressed: () {
              rotateNotifier.value = !rotateNotifier.value;
            },
            icon: const Icon(
              Icons.crop_rotate_outlined,
              color: Colors.white,
            ),
          ),

          /// SETTINGS
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                fade(page: const SettingsPage()),
              );
            },
            icon: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: rotateNotifier,
        builder: (context, child) {
          return rotateNotifier.value
              ? const HorizontalHome()
              : child ?? const SizedBox();
        },
        child: const VerticalHome(),
      ),
    );
  }
}

class ShowItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  const ShowItem({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

PageRouteBuilder fade({required Widget page, RouteSettings? settings}) =>
    PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                curve: const Interval(0, 1, curve: Curves.linear),
                parent: animation,
              ),
              child: child,
            ),
        settings: settings,
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            page);
