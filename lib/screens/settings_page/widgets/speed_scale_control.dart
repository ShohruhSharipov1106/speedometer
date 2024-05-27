import 'package:flutter/material.dart';
import 'package:speedometer/config/storage.dart';

class SpeedScaleControl extends StatefulWidget {
  const SpeedScaleControl({super.key});

  @override
  State<SpeedScaleControl> createState() => _SpeedScaleControlState();
}

class _SpeedScaleControlState extends State<SpeedScaleControl>
    with SingleTickerProviderStateMixin {
  late String scale;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    scale = StorageRepository.getString(StoreKeys.scale, defValue: "km/h");

    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: scale == "km/h"
          ? 0
          : scale == "mph"
              ? 1
              : 2,
    );
    print("scale --> $scale");
    print("tabController.index --> ${tabController.index}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tezlik o'lchovi",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 10),
          TabBar(
            controller: tabController,
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            onTap: (value) {
              print("value --> $value ${value == 1}");
              if (value == 0) {
                StorageRepository.putString(StoreKeys.scale, "km/h");
              } else if (value == 1) {
                StorageRepository.putString(StoreKeys.scale, "mph");
              } else {
                StorageRepository.putString(StoreKeys.scale, "knot");
              }
            },
            tabs: [
              Tab(child: Text("km/h")),
              Tab(child: Text("mph")),
              Tab(child: Text("knot")),
            ],
          ),
        ],
      ),
    );
  }
}
