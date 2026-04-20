import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/device_serial_details_entity.dart';
import '../../models/device_serial_entity.dart';
import '../../network/apiException.dart';
import '../../network/httpsClient.dart';
import '../../services/AssetsImages.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/refresh_header_footer.dart';
import '../../widgets/toast.dart';
import 'device_serial_player_page.dart';

class IntelligentMonitoringView extends StatefulWidget {
  const IntelligentMonitoringView({super.key});

  @override
  State<IntelligentMonitoringView> createState() => _IntelligentMonitoringViewState();
}

class _IntelligentMonitoringViewState extends State<IntelligentMonitoringView>
    with AutomaticKeepAliveClientMixin {
  HttpsClient httpsClient = HttpsClient();
  List<DeviceSerialEntity> deviceSerial = [];

  @override
  void initState() {
    super.initState();
    getDeviceSerial();
  }

  Future getDeviceSerial() async {
    String api = '/api/deviceserial';
    var response = await httpsClient.get(api);
    setState(() {
      deviceSerial.clear();
      for (var item in response) {
        DeviceSerialEntity model = DeviceSerialEntity.fromJson(item);
        deviceSerial.add(model);
      }
    });
  }

  getPlayData(DeviceSerialEntity serial) async {
    Toast.showLoading();
    String api = '/api/deviceserial/getaddress';
    try {
      var response = await httpsClient.get(
        api,
        queryParameters: {'code': serial.code, 'channelNo': serial.channelNo},
      );
      Toast.dismiss();
      DeviceSerialDetailsEntity details = DeviceSerialDetailsEntity.fromJson(response);

      Get.to(() => DeviceSerialPlayerPage(detailsEntity: details, channelNo: serial.channelNo));
    } catch (e) {
      Toast.dismiss();
      if (e is ApiException) {
        Toast.show(e.message);
        return;
      }
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      // 指定刷新时的头部组件
      header: CustomRefresh.refreshHeader(),
      onRefresh: () async {
        await getDeviceSerial();
      },

      child:
          deviceSerial.isEmpty
              ? const CustomScrollView(slivers: [SliverFillRemaining(child: EmptyView())])
              : ListView.builder(
                itemCount: deviceSerial.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (_, index) {
                  final item = deviceSerial[index];
                  return DevicePreviewCard(
                    key: ValueKey(index),
                    item: item,
                    onPlay: (value) {
                      getPlayData(value);
                    },
                  );
                },
              ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DevicePreviewCard extends StatelessWidget {
  final DeviceSerialEntity item;
  final void Function(DeviceSerialEntity item) onPlay;

  const DevicePreviewCard({super.key, required this.item, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPlay(item),
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 假装画面，先用渐变底色替代
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsImages.appLogoPng),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 中间三角播放按钮
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ).copyWith(bottom: 50),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.45), Colors.black.withOpacity(0.0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(
                  '摄像头编号：${item.code}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            // 下面信息栏
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10).copyWith(top: 50),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.45), Colors.black.withOpacity(0.0)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    // 状态点
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: item.status == 1 ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.stateName,
                      style: TextStyle(
                        fontSize: 12,
                        color: item.status == 1 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
