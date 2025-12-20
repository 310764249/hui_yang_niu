import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'package:ezviz_flutter/widgets/ezviz_simple_player.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/device_serial_entity.dart';

import '../../models/device_serial_details_entity.dart';

class DeviceSerialPlayerPage extends StatefulWidget {
  const DeviceSerialPlayerPage({super.key, required this.detailsEntity});

  final DeviceSerialDetailsEntity detailsEntity;

  @override
  State<DeviceSerialPlayerPage> createState() => _DeviceSerialPlayerPageState();
}

class _DeviceSerialPlayerPageState extends State<DeviceSerialPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: EzvizSimplePlayer(
          deviceSerial: widget.detailsEntity.code,
          channelNo: 1,
          config: EzvizPlayerConfig(
            appKey: widget.detailsEntity.appKey,
            accessToken: widget.detailsEntity.token,
            region: EzvizRegion.china, // Optional: per-instance region
          ),
        ),
      ),
    );
  }
}
