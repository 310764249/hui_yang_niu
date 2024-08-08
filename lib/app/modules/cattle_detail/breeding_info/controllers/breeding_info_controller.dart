import 'package:get/get.dart';
import 'package:common_utils/common_utils.dart';
import 'package:graphview/GraphView.dart' as GraphNode;

import '../../../../models/cattle.dart';
import '../../../../models/event_argument.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../widgets/toast.dart';

class BreedingInfoController extends GetxController {
  // 传入的牛只
  late Cattle cattle;
  // Cattle cattle = Get.arguments;
  HttpsClient httpsClient = HttpsClient();

  // 是否加载中, 在[页面初始化]时触发
  RxBool isLoading = true.obs;
  //是否有节点
  RxBool hasNode = false.obs;

  //性状统计数据模型
  CharactersArgument? model;

  final GraphNode.Graph graph = GraphNode.Graph()..isTree = true;
  GraphNode.BuchheimWalkerConfiguration builder =
      GraphNode.BuchheimWalkerConfiguration();

  //树形图结构 测试数据
  var json = {
    'nodes': [
      {'id': 1, 'label': 'DN0001', 'gender': 2, 'parent': 1},
      {'id': 2, 'label': 'DN0002', 'gender': 1, 'parent': 1},
      {'id': 3, 'label': 'DN0003', 'gender': 2, 'parent': 1},

      {'id': 4, 'label': 'DN0004', 'gender': 1, 'parent': 2},
      {'id': 5, 'label': 'DN0005', 'gender': 2, 'parent': 2},
      {'id': 6, 'label': 'DN0006', 'gender': 1, 'parent': 3},
      {'id': 7, 'label': 'DN0007', 'gender': 2, 'parent': 3},
      //{'id': 8, 'label': 'DN0008', 'gender': 1},
    ],
    'edges': [
      {'from': 1, 'to': 2},
      {'from': 1, 'to': 3},
      {'from': 2, 'to': 4},
      {'from': 2, 'to': 5},
      {'from': 3, 'to': 6},
      {'from': 3, 'to': 7},
      // {'from': 6, 'to': 8}
    ]
  };

  var myJson = [
    {'id': 1, 'label': 'DN0001', 'gender': 2, 'parent': 1},
    {'id': 2, 'label': 'DN0002', 'gender': 1, 'parent': 1},
    {'id': 3, 'label': 'DN0003', 'gender': 2, 'parent': 1},
    {'id': 4, 'label': 'DN0004', 'gender': 1, 'parent': 2},
    {'id': 5, 'label': 'DN0005', 'gender': 2, 'parent': 2},
    {'id': 6, 'label': 'DN0006', 'gender': 1, 'parent': 3},
    {'id': 7, 'label': 'DN0007', 'gender': 2, 'parent': 3},
  ];

  List jsonList = [];

  @override
  void onInit() {
    super.onInit();
    //请求性状统计
    getCharacters(cattle.code ?? '');
    //请求系谱图
    getProgenyList(cattle.code ?? '');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //初始化树图基本数据
  void initGraph() {
    List edges = [];
    var nodes = jsonList;
    if (nodes.isEmpty) {
      return;
    }

    for (Map element in nodes) {
      String code = element['code'];
      String? child = element['children'];
      if (child != null) {
        Map node = {
          'from': child,
          'to': code,
        };
        edges.add(node);
      }
    }

    edges.forEach((element) {
      var fromNodeId = element['from'];
      var toNodeId = element['to'];
      graph.addEdge(GraphNode.Node.Id(fromNodeId), GraphNode.Node.Id(toNodeId));
    });

    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (50)
      ..orientation =
          (GraphNode.BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT);
    //显示系谱图
    hasNode.value = true;
    update();
  }

  //请求性状统计
  Future<void> getCharacters(String code) async {
    try {
      var response = await httpsClient.get(
        "/api/characterstats/getbycode",
        queryParameters: {"code": code},
      );

      //print(response);
      model = CharactersArgument.fromJson(response);
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  //请求系谱图
  Future<void> getProgenyList(String code) async {
    try {
      var response = await httpsClient.get(
        "/api/progeny/getall",
        queryParameters: {"code": code},
      );
      print(response);
      //保存数组
      jsonList = response;
      //初始化树图
      initGraph();
    } catch (error) {
      Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }
}
