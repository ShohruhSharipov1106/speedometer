import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speedometer/blocs/speed_bloc.dart';
import 'package:speedometer/config/my_functions.dart';
import 'package:speedometer/config/storage.dart';
import 'package:speedometer/screens/home_page/home_page.dart';
import 'package:speedometer/screens/home_page/widgets/speed_digital.dart';
import 'package:speedometer/screens/home_page/widgets/speed_gauge.dart';
import 'package:speedometer/screens/home_page/widgets/speed_map.dart';
import 'package:speedometer/screens/home_page/widgets/start_button.dart';
import 'package:speedometer/screens/home_page/widgets/stop_button.dart';

class VerticalHome extends StatefulWidget {
  const VerticalHome({super.key});

  @override
  State<VerticalHome> createState() => _VerticalHomeState();
}

class _VerticalHomeState extends State<VerticalHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "O'lchagich"),
              Tab(text: "Raqamli"),
              Tab(text: "Xarita"),
            ],
            indicatorColor: Colors.cyanAccent,
            labelColor: Colors.cyanAccent,
            unselectedLabelColor: Colors.grey,
            dividerHeight: 0,
          ),
          BlocBuilder<SpeedBloc, SpeedState>(
              buildWhen: (previous, current) => previous.speed != current.speed,
              builder: (context, state) {
                return Expanded(
                  child: TabBarView(
                    children: [
                      SpeedGauge(speed: state.speed),
                      SpeedDigital(speed: "${state.speed}"),
                      SpeedMap(
                        latitude: state.latitude,
                        longitude: state.longitude,
                      ),
                    ],
                  ),
                );
              }),
          BlocConsumer<SpeedBloc, SpeedState>(
            // buildWhen: (previous, current) =>
            //     previous.durationInMillicesonds !=
            //     current.durationInMillicesonds,
            listener: (context, state) async {},
            builder: (context, state) {
              print("durationInMillicesonds: ${state.durationInMillicesonds}");
              return Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 200,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ShowItem(
                          title: "Davomiyligi",
                          icon: Icons.timer_outlined,
                          value: MyFunctions.formatTime(
                              state.durationInMillicesonds),
                        ),
                        ShowItem(
                          title: "Masofa",
                          icon: Icons.route_outlined,
                          value:
                              "${(state.distance / 1000).toStringAsFixed(2)} km",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ShowItem(
                          title: "O'rt. tezlik",
                          icon: Icons.av_timer_sharp,
                          value:
                              "${state.averageSpeed} ${StorageRepository.getString(StoreKeys.scale, defValue: "km/h")}",
                        ),
                        ShowItem(
                          title: "Maks. tezlik",
                          icon: Icons.speed_outlined,
                          value:
                              "${state.maxSpeed} ${StorageRepository.getString(StoreKeys.scale, defValue: "km/h")}",
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          BlocBuilder<SpeedBloc, SpeedState>(
              buildWhen: (previous, current) =>
                  previous.isPaused != current.isPaused ||
                  previous.isPlaying != current.isPlaying,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 40),
                  child: AnimatedCrossFade(
                    firstChild: StartButton(onStart: () {
                      context.read<SpeedBloc>().add(StartSpeedEvent());
                    }),
                    secondChild: StopButton(
                      onReset: () {
                        context.read<SpeedBloc>().add(ResetSpeedEvent());
                      },
                      onStop: () {
                        context.read<SpeedBloc>().add(StopSpeedEvent());
                      },
                      onPause: () {
                        context.read<SpeedBloc>().add(PauseSpeedEvent());
                      },
                      onResume: () {
                        context.read<SpeedBloc>().add(ResumeSpeedEvent());
                      },
                      isPaused: state.isPaused,
                    ),
                    crossFadeState: state.isPlaying
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
