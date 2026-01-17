import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'package:ezviz_flutter/widgets/ezviz_simple_player.dart';

import '../../models/device_serial_details_entity.dart';

class DeviceSerialPlayerPage extends StatefulWidget {
  const DeviceSerialPlayerPage({super.key, required this.detailsEntity});

  final DeviceSerialDetailsEntity detailsEntity;

  @override
  State<DeviceSerialPlayerPage> createState() => _DeviceSerialPlayerPageState();
}

class _DeviceSerialPlayerPageState extends State<DeviceSerialPlayerPage> {
  final EzvizManager _manager = EzvizManager.shared();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 其他页面内容，比如播放器
            Align(
              alignment: Alignment.center,
              child: EzvizSimplePlayer(
                deviceSerial: widget.detailsEntity.code,
                channelNo: 1,
                config: EzvizPlayerConfig(
                  appKey: widget.detailsEntity.appKey,
                  accessToken: widget.detailsEntity.token,
                  region: EzvizRegion.china,
                  showControls: true,
                  compactControls: false,
                  enableDoubleTapSeek: false,
                  enableSwipeSeek: false,
                  autoPlay: true,
                  enableAudio: true,
                  allowFullscreen: true,
                  autoRotate: true,
                ),
              ),
            ),

            // PTZ 控制器
            LayoutBuilder(
              builder: (context, constraints) {
                final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

                return Stack(
                  children: [
                    Positioned(
                      left: isPortrait ? (constraints.maxWidth - 180) / 2 : null,
                      right: isPortrait ? null : 20,
                      bottom: isPortrait ? 30 : (constraints.maxHeight - 180) / 2,
                      child: EzvizPTZControllerWidget(
                        deviceSerial: widget.detailsEntity.code,
                        cameraId: 1,
                        size: 180,
                        backgroundColor: Colors.black26,
                        activeColor: Colors.blue,
                        arrowColor: Colors.white,
                        speed: 1,
                        onCenterTap: () {
                          _resetCamera();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _resetCamera() async {
    final speed = 1; // 可调整
    final deviceSerial = widget.detailsEntity.code;
    final cameraId = 1;

    // 向上移动 1 秒
    EzvizManager.shared().controlPTZ(
      deviceSerial,
      cameraId,
      EzvizPtzCommands.Up,
      EzvizPtzActions.Start,
      speed,
    );
    await Future.delayed(Duration(milliseconds: 1000));
    EzvizManager.shared().controlPTZ(
      deviceSerial,
      cameraId,
      EzvizPtzCommands.Up,
      EzvizPtzActions.Stop,
      speed,
    );

    // 向左移动 1 秒
    EzvizManager.shared().controlPTZ(
      deviceSerial,
      cameraId,
      EzvizPtzCommands.Left,
      EzvizPtzActions.Start,
      speed,
    );
    await Future.delayed(Duration(milliseconds: 1000));
    EzvizManager.shared().controlPTZ(
      deviceSerial,
      cameraId,
      EzvizPtzCommands.Left,
      EzvizPtzActions.Stop,
      speed,
    );
  }
}

typedef PTZCallback = void Function();

class EzvizPTZControllerWidget extends StatefulWidget {
  final String deviceSerial;
  final int cameraId;
  final double size;
  final Color backgroundColor;
  final Color activeColor;
  final Color arrowColor;
  final int speed;

  /// 点击中心复位时回调
  final PTZCallback? onCenterTap;

  const EzvizPTZControllerWidget({
    super.key,
    required this.deviceSerial,
    this.cameraId = 1,
    this.size = 200,
    this.backgroundColor = Colors.black26,
    this.activeColor = Colors.blue,
    this.arrowColor = Colors.white,
    this.speed = 1,
    this.onCenterTap,
  });

  @override
  State<EzvizPTZControllerWidget> createState() => _EzvizPTZControllerWidgetState();
}

class _EzvizPTZControllerWidgetState extends State<EzvizPTZControllerWidget> {
  String? _activeDirection;
  Timer? _ptzTimer;

  double get outerRadius => widget.size / 2;
  double get innerRadius => widget.size / 6;

  @override
  void dispose() {
    _stopPTZ();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 圆环触控
          GestureDetector(
            onPanStart: (d) => _onTouch(d.localPosition),
            onPanUpdate: (d) => _onTouch(d.localPosition),
            onPanEnd: (_) => _stopPTZ(),
            onPanCancel: _stopPTZ,
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _PTZPainter(
                outerRadius: outerRadius,
                innerRadius: innerRadius,
                backgroundColor: widget.backgroundColor,
                activeColor: widget.activeColor,
                activeDirection: _activeDirection,
              ),
            ),
          ),
          // 中心复位按钮
          GestureDetector(
            onTap: () {
              _stopPTZ();
              widget.onCenterTap?.call();
            },
            child: Container(
              width: innerRadius * 2,
              height: innerRadius * 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(color: widget.arrowColor, width: 2),
              ),
              child: Icon(Icons.center_focus_strong, color: widget.arrowColor, size: innerRadius),
            ),
          ),
          // 四个箭头图标
          ..._buildArrows(),
        ],
      ),
    );
  }

  List<Widget> _buildArrows() {
    final directions = ['UP', 'RIGHT', 'DOWN', 'LEFT'];
    final icons = [
      Icons.keyboard_arrow_up,
      Icons.keyboard_arrow_right,
      Icons.keyboard_arrow_down,
      Icons.keyboard_arrow_left,
    ];
    final positions = [
      Offset(0, -outerRadius + 20),
      Offset(outerRadius - 20, 0),
      Offset(0, outerRadius - 20),
      Offset(-outerRadius + 20, 0),
    ];

    List<Widget> arrows = [];
    for (int i = 0; i < directions.length; i++) {
      arrows.add(
        Positioned(
          left: outerRadius + positions[i].dx - 15,
          top: outerRadius + positions[i].dy - 15,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) {
              _stopPTZ();
              _startPTZ(directions[i]);
            },
            onTapUp: (_) => _stopPTZ(),
            onTapCancel: _stopPTZ,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color:
                    _activeDirection == directions[i]
                        ? widget.activeColor
                        : Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icons[i],
                color: _activeDirection == directions[i] ? Colors.white : widget.arrowColor,
                size: 18,
              ),
            ),
          ),
        ),
      );
    }
    return arrows;
  }

  void _onTouch(Offset pos) {
    final center = Offset(outerRadius, outerRadius);
    final distance = (pos - center).distance;

    if (distance > innerRadius && distance <= outerRadius) {
      final dir = _getDirection(pos, center);
      if (dir != _activeDirection) {
        _stopPTZ();
        _startPTZ(dir);
      }
    } else {
      _stopPTZ();
    }
  }

  String _getDirection(Offset pos, Offset center) {
    final angle = math.atan2(pos.dy - center.dy, pos.dx - center.dx);
    final deg = (angle * 180 / math.pi + 360) % 360;
    if (deg >= 315 || deg < 45) return 'RIGHT';
    if (deg >= 45 && deg < 135) return 'DOWN';
    if (deg >= 135 && deg < 225) return 'LEFT';
    return 'UP';
  }

  void _startPTZ(String direction) {
    _activeDirection = direction;
    setState(() {});

    // 立即发一次Start
    EzvizManager.shared().controlPTZ(
      widget.deviceSerial,
      widget.cameraId,
      _mapDirection(direction),
      'EZPTZAction_START',
      widget.speed,
    );

    // 定时持续发送
    _ptzTimer = Timer.periodic(Duration(milliseconds: 250), (_) {
      EzvizManager.shared().controlPTZ(
        widget.deviceSerial,
        widget.cameraId,
        _mapDirection(direction),
        'EZPTZAction_START',
        widget.speed,
      );
    });
  }

  void _stopPTZ() {
    if (_activeDirection != null) {
      EzvizManager.shared().controlPTZ(
        widget.deviceSerial,
        widget.cameraId,
        _mapDirection(_activeDirection!),
        'EZPTZAction_STOP',
        widget.speed,
      );
      _ptzTimer?.cancel();
      _ptzTimer = null;
      _activeDirection = null;
      setState(() {});
    }
  }

  String _mapDirection(String dir) {
    switch (dir) {
      case 'UP':
        return 'EZPTZCommand_Up';
      case 'DOWN':
        return 'EZPTZCommand_Down';
      case 'LEFT':
        return 'EZPTZCommand_Left';
      case 'RIGHT':
        return 'EZPTZCommand_Right';
      default:
        return 'EZPTZCommand_Up';
    }
  }
}

/// 绘制圆环和高亮方向
class _PTZPainter extends CustomPainter {
  final double outerRadius;
  final double innerRadius;
  final Color backgroundColor;
  final Color activeColor;
  final String? activeDirection;

  _PTZPainter({
    required this.outerRadius,
    required this.innerRadius,
    required this.backgroundColor,
    required this.activeColor,
    this.activeDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // 背景圆环
    paint.color = backgroundColor;
    canvas.drawCircle(center, outerRadius, paint);

    // 外边框
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, outerRadius, paint);

    // 内圆透明
    paint
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, paint);

    // 高亮方向
    if (activeDirection != null) {
      paint
        ..color = activeColor.withOpacity(0.6)
        ..style = PaintingStyle.fill;
      final angle = _angleForDir(activeDirection!);
      const sectionAngle = math.pi / 2;
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: outerRadius),
        angle - sectionAngle / 2,
        sectionAngle,
        false,
      );
      path.close();

      final innerPath = Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius));
      final finalPath = Path.combine(PathOperation.difference, path, innerPath);
      canvas.drawPath(finalPath, paint);
    }
  }

  double _angleForDir(String dir) {
    switch (dir) {
      case 'UP':
        return -math.pi / 2;
      case 'RIGHT':
        return 0;
      case 'DOWN':
        return math.pi / 2;
      case 'LEFT':
        return math.pi;
      default:
        return 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
