import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/ex_string.dart';
import '../services/ex_rxstring.dart';
import '../services/Log.dart';
import '../services/ex_bool.dart';

class CattleInfo {
  /// 当前状态:
  /// 1：犊牛；2：育肥牛；3：后备牛；4：种牛；5：妊娠母牛；6：哺乳母牛；7：空怀母牛；8：已淘汰；9：已销售；10：已死亡；
  late int? currentStage = 1;

  /// 耳号
  late String? earNum = '';

  /// 批次号
  late RxString? batchNum = RxString('');

  /// 来源场
  late RxString? sourceFarm = RxString('');

  /// 入场时间
  late RxString? inDate = RxString('');

  /// 性别: 1:公，2:母
  late RxInt? gender = 1.obs;

  /// 批次号下牛犊数量
  late String? cattleNumOfBatch = '';

  /// 出生日期
  late RxString? birthDate = RxString('');

  /// 品种
  late RxString? breed = RxString('');

  /// 胎次
  late RxString? pregnancyNum = RxString('');

  /// 栋舍Id
  late RxString? shedId = RxString('');

  /// 栋舍
  late RxString? shed = RxString('');

  /// 栏位
  late RxString? field = RxString('');

  /// 配种时间
  late RxString? matingTime = RxString('');

  /// 孕检时间
  late RxString? pregnancyCheckTime = RxString('');

  /// 产犊时间
  late RxString? calvingTime = RxString('');

  /// 产犊数量
  late String? calvingNum = '';

  /// 犊牛批次
  late String? calfBatch = '';

  /// 断奶时间
  late RxString? weaningTime = RxString('');

  /// 空怀日期
  late RxString? emptyDate = RxString('');

  /// 种牛-母: 发情时间
  late RxString? breedingCowEstrusTime = RxString('');

  /// 种牛-公: 配种时间
  // late RxString? breedingBullMatingDate = RxString('');

  /// 操作日期
  late RxString? operationDate = RxString('');

  /// 备注
  late String? remark = '';

  CattleInfo({
    this.currentStage,
    this.earNum,
    this.batchNum,
    this.sourceFarm,
    this.inDate,
    this.gender,
    this.cattleNumOfBatch,
    this.birthDate,
    this.breed,
    this.pregnancyNum,
    this.shedId,
    this.shed,
    this.field,
    this.matingTime,
    this.pregnancyCheckTime,
    this.calvingTime,
    this.calvingNum,
    this.calfBatch,
    this.weaningTime,
    this.emptyDate,
    this.breedingCowEstrusTime,
    this.operationDate,
    this.remark,
  });

  /// 设置初始化数据, 在页面初始化的时候用到
  CattleInfo.init() {
    currentStage = 1;
    earNum = '';
    batchNum = ''.obs;
    sourceFarm = ''.obs;
    inDate = ''.obs;
    gender?.value = 1;
    cattleNumOfBatch = '';
    birthDate = ''.obs;
    // breed = '1'.obs;
    breed = '1'.obs;
    pregnancyNum = '0'.obs;
    shedId = ''.obs;
    shed = ''.obs;
    field = ''.obs;
    matingTime = ''.obs;
    pregnancyCheckTime = ''.obs;
    calvingTime = ''.obs;
    calvingNum = '';
    calfBatch = '';
    weaningTime = ''.obs;
    emptyDate = ''.obs;
    breedingCowEstrusTime = ''.obs;
    operationDate = ''.obs;
    remark = '';
  }

  /// 设置参数为空, 在切换[品种]的时候用到
  CattleInfo.empty() {
    // currentStage = 1;
    earNum = '';
    batchNum = ''.obs;
    sourceFarm = ''.obs;
    inDate = ''.obs;
    // gender?.value = 1;
    cattleNumOfBatch = '';
    birthDate = ''.obs;
    breed = '1'.obs;
    pregnancyNum = '1'.obs;
    shedId = ''.obs;
    shed = ''.obs;
    field = ''.obs;
    matingTime = ''.obs;
    pregnancyCheckTime = ''.obs;
    calvingTime = ''.obs;
    calvingNum = '';
    calfBatch = '';
    weaningTime = ''.obs;
    emptyDate = ''.obs;
    breedingCowEstrusTime = ''.obs;
    operationDate = ''.obs;
    remark = '';
  }

  @override
  String toString() {
    return 'CattleInfo(currentStage: $currentStage, earNum: $earNum, batchNum: $batchNum, sourceFarm: $sourceFarm, inDate: $inDate, gender: $gender, cattleNumOfBatch: $cattleNumOfBatch, birthDate: $birthDate, breed: $breed, pregnancyNum: $pregnancyNum, shedId: $shedId, shed: $shed, field: $field, matingTime: $matingTime, pregnancyCheckTime: $pregnancyCheckTime, calvingTime: $calvingTime, calvingNum: $calvingNum, calfBatch: $calfBatch, weaningTime: $weaningTime, emptyDate: $emptyDate, breedingCowEstrusTime: $breedingCowEstrusTime, remark: $remark)';
  }

  // 必填项校验
  static List<dynamic> checkRequestParam(CattleInfo info) {
    Log.e('校验info: $info');
    debugPrint('-- currentStage -- ${info.currentStage}');
    // 犊牛
    switch (info.currentStage) {
      case 1 || 2:
        // 犊牛 & 育肥牛
        debugPrint('------犊牛 & 育肥牛------');
        debugPrint(
            '${(info.gender?.value == 1 || info.gender?.value == 2)} - gender -');
        debugPrint(
            '${info.cattleNumOfBatch.isNotBlank().orFalse()} - cattleNumOfBatch - ');
        debugPrint(
            '${info.birthDate.isRxStringNotBlank().orFalse()} - birthDate - ');
        debugPrint('${info.breed.isRxStringNotBlank().orFalse()} - breed - ');
        debugPrint('${info.shedId.isRxStringNotBlank().orFalse()} - shedId - ');
        debugPrint(
            '${info.operationDate.isRxStringNotBlank().orFalse()} - operationDate -');

        bool b1 = (info.gender?.value == 1 || info.gender?.value == 2);
        bool b2 = info.cattleNumOfBatch.isNotBlank().orFalse();
        bool b3 = info.birthDate.isRxStringNotBlank().orFalse();
        bool b4 = info.breed.isRxStringNotBlank().orFalse();
        bool b5 = info.shedId.isRxStringNotBlank().orFalse();
        bool b6 = info.operationDate.isRxStringNotBlank().orFalse();

        bool b7 = false;
        // 日期顺序判断
        if (info.currentStage == 1) {
          if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于犊牛的日期判断
            b7 = info.birthDate?.value
                    .isBeforeOrAtSame(info.operationDate?.value) ??
                false;
          }
        } else {
          if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isNotEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 有输入[入场时间]
            b7 = (info.inDate?.value
                        .isBeforeOrAtSame(info.operationDate?.value) ??
                    false) &&
                ((info.inDate?.value.isNotEmpty ?? false) &&
                    (info.birthDate?.value
                            .isBeforeOrAtSame(info.inDate?.value) ??
                        false));
          } else if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 没有输入[入场时间]
            b7 = (info.birthDate?.value
                    .isBeforeOrAtSame(info.operationDate?.value) ??
                false);
          }
        }

        String message;
        if (!b1) {
          message = '请选择性别';
        } else if (!b2) {
          message = '请输入批次号下的牛犊数量';
        } else if (!b3) {
          message = '请选择出生日期';
        } else if (!b4) {
          message = '请选择品种';
        } else if (!b5) {
          message = '请选择栋舍';
        } else if (!b6) {
          message = '请选择操作日期';
        } else if (!b7) {
          message = info.currentStage == 1
              ? '操作时间不能早于入场日期'
              : '操作时间不能早于入场日期, 入场日期不能早于出生日期';
        } else {
          message = '请填写牛只必填项';
        }
        return [b1 && b2 && b3 && b4 && b5 && b6 && b7, message];
      case 3:
        // 后备牛
        if (info.gender?.value == 1) {
          // 公牛
          debugPrint('------后备公牛------');
          debugPrint('${info.gender?.value == 1} - gender -');
          debugPrint('${info.earNum.isNotBlank().orFalse()} - earNum - ');
          debugPrint(
              '${info.birthDate.isRxStringNotBlank().orFalse()} - birthDate - ');
          debugPrint('${info.breed.isRxStringNotBlank().orFalse()} - breed - ');
          debugPrint(
              '${info.shedId.isRxStringNotBlank().orFalse()} - shedId - ');
          debugPrint(
              '${info.operationDate.isRxStringNotBlank().orFalse()} - operationDate - ');

          bool b1 = info.gender?.value == 1;
          bool b2 = info.earNum.isNotBlank().orFalse(); // 耳号
          bool b3 = info.birthDate.isRxStringNotBlank().orFalse(); // 出生日期
          bool b4 = info.breed.isRxStringNotBlank().orFalse(); // 品种
          bool b5 = info.shedId.isRxStringNotBlank().orFalse(); // 栋舍
          bool b6 = info.operationDate.isRxStringNotBlank().orFalse();
          bool b7 = false;
          if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isNotEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 有输入[入场时间]
            b7 = (info.inDate?.value
                        .isBeforeOrAtSame(info.operationDate?.value) ??
                    false) &&
                ((info.inDate?.value.isNotEmpty ?? false) &&
                    (info.birthDate?.value
                            .isBeforeOrAtSame(info.inDate?.value) ??
                        false));
          } else if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 没有输入[入场时间]
            b7 = (info.birthDate?.value
                    .isBeforeOrAtSame(info.operationDate?.value) ??
                false);
          }

          String message;
          if (!b1) {
            message = '请选择性别';
          } else if (!b2) {
            message = '请输入耳号';
          } else if (!b3) {
            message = '请选择出生日期';
          } else if (!b4) {
            message = '请选择品种';
          } else if (!b5) {
            message = '请选择栋舍';
          } else if (!b6) {
            message = '请选择操作日期';
          } else if (!b7) {
            message = '操作时间不能早于入场日期, 入场日期不能早于出生日期';
          } else {
            message = '请填写牛只必填项';
          }

          return [b1 && b2 && b3 && b4 && b5 && b6 && b7, message];
        }
        if (info.gender?.value == 2) {
          debugPrint('------后备母牛------');
          debugPrint('${info.gender?.value == 2} - gender -');
          debugPrint('${info.earNum.isNotBlank().orFalse()} - earNum - ');
          debugPrint('${info.pregnancyNum?.value == '0'}');
          debugPrint(
              '${info.birthDate.isRxStringNotBlank().orFalse()} - birthDate - ');
          debugPrint('${info.breed.isRxStringNotBlank().orFalse()} - breed - ');
          debugPrint(
              '${info.shedId.isRxStringNotBlank().orFalse()} - shedId - ');
          debugPrint(
              '${info.operationDate.isRxStringNotBlank().orFalse()} - operationDate - ');
          // 母牛
          bool b1 = info.gender?.value == 2;
          bool b2 = info.earNum.isNotBlank().orFalse(); // 耳号
          bool b3 = info.pregnancyNum?.value == '0'; // 后备母牛的胎次为0
          bool b4 = info.birthDate.isRxStringNotBlank().orFalse(); // 出生日期
          bool b5 = info.breed.isRxStringNotBlank().orFalse(); // 品种
          bool b6 = info.shedId.isRxStringNotBlank().orFalse(); // 栋舍
          bool b7 = info.operationDate.isRxStringNotBlank().orFalse();
          bool b8 = false;
          if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isNotEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 有输入[入场时间]
            b8 = (info.inDate?.value
                        .isBeforeOrAtSame(info.operationDate?.value) ??
                    false) &&
                ((info.inDate?.value.isNotEmpty ?? false) &&
                    (info.birthDate?.value
                            .isBeforeOrAtSame(info.inDate?.value) ??
                        false));
          } else if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 没有输入[入场时间]
            b8 = (info.birthDate?.value
                    .isBeforeOrAtSame(info.operationDate?.value) ??
                false);
          }

          String message;
          if (!b1) {
            message = '性别有误';
          } else if (!b2) {
            message = '请输入耳号';
          } else if (!b3) {
            message = '胎次有误${info.pregnancyNum?.value}';
          } else if (!b4) {
            message = '请选择出生日期';
          } else if (!b5) {
            message = '请选择品种';
          } else if (!b6) {
            message = '请选择栋舍';
          } else if (!b7) {
            message = '请选择操作日期';
          } else if (!b8) {
            message = '操作时间不能早于入场日期, 入场日期不能早于出生日期';
          } else {
            message = '请填写牛只必填项';
          }

          return [b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8, message];
        }
      case 4:
        // 种牛
        if (info.gender?.value == 1) {
          debugPrint('------种公牛------');
          debugPrint('${info.gender?.value == 1} - gender -');
          debugPrint('${info.earNum.isNotBlank().orFalse()} - earNum - '); // 耳号
          debugPrint(
              '${info.birthDate.isRxStringNotBlank().orFalse()} - birthDate - '); // 出生日期
          debugPrint(
              '${info.breed.isRxStringNotBlank().orFalse()} - breed - '); // 品种
          debugPrint(
              '${info.shedId.isRxStringNotBlank().orFalse()} - shedId - '); // 栋舍
          debugPrint(
              '${info.operationDate.isRxStringNotBlank().orFalse()} - operationDate - '); // 操作日期
          // 公牛
          bool b1 = info.gender?.value == 1;
          bool b2 = info.earNum.isNotBlank().orFalse(); // 耳号
          bool b3 = info.birthDate.isRxStringNotBlank().orFalse(); // 出生日期
          bool b4 = info.breed.isRxStringNotBlank().orFalse(); // 品种
          bool b5 = info.shedId.isRxStringNotBlank().orFalse(); // 栋舍
          bool b6 = info.operationDate.isRxStringNotBlank().orFalse(); // 操作日期
          bool b7 = false;
          if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isNotEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 有输入[入场时间]
            b7 = (info.inDate?.value
                        .isBeforeOrAtSame(info.operationDate?.value) ??
                    false) &&
                ((info.inDate?.value.isNotEmpty ?? false) &&
                    (info.birthDate?.value
                            .isBeforeOrAtSame(info.inDate?.value) ??
                        false));
          } else if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 没有输入[入场时间]
            b7 = (info.birthDate?.value
                    .isBeforeOrAtSame(info.operationDate?.value) ??
                false);
          }

          String message;
          if (!b1) {
            message = '性别有误';
          } else if (!b2) {
            message = '请输入耳号';
          } else if (!b3) {
            message = '请选择出生日期';
          } else if (!b4) {
            message = '请选择品种';
          } else if (!b5) {
            message = '请选择栋舍';
          } else if (!b6) {
            message = '请选择操作日期';
          } else if (!b7) {
            message = '操作时间不能早于入场日期, 入场日期不能早于出生日期';
          } else {
            message = '请填写牛只必填项';
          }

          return [b1 && b2 && b3 && b4 && b5 && b6 && b7, message];
        }
        if (info.gender?.value == 2) {
          debugPrint('------种母牛------');
          debugPrint('${info.gender?.value == 2} - gender -');
          debugPrint('${info.earNum.isNotBlank().orFalse()} - earNum - '); // 耳号
          debugPrint(
              '${info.birthDate.isRxStringNotBlank().orFalse()} - birthDate - '); // 出生日期
          debugPrint(
              '${info.breed.isRxStringNotBlank().orFalse()} - breed - '); // 品种
          debugPrint(
              '${info.pregnancyNum.isRxStringNotBlank().orFalse()} - pregnancyNum - '); // 胎次, 种牛的公牛没有胎次
          debugPrint(
              '${info.shedId.isRxStringNotBlank().orFalse()} - shedId - '); // 栋舍
          debugPrint(
              '${info.operationDate.isRxStringNotBlank().orFalse()} - operationDate - '); // 操作日期
          // 母牛
          bool b1 = info.gender?.value == 2;
          bool b2 = info.earNum.isNotBlank().orFalse(); // 耳号
          bool b3 = info.birthDate.isRxStringNotBlank().orFalse(); // 出生日期
          bool b4 = info.breed.isRxStringNotBlank().orFalse(); // 品种
          bool b5 =
              info.pregnancyNum.isRxStringNotBlank().orFalse(); // 胎次, 种牛的公牛没有胎次
          bool b6 = info.shedId.isRxStringNotBlank().orFalse(); // 栋舍
          bool b7 = info.operationDate.isRxStringNotBlank().orFalse(); // 操作日期
          bool b8 = false;
          if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isNotEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 有输入[入场时间]
            b8 = (info.inDate?.value
                        .isBeforeOrAtSame(info.operationDate?.value) ??
                    false) &&
                ((info.inDate?.value.isNotEmpty ?? false) &&
                    (info.birthDate?.value
                            .isBeforeOrAtSame(info.inDate?.value) ??
                        false));
          } else if ((info.birthDate?.value.isNotEmpty ?? false) &&
              (info.inDate?.value.isEmpty ?? false) &&
              (info.operationDate?.value.isNotEmpty ?? false)) {
            // 用于育肥牛的日期判断, 没有输入[入场时间]
            b8 = (info.birthDate?.value
                    .isBeforeOrAtSame(info.operationDate?.value) ??
                false);
          }

          String message;
          if (!b1) {
            message = '性别有误';
          } else if (!b2) {
            message = '请输入耳号';
          } else if (!b3) {
            message = '请选择出生日期';
          } else if (!b4) {
            message = '请选择品种';
          } else if (!b5) {
            message = '请选择胎次';
          } else if (!b6) {
            message = '请选择栋舍';
          } else if (!b7) {
            message = '请选择操作日期';
          } else if (!b8) {
            message = '操作时间不能早于入场日期, 入场日期不能早于出生日期';
          } else {
            message = '请填写牛只必填项';
          }

          return [b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8, message];
        }
      case 5:
        debugPrint('------妊娠母牛------');
        debugPrint('${info.gender?.value == 2} - gender -');
        debugPrint('${info.earNum.isNotBlank().orFalse()} - earNum - '); // 耳号
        debugPrint(
            '${info.birthDate.isRxStringNotBlank().orFalse()} - birthDate - '); // 出生日期
        debugPrint(
            '${info.breed.isRxStringNotBlank().orFalse()} - breed - '); // 品种
        debugPrint(
            '${info.pregnancyNum.isRxStringNotBlank().orFalse()} - pregnancyNum - '); // 胎次, 种牛的公牛没有胎次
        debugPrint(
            '${info.shedId.isRxStringNotBlank().orFalse()} - shedId - '); // 栋舍
        debugPrint(
            '${info.operationDate.isRxStringNotBlank().orFalse()} - operationDate - '); // 操作日期
        // 妊娠母牛
        bool b1 = info.gender?.value == 2;
        bool b2 = info.earNum.isNotBlank().orFalse(); // 耳号
        bool b3 = info.birthDate.isRxStringNotBlank().orFalse(); // 出生日期
        bool b4 = info.breed.isRxStringNotBlank().orFalse(); // 品种
        bool b5 =
            info.pregnancyNum.isRxStringNotBlank().orFalse(); // 胎次, 种牛的公牛没有胎次
        bool b6 = info.shedId.isRxStringNotBlank().orFalse(); // 栋舍
        bool b7 = info.operationDate.isRxStringNotBlank().orFalse(); // 操作日期
        bool b8 = false;
        if ((info.birthDate?.value.isNotEmpty ?? false) &&
            (info.inDate?.value.isNotEmpty ?? false) &&
            (info.operationDate?.value.isNotEmpty ?? false)) {
          // 用于育肥牛的日期判断, 有输入[入场时间]
          b8 = (info.inDate?.value
                      .isBeforeOrAtSame(info.operationDate?.value) ??
                  false) &&
              ((info.inDate?.value.isNotEmpty ?? false) &&
                  (info.birthDate?.value.isBeforeOrAtSame(info.inDate?.value) ??
                      false));
        } else if ((info.birthDate?.value.isNotEmpty ?? false) &&
            (info.inDate?.value.isEmpty ?? false) &&
            (info.operationDate?.value.isNotEmpty ?? false)) {
          // 用于育肥牛的日期判断, 没有输入[入场时间]
          b8 = (info.birthDate?.value
                  .isBeforeOrAtSame(info.operationDate?.value) ??
              false);
        }

        String message;
        if (!b1) {
          message = '性别有误';
        } else if (!b2) {
          message = '请输入耳号';
        } else if (!b3) {
          message = '请选择出生日期';
        } else if (!b4) {
          message = '请选择品种';
        } else if (!b5) {
          message = '请选择胎次';
        } else if (!b6) {
          message = '请选择栋舍';
        } else if (!b7) {
          message = '请选择上一次配种时间';
        } else if (!b8) {
          message = '操作时间不能早于入场日期, 入场日期不能早于出生日期';
        } else {
          message = '请填写牛只必填项';
        }

        return [b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8, message];
      case 6:
        debugPrint('------哺乳母牛------');
        debugPrint('${info.gender?.value == 2} - gender -');
        debugPrint('${info.earNum.isNotBlank().orFalse()} - earNum - '); // 耳号
        debugPrint(
            '${info.birthDate.isRxStringNotBlank().orFalse()} - birthDate - '); // 出生日期
        debugPrint(
            '${info.breed.isRxStringNotBlank().orFalse()} - breed - '); // 品种
        debugPrint(
            '${info.pregnancyNum.isRxStringNotBlank().orFalse()} - pregnancyNum - '); // 胎次, 种牛的公牛没有胎次
        debugPrint(
            '${info.shedId.isRxStringNotBlank().orFalse()} - shedId - '); // 栋舍
        debugPrint(
            '${info.calvingNum.isNotBlank().orFalse()} - calvingNum - '); // 上一次产犊数量
        debugPrint(
            '${info.operationDate.isRxStringNotBlank().orFalse()} - operationDate - '); // 操作日期
        // 哺乳母牛
        bool b1 = info.gender?.value == 2;
        bool b2 = info.earNum.isNotBlank().orFalse(); // 耳号
        bool b3 = info.birthDate.isRxStringNotBlank().orFalse(); // 出生日期
        bool b4 = info.breed.isRxStringNotBlank().orFalse(); // 品种
        bool b5 =
            info.pregnancyNum.isRxStringNotBlank().orFalse(); // 胎次, 种牛的公牛没有胎次
        bool b6 = info.shedId.isRxStringNotBlank().orFalse(); // 栋舍
        bool b7 = info.operationDate.isRxStringNotBlank().orFalse(); // 操作日期
        bool b8 = info.calvingNum.isNotBlank().orFalse(); // 上一次产犊数量
        bool b9 = false;
        if ((info.birthDate?.value.isNotEmpty ?? false) &&
            (info.inDate?.value.isNotEmpty ?? false) &&
            (info.operationDate?.value.isNotEmpty ?? false)) {
          // 用于育肥牛的日期判断, 有输入[入场时间]
          b9 = (info.inDate?.value
                      .isBeforeOrAtSame(info.operationDate?.value) ??
                  false) &&
              ((info.inDate?.value.isNotEmpty ?? false) &&
                  (info.birthDate?.value.isBeforeOrAtSame(info.inDate?.value) ??
                      false));
        } else if ((info.birthDate?.value.isNotEmpty ?? false) &&
            (info.inDate?.value.isEmpty ?? false) &&
            (info.operationDate?.value.isNotEmpty ?? false)) {
          // 用于育肥牛的日期判断, 没有输入[入场时间]
          b9 = (info.birthDate?.value
                  .isBeforeOrAtSame(info.operationDate?.value) ??
              false);
        }

        String message;
        if (!b1) {
          message = '性别有误';
        } else if (!b2) {
          message = '请输入耳号';
        } else if (!b3) {
          message = '请选择出生日期';
        } else if (!b4) {
          message = '请选择品种';
        } else if (!b5) {
          message = '请选择胎次';
        } else if (!b6) {
          message = '请选择栋舍';
        } else if (!b7) {
          message = '请选择上一次产犊时间';
        } else if (!b8) {
          message = '请输入上一次产犊数量';
        } else if (!b9) {
          message = '操作时间不能早于入场日期, 入场日期不能早于出生日期';
        } else {
          message = '请填写牛只必填项';
        }

        return [b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8 && b9, message];
      case 7:
        debugPrint('------空怀母牛------');
        debugPrint('${info.gender?.value == 2} - gender -');
        debugPrint('${info.earNum.isNotBlank().orFalse()} - earNum - '); // 耳号
        debugPrint(
            '${info.birthDate.isRxStringNotBlank().orFalse()} - birthDate - '); // 出生日期
        debugPrint(
            '${info.breed.isRxStringNotBlank().orFalse()} - breed - '); // 品种
        debugPrint(
            '${info.pregnancyNum.isRxStringNotBlank().orFalse()} - pregnancyNum - '); // 胎次, 种牛的公牛没有胎次
        debugPrint(
            '${info.shedId.isRxStringNotBlank().orFalse()} - shedId - '); // 栋舍
        debugPrint(
            '${info.operationDate.isRxStringNotBlank().orFalse()} - operationDate - '); // 操作日期
        // 空怀母牛
        bool b1 = info.gender?.value == 2;
        bool b2 = info.earNum.isNotBlank().orFalse(); // 耳号
        bool b3 = info.birthDate.isRxStringNotBlank().orFalse(); // 出生日期
        bool b4 = info.breed.isRxStringNotBlank().orFalse(); // 品种
        bool b5 =
            info.pregnancyNum.isRxStringNotBlank().orFalse(); // 胎次, 种牛的公牛没有胎次
        bool b6 = info.shedId.isRxStringNotBlank().orFalse(); // 栋舍
        bool b7 = info.operationDate.isRxStringNotBlank().orFalse(); // 操作日期
        bool b8 = false;
        if ((info.birthDate?.value.isNotEmpty ?? false) &&
            (info.inDate?.value.isNotEmpty ?? false) &&
            (info.operationDate?.value.isNotEmpty ?? false)) {
          // 用于育肥牛的日期判断, 有输入[入场时间]
          b8 = (info.inDate?.value
                      .isBeforeOrAtSame(info.operationDate?.value) ??
                  false) &&
              ((info.inDate?.value.isNotEmpty ?? false) &&
                  (info.birthDate?.value.isBeforeOrAtSame(info.inDate?.value) ??
                      false));
        } else if ((info.birthDate?.value.isNotEmpty ?? false) &&
            (info.inDate?.value.isEmpty ?? false) &&
            (info.operationDate?.value.isNotEmpty ?? false)) {
          // 用于育肥牛的日期判断, 没有输入[入场时间]
          b8 = (info.birthDate?.value
                  .isBeforeOrAtSame(info.operationDate?.value) ??
              false);
        }

        String message;
        if (!b1) {
          message = '性别有误';
        } else if (!b2) {
          message = '请输入耳号';
        } else if (!b3) {
          message = '请选择出生日期';
        } else if (!b4) {
          message = '请选择品种';
        } else if (!b5) {
          message = '请选择胎次';
        } else if (!b6) {
          message = '请选择栋舍';
        } else if (!b7) {
          message = '请选择上一次断奶时间';
        } else if (!b8) {
          message = '操作时间不能早于入场日期, 入场日期不能早于出生日期';
        } else {
          message = '请填写牛只必填项';
        }

        return [b1 && b2 && b3 && b4 && b5 && b6 && b7 && b8, message];
    }
    return [false];
  }
}
