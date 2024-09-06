import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/common_data.dart';
import 'package:intellectual_breed/app/models/cow_batch.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cattle_info.dart';
import '../../../../models/cow_house.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/common_service.dart';
import '../../../../services/constant.dart';
import '../../../../services/ex_rxstring.dart';
import '../../../../services/ex_string.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/storage.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class NewCattleController extends GetxController {
  HttpsClient httpsClient = HttpsClient();

  // 表单数据Data
  late CattleInfo cattleInfo;

  //输入框
  TextEditingController earNumController = TextEditingController();
  TextEditingController sourceFarmController = TextEditingController();
  TextEditingController fieldController = TextEditingController();
  TextEditingController calvingNumController = TextEditingController();
  TextEditingController cattleNumOfBatchController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  //
  final FocusNode earNumNode = FocusNode();
  final FocusNode sourceFarmNode = FocusNode();
  final FocusNode fieldNode = FocusNode();
  final FocusNode calvingNumNode = FocusNode();
  final FocusNode cattleNumOfBatchNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(earNumNode),
        KeyboardActionsHelper.getDefaultItem(sourceFarmNode),
        KeyboardActionsHelper.getDefaultItem(fieldNode),
        KeyboardActionsHelper.getDefaultItem(calvingNumNode),
        KeyboardActionsHelper.getDefaultItem(cattleNumOfBatchNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  // 临时记录品种和胎次的position
  // RxInt tempGenderPosition = 0.obs;
  RxInt tempBreedPosition = 0.obs;
  RxInt tempPregnancyNumPosition = 0.obs;

  // 初始化请求参数
  void initRequestParams(int position) {
    // 重新初始化API参数类
    cattleInfo = CattleInfo.empty();

    // 清空所有的输入框内容
    earNumController.clear();
    sourceFarmController.clear();
    fieldController.clear();
    calvingNumController.clear();
    cattleNumOfBatchController.clear();
    remarkController.clear();

    // 3.更新当前状态数据
    cattleInfo.currentStage = Constant.currentStageList[position].id;

    // 设置[品种]和[胎次]为默认值
    // cattleInfo.gender?.value =
    // Constant.genderNameList[tempGenderPosition.value] == '公牛' ? 1 : 2;
    cattleInfo.breed?.value = breedList[tempBreedPosition.value]['value'];
    cattleInfo.pregnancyNum?.value = Constant.pregnancyNumList[tempPregnancyNumPosition.value];

    // 防止前面犊牛api没请求到数据的话这里再去请求一次
    if (cattleInfo.currentStage == 1 && tempBatchNumAuto1.value.isBlankEx()) {
      debugPrint('-- 自动批次号1为空');
      requestBatchNumber(1);
    }

    // 防止前面育肥牛api没请求到数据的话这里再去请求一次
    if (cattleInfo.currentStage == 2 && tempBatchNumAuto2.value.isBlankEx()) {
      debugPrint('-- 自动批次号2为空');
      requestBatchNumber(2);
    }
  }

  // "品种"可选项
  List breedList = [];
  List<String> breedNameList = [];

  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];

  @override
  void onInit() async {
    super.onInit();

    // 初始化请求参数
    cattleInfo = CattleInfo.init();
    cattleInfo.currentStage = Constant.currentStageList.first.id;
    // 初始化请求生成犊牛的批次号
    requestBatchNumber(1);

    // 品种列表
    breedList = AppDictList.searchItems('pz') ?? [];
    breedNameList = List<String>.from(breedList.map((item) => item['label']).toList());

    // 栋舍列表
    houseList = await CommonService().requestCowHouse();
    // 获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

    // 初始化赋值一些变量
    cattleInfo.gender = 1.obs;
    cattleInfo.currentStage = Constant.currentStageList[0].id;
    cattleInfo.breed?.value = breedList[0]['value'];
    cattleInfo.pregnancyNum?.value = Constant.pregnancyNumList[0];

    // 监听各个选择值的变化
    ever(cattleInfo.inDate.orEmpty(), (newValue) {});
    ever(cattleInfo.gender ?? 1.obs, (newValue) {});
    ever(cattleInfo.batchNum.orEmpty(), (newValue) {});
    ever(cattleInfo.sourceFarm.orEmpty(), (newValue) {});
    ever(cattleInfo.birthDate.orEmpty(), (newValue) {});
    ever(cattleInfo.breed ?? '1'.obs, (newValue) {});
    ever(cattleInfo.pregnancyNum ?? '0'.obs, (newValue) {});
    ever(cattleInfo.matingTime.orEmpty(), (newValue) {});
    ever(cattleInfo.pregnancyCheckTime.orEmpty(), (newValue) {});
    ever(cattleInfo.calvingTime.orEmpty(), (newValue) {});
    ever(cattleInfo.weaningTime.orEmpty(), (newValue) {});
    ever(cattleInfo.emptyDate.orEmpty(), (newValue) {});
    ever(cattleInfo.breedingCowEstrusTime.orEmpty(), (newValue) {});
    ever(cattleInfo.shedId.orEmpty(), (newValue) {});
    ever(cattleInfo.shed.orEmpty(), (newValue) {});
    ever(cattleInfo.field.orEmpty(), (newValue) {});
    ever(cattleInfo.operationDate.orEmpty(), (newValue) {});

    fieldNode.addListener(() {
      if (!fieldNode.hasFocus) {
        // 当焦点失去时执行的逻辑
        cattleInfo.field?.value = fieldController.text;
      }
    });
    sourceFarmNode.addListener(() {
      if (!sourceFarmNode.hasFocus) {
        // 当焦点失去时执行的逻辑c
        cattleInfo.sourceFarm?.value = sourceFarmController.text;
      }
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      // 1.更新当前状态显示
      updateCurrentStage(0);

      // 2.每次切换都需要把提交的数据初始化一遍, 防止数据字段相互串用
      initRequestParams(0);

      // 3.更新[胎次]
      updatePregnancyNum();
    });
  }

  // 更新胎次逻辑, 在切换[当前状态]和[性别]的时候校验一遍
  void updatePregnancyNum() {
    switch (cattleInfo.currentStage) {
      case 1 || 2 || 3 || 4:
        if (cattleInfo.currentStage == 3) {
          if (Constant.currentStageList[selStage.value].name == '后备母牛') {
            cattleInfo.gender?.value = 2;
          } else {
            cattleInfo.gender?.value = 2;
          }
        }
        //* 前面4中如果是公牛的话就设置[胎次]为空, 母牛根据具体情况设置
        if (cattleInfo.gender?.value == 1) {
          //* 公牛胎次设置为空
          cattleInfo.pregnancyNum?.value = '';
        } else if (cattleInfo.gender?.value == 2) {
          //* 后备母牛胎次为0
          if (cattleInfo.currentStage == 3) {
            cattleInfo.pregnancyNum?.value = '0';
          }
          //* 公牛胎次设置为空
          if (cattleInfo.currentStage == 4) {
            cattleInfo.pregnancyNum?.value = Constant.pregnancyNumList[tempPregnancyNumPosition.value];
          }
        }
        break;
      case 5 || 6 || 7:
        //* 如果是 妊娠母牛 & 哺乳母牛 & 空怀母牛 的话直接把性别设置成2
        cattleInfo.gender?.value = 2;
        break;
      case 8:
      case 9:
        //后背公牛|种公牛 公牛胎次设置为空
        cattleInfo.pregnancyNum?.value = Constant.pregnancyNumList[tempPregnancyNumPosition.value];
        break;
      case 10:
        //后背母牛 后备母牛胎次为0
        cattleInfo.pregnancyNum?.value = '0';
        break;
      default:
        Toast.show('设置胎次异常');
        break;
    }
  }

  // 临时的[自动批次号], 防止cattleInfo切换状态被释放
  RxString tempBatchNumAuto1 = ''.obs; // 犊牛
  RxString tempBatchNumAuto2 = ''.obs; // 育肥牛

  // 请求生成批次号
  void requestBatchNumber(int type) async {
    Toast.showLoading();
    String number = await CommonService().requestNewBatchNumber(type);
    switch (type) {
      case 1:
        tempBatchNumAuto1.value = ObjectUtil.isEmpty(number) ? '' : number;
        break;
      case 2:
        tempBatchNumAuto2.value = ObjectUtil.isEmpty(number) ? '' : number;
        break;
      default:
    }
    Toast.dismiss();
    update();
  }

  // 更新"栋舍"选中项
  void updateCurCowHouse(String cowHouse, int position) {
    cattleInfo.shedId?.value = houseList[position].id;
    cattleInfo.shed?.value = cowHouse;
    update();
  }

  // "当前状态"选中项: 默认第一项
  final selStage = 0.obs;

  // 更新"当前状态"选中项
  void updateCurrentStage(int index) {
    selStage.value = index;
    update();
  }

  // 如果页面初始化批次号获取失败的话, 需要再次点击生成[批次号(自动生成)]
  void retrieveBatchNumAutoIfNeeded() {
    // 防止前面犊牛api没请求到数据的话这里再去请求一次
    if (cattleInfo.currentStage == 1 && tempBatchNumAuto1.value.isBlankEx()) {
      debugPrint('-- 自动批次号1为空');
      requestBatchNumber(1);
    }

    // 防止前面育肥牛api没请求到数据的话这里再去请求一次
    if (cattleInfo.currentStage == 2 && tempBatchNumAuto2.value.isBlankEx()) {
      debugPrint('-- 自动批次号2为空');
      requestBatchNumber(2);
    }
  }

  // 获取胎次
  // 1.后备公牛和种公牛为空
  // 2.后备母牛为0
  // 3.种母牛和其他状态的都是根据选择的值
  int? getPregnancyNum() {
    switch (cattleInfo.currentStage) {
      case 3:
        if (cattleInfo.gender?.value == 1) {
          return null;
        } else {
          return 0;
        }
      case 4:
        if (cattleInfo.gender?.value == 1) {
          return null;
        } else {
          return int.parse(cattleInfo.pregnancyNum?.value.isNotBlank() ?? false ? cattleInfo.pregnancyNum?.value ?? '0' : '0');
        }
      default:
        return int.parse(cattleInfo.pregnancyNum?.value.isNotBlank() ?? false ? cattleInfo.pregnancyNum?.value ?? '0' : '0');
    }
  }

  // 选择批次后带出牛只信息
  void updateCattleData(CowBatch batchCattle) {
    debugPrint('----- 批次牛信息: ${batchCattle.toString()}');
    // 耳号
    cattleInfo.batchNum?.value = batchCattle.batchNo.orEmpty();
    // 来源场
    cattleInfo.sourceFarm?.value = batchCattle.sourceFarm.orEmpty();
    sourceFarmController.text = batchCattle.sourceFarm.orEmpty();
    // 入场时间
    cattleInfo.inDate?.value = batchCattle.inArea.orEmpty();
    // 出生时间
    cattleInfo.birthDate?.value = batchCattle.birth.orEmpty();
    // 公母
    cattleInfo.gender?.value = batchCattle.gender;
    // tempGenderPosition.value = batchCattle.gender == 1 ? 0 : 1; // 设置性别
    // 品种
    cattleInfo.breed?.value = batchCattle.kind.toString();
    tempBreedPosition.value = batchCattle.kind - 1; // 设置品种
    // 栋舍和栋舍id
    cattleInfo.shedId?.value = batchCattle.cowHouseId;
    cattleInfo.shed?.value = batchCattle.cowHouseName.orEmpty();
    // 栏位
    cattleInfo.field?.value = batchCattle.column.orEmpty();
    fieldController.text = batchCattle.column.orEmpty();

    // 批次选完之后设置胎次
    if (batchCattle.gender == 2) {
      switch (cattleInfo.currentStage) {
        case 3:
          //* 后备母牛的[胎次]直接为0, 且页面上无法进行选择, 其他的种类的[胎次]都可以在页面上进行选择
          cattleInfo.pregnancyNum?.value = '0';
          break;
        default:
          //* [种牛, 妊娠母牛, 哺乳母牛, 空怀母牛这些]的[胎次]都可以在页面上进行选择, 所以先判空, 如果无值的话则赋值, 有值则跳过
          if (ObjectUtil.isEmpty(cattleInfo.pregnancyNum?.value)) {
            debugPrint('--- 其他牛只类型胎次为空, 设置为0');
            cattleInfo.pregnancyNum?.value = '0';
          } else {
            debugPrint('--- 其他牛只类型胎次不为空, 跳过设置');
          }
          break;
      }
    }

    update();
  }

  /// 提交表单数据
  Future<void> commitNewCattleData() async {
    debugPrint('提交参数: ${cattleInfo.toString()}');

    // 判断是否登录拿到缓存数据
    var res = await Storage.getData(Constant.selectFarmData);
    if (res == null) {
      Toast.failure(msg: "请先登录获取资源信息");
      return;
    }

    //种够牛，备用公母母牛批次号非必填
    if (cattleInfo.currentStage == 8 || cattleInfo.currentStage == 9 || cattleInfo.currentStage == 10) {
    } else {
      // 单独判断犊牛和育肥牛的批次号是否获取成功
      if (cattleInfo.currentStage == 1 && tempBatchNumAuto1.value.isBlankEx()) {
        Toast.show('批次号生成失败, 请点击批次号重新生成');
        return;
      }
      if (cattleInfo.currentStage == 2 && tempBatchNumAuto2.value.isBlankEx()) {
        Toast.show('批次号生成失败, 请点击批次号重新生成');
        return;
      }
    }

    // 校验参数, 如果校验失败, 则Toast输出错误信息
    var paramCheckedResult = CattleInfo.checkRequestParam(cattleInfo);
    if (!paramCheckedResult[0]) {
      Toast.show(paramCheckedResult[1]);
      return;
    }

    try {
      String farmId = res['id'];

      Toast.showLoading(msg: "提交中...");

      //接口参数
      Map<String, dynamic> mapParam;
      if (cattleInfo.currentStage == 1 || cattleInfo.currentStage == 2) {
        // 犊牛 & 育肥牛
        mapParam = {
          "farmId": farmId.trim(),
          "cowHouseId": cattleInfo.shedId?.value.trim(), // 栋舍ID
          "sourceFarm": cattleInfo.sourceFarm?.value.trim(), // 来源场
          "type": cattleInfo.currentStage, // 生长阶段
          "gender": cattleInfo.gender?.value, // 性别
          "batchNo":
              cattleInfo.currentStage == 1 ? tempBatchNumAuto1.value.trim() : tempBatchNumAuto2.value.trim(), // 自动批次号, 区分犊牛和育肥牛
          "birth": cattleInfo.birthDate?.value.trim(), // 出生日期
          "kind": int.parse(cattleInfo.breed?.trim() ?? '1'), // 品种
          "inArea": cattleInfo.inDate?.value.trim(), // 入场时间
          "date": cattleInfo.operationDate?.value.trim(),
          "count": int.parse(cattleInfo.cattleNumOfBatch?.trim() ?? '0'),
          // "executor": "string", // 操作员
          "remark": cattleInfo.remark?.trim(), // 备注
        };
        await httpsClient.post("/api/cowBatch", data: mapParam);
      } else {
        // 后备牛 & 种牛 & 妊娠母牛 & 哺乳母牛 & 空怀母牛
        mapParam = {
          "farmId": farmId.trim(),
          "sourceFarm": cattleInfo.sourceFarm?.value.trim(), // 来源场
          "cowHouseId": cattleInfo.shedId?.value.trim(), // 栋舍ID
          "code": cattleInfo.earNum?.trim(), // 耳号
          // "eleCode": "", // 电子耳号
          "batchNo": cattleInfo.batchNum?.value.trim(), // 批次号
          "birth": cattleInfo.birthDate?.value.trim(), // 出生日期
          "column": cattleInfo.field?.value.trim(), // 栏位
          "gender": cattleInfo.gender?.value, // 性别
          "growthStage": cattleInfo.currentStage, // 生长阶段
          "kind": int.parse(cattleInfo.breed?.trim() ?? '0'), // 品种
          "calvNum": getPregnancyNum(), // 胎次
          "batchCount": cattleInfo.currentStage == 6 ? int.parse(cattleInfo.calvingNum!) : null, // 上一次产犊数量
          "inArea": cattleInfo.inDate?.value.trim(), // 入场时间
          "operationDate": cattleInfo.operationDate?.value.trim(),
          "remark": cattleInfo.remark?.trim(), // 备注
        };
        debugPrint('提交参数: $mapParam');
        await httpsClient.post("/api/cow", data: mapParam);
      }

      Toast.dismiss();
      Toast.success(msg: '提交成功');
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (error) {
      Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        debugPrint('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        debugPrint('Other Exception: $error');
      }
    }
  }
}
//CattleInfo(currentStage: 5, earNum: 411, batchNum: , sourceFarm: , inDate: , gender: 2, cattleNumOfBatch: , birthDate: 2024-09-05, breed: 1, pregnancyNum: 0, shedId: 6acda895-6217-4f30-b39d-d402fb4213ee, shed: 1号舍, field: , matingTime: , pregnancyCheckTime: , calvingTime: , calvingNum: , calfBatch: , weaningTime: , emptyDate: , breedingCowEstrusTime: , remark: )
// CattleInfo(currentStage: 6, earNum: 11, batchNum: , sourceFarm: , inDate: , gender: 2, cattleNumOfBatch: , birthDate: 2024-09-05, breed: 1, pregnancyNum: 0, shedId: 6acda895-6217-4f30-b39d-d402fb4213ee, shed: 1号舍, field: , matingTime: , pregnancyCheckTime: , calvingTime: , calvingNum: , calfBatch: , weaningTime: , emptyDate: , breedingCowEstrusTime: , remark: )
