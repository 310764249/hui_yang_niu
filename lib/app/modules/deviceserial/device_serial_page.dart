import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'package:ezviz_flutter/widgets/ezviz_simple_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/device_serial_entity.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/AssetsImages.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:intellectual_breed/generated/assets.dart';

import '../../models/device_serial_details_entity.dart';
import '../../widgets/refresh_header_footer.dart';
import '../../widgets/single_select_wrap.dart';
import 'device_serial_player_page.dart';
import 'intelligent_ear_tag_view.dart';
import 'intelligent_monitoring_view.dart';

class DeviceSerialPage extends StatefulWidget {
  const DeviceSerialPage({super.key});

  @override
  State<DeviceSerialPage> createState() => _DeviceSerialPageState();
}

class _DeviceSerialPageState extends State<DeviceSerialPage> {
  PageController _pageController = PageController();
  ValueNotifier<int> _tabIndex = ValueNotifier(0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('智能监管'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: _tabIndex,
            builder: (context, value, child) {
              return SingleSelectWrap(
                items: const ['智能监控', "智能耳标"],
                initialIndex: value,
                onChanged: (value) {
                  _tabIndex.value = value;
                  _pageController.jumpToPage(value);
                },
              );
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [IntelligentMonitoringView(), IntelligentEarTagView()],
            ),
          ),
        ],
      ),
    );
  }
}
