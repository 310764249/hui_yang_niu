import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/cow_batch.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/colors.dart';
import '../../../../services/constant.dart';
import '../../../../services/ex_int.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../widgets/picker.dart';
import '../../../../widgets/radio_button_group.dart';
import '../../../../widgets/toast.dart';
import '../../../batch_list/controllers/batch_list_controller.dart';
import '../controllers/new_cattle_controller.dart';

///
/// 牛只新增
/// 犊牛: Calf
/// 育肥牛: Young cattle
/// 后备牛: Reserve cattle
/// 种牛: Breeding cattle
/// 妊娠母牛: Pregnant cow
/// 哺乳母牛: Milking cow
/// 空怀母牛: Empty cow
///
class NewCattleView extends GetView<NewCattleController> {
  const NewCattleView({super.key});

  // 公共布局
  Widget _commonLayout(BuildContext context) {
    return Column(
      children: [
        CellTextField(
          isRequired: true,
          title: '耳号',
          hint: '请输入',
          content: controller.cattleInfo.earNum,
          controller: controller.earNumController,
          focusNode: controller.earNumNode,
          onChanged: (value) => {controller.cattleInfo.earNum = value},
        ),
        controller.cattleInfo.currentStage == 8 || controller.cattleInfo.currentStage == 10
            ? CellButton(
                isRequired: false,
                title: '批次（批次牛只必传）',
                colorTitle: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "批次",
                      style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14), fontWeight: FontWeight.w500, color: SaienteColors.blackE5)),
                  // 备用公牛，母牛，种公牛彼此非必填
                  TextSpan(
                      text: controller.cattleInfo.currentStage == 8 ||
                              controller.cattleInfo.currentStage == 9 ||
                              controller.cattleInfo.currentStage == 10
                          ? ''
                          : "（批次牛只必传）",
                      style: TextStyle(fontSize: ScreenAdapter.fontSize(14), fontWeight: FontWeight.w500, color: Colors.red))
                ])),
                hint: '请选择',
                content: controller.cattleInfo.batchNum?.value,
                onPressed: () {
                  //1：犊牛；2：育肥牛；3：引种牛；4：选育牛；5：后备公牛；6：后备母牛

                  Get.toNamed(Routes.BATCH_LIST,
                      arguments: BatchListArgument(
                        goBack: true,
                        type: controller.cattleInfo.currentStage == 8 ? 5 : 6,
                      ))?.then((value) {
                    if (ObjectUtil.isEmpty(value)) {
                      return;
                    }
                    //拿到批次号数组
                    List<CowBatch> list = value as List<CowBatch>;
                    // 选择完批次牛后, 自动带出: 1.批次号, 2.来源场, 3.入场时间等等信息
                    controller.updateCattleData(list.first);
                  });
                })
            : const SizedBox.shrink(),
        CellTextField(
          isRequired: false,
          title: '来源场',
          hint: '请输入',
          controller: TextEditingController(text: controller.cattleInfo.sourceFarm?.value.toString().trim()),
          focusNode: controller.sourceFarmNode,
          onChanged: (value) => {controller.sourceFarmController.text = value},
        ),
        CellButton(
            isRequired: false,
            title: '入场时间',
            hint: '请选择',
            content: controller.cattleInfo.inDate?.value,
            onPressed: () {
              Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.cattleInfo.inDate?.value, onConfirm: (date) {
                controller.cattleInfo.inDate?.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
              });
            }),
        CellButton(
            isRequired: true,
            title: '出生年月',
            hint: '请选择',
            content: controller.cattleInfo.birthDate?.value,
            onPressed: () {
              Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.cattleInfo.birthDate?.value,
                  onConfirm: (date) {
                controller.cattleInfo.birthDate?.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
              });
            }),
        // 品种
        _breedSelectionLayout(context),
      ],
    );
  }

  // 母牛公共部分UI
  Widget _commonCowLayout(BuildContext context) {
    return Obx(() => Column(children: [
          //妊娠，空怀，哺乳 这三个显示胎次，其他不显示
          (controller.cattleInfo.currentStage == 5 ||
                  controller.cattleInfo.currentStage == 6 ||
                  controller.cattleInfo.currentStage == 7)
              ? RadioButtonGroup(
                  isRequired: true,
                  title: '胎次',
                  selectedIndex: controller.tempPregnancyNumPosition.value,
                  items: Constant.pregnancyNumList,
                  onChanged: (value) {
                    // 赋值temp
                    controller.tempPregnancyNumPosition.value = value;
                    controller.cattleInfo.pregnancyNum?.value = Constant.pregnancyNumList[value];
                  })
              : const SizedBox(),
          _shedSelectionLayout(context),
          CellTextField(
            isRequired: false,
            title: '栏位',
            hint: '请输入',
            controller: TextEditingController(text: controller.cattleInfo.field?.value.toString().trim()),
            focusNode: controller.fieldNode,
            onChanged: (value) {
              controller.fieldController.text = value;
            },
          ),
        ]));
  }

  // 底部公共布局: 操作时间 & 备注
  Widget _commonBottomLayout(BuildContext context) {
    // 操作时间自动生成
    controller.cattleInfo.operationDate?.value = DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    return Column(
      children: [
        // 操作时间
        controller.cattleInfo.currentStage == 5 ||
                controller.cattleInfo.currentStage == 6 ||
                controller.cattleInfo.currentStage == 7
            ? const SizedBox()
            : CellButton(
                isRequired: false,
                title: '操作时间',
                // hint: '请选择',
                showArrow: false,
                content: controller.cattleInfo.operationDate?.value,
                onPressed: () {
                  // Picker.showDatePicker(context,
                  //     title: '请选择时间',
                  //     selectDate: controller.cattleInfo.operationDate?.value,
                  //     onConfirm: (date) {
                  //   // 前4中状态的牛才能赋值[操作时间], 后面3种母牛有指定的时间
                  //   if (controller.cattleInfo.currentStage == 1 ||
                  //       controller.cattleInfo.currentStage == 2 ||
                  //       controller.cattleInfo.currentStage == 3 ||
                  //       controller.cattleInfo.currentStage == 4) {
                  //     controller.cattleInfo.operationDate?.value =
                  //         "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                  //   }
                  // });
                }),
        // 备注信息
        CellTextArea(
            isRequired: false,
            title: "备注信息",
            hint: "请输入",
            showBottomLine: false,
            controller: controller.remarkController,
            focusNode: controller.remarkNode,
            onChanged: (value) => {controller.cattleInfo.remark = value}),
      ],
    );
  }

  // 性别选择
  Widget _genderSelectionLayout() {
    return const SizedBox.shrink();
    // return RadioButtonGroup(
    //     isRequired: true,
    //     title: '性别',
    //     selectedIndex: controller.tempGenderPosition.value,
    //     items: Constant.genderNameList,
    //     showBottomLine: true,
    //     onChanged: (value) {
    //       controller.tempGenderPosition.value = value;
    //       controller.cattleInfo.gender?.value = Constant.genderNameList[value] == '公牛' ? 1 : 2;
    //       // 如果是公牛的话就设置[胎次]为空
    //       updatePregnancyNum();
    //     });
  }

  // 栋舍选择
  Widget _shedSelectionLayout(BuildContext context) {
    return CellButton(
      isRequired: true,
      title: '栋舍',
      content: controller.cattleInfo.shed?.value,
      onPressed: () {
        Picker.showSinglePicker(context, controller.houseNameList, selectData: controller.cattleInfo.shed?.value, title: '请选择栋舍',
            onConfirm: (value, position) {
          controller.cattleInfo.shedId?.value = controller.houseList[position].id;
          controller.cattleInfo.shed?.value = value;
        });
      },
    );
  }

  Widget _breedSelectionLayout(BuildContext context) {
    return RadioButtonGroup(
        isRequired: true,
        title: '品种',
        selectedIndex: controller.tempBreedPosition.value,
        items: controller.breedNameList,
        onChanged: (value) {
          // 赋值temp
          controller.tempBreedPosition.value = value;
          controller.cattleInfo.breed?.value = controller.breedList[value]['value'];
        });
  }

  // 犊牛 & 育肥牛
  Widget _youngCattleLayout(BuildContext context, bool isBabyCalf) {
    return Column(
      children: [
        // _genderSelectionLayout(),
        // 批次号不可编辑
        // if (controller.cattleInfo.currentStage == 8 || controller.cattleInfo.currentStage == 10)
        //   CellButton(
        //     isRequired: true,
        //     title: '批次号（自动生成）',
        //     content:
        //         controller.cattleInfo.currentStage == 1 ? controller.tempBatchNumAuto1.value : controller.tempBatchNumAuto2.value,
        //     // 区分犊牛和育肥牛
        //     showArrow: false,
        //     onPressed: () {
        //       // 如果页面初始化批次号获取失败的话, 需要再次点击生成[批次号(自动生成)]
        //       controller.retrieveBatchNumAutoIfNeeded();
        //     },
        //   ),
        CellTextField(
          isRequired: true,
          title: '批次号下牛犊数量',
          hint: '请输入',
          keyboardType: TextInputType.number,
          content: controller.cattleInfo.cattleNumOfBatch,
          controller: controller.cattleNumOfBatchController,
          focusNode: controller.cattleNumOfBatchNode,
          onChanged: (value) => {controller.cattleInfo.cattleNumOfBatch = value},
        ),
        // 育肥牛有来源场和入场时间, 犊牛没有
        isBabyCalf
            ? const SizedBox()
            : CellTextField(
                isRequired: false,
                title: '来源场',
                hint: '请输入',
                content: controller.cattleInfo.sourceFarm?.value,
                controller: controller.sourceFarmController,
                focusNode: controller.sourceFarmNode,
                onChanged: (value) => {controller.cattleInfo.sourceFarm?.value = value},
              ),
        isBabyCalf
            ? const SizedBox()
            : CellButton(
                isRequired: false,
                title: '入场时间',
                hint: '请选择',
                content: controller.cattleInfo.inDate?.value,
                onPressed: () {
                  Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.cattleInfo.inDate?.value,
                      onConfirm: (date) {
                    controller.cattleInfo.inDate?.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                  });
                }),
        CellButton(
            isRequired: true,
            title: '出生年月',
            hint: '请选择',
            content: controller.cattleInfo.birthDate?.value,
            onPressed: () {
              Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.cattleInfo.birthDate?.value,
                  onConfirm: (date) {
                controller.cattleInfo.birthDate?.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
              });
            }),
        _breedSelectionLayout(context),
        _shedSelectionLayout(context),
      ],
    );
  }

  // 后备牛
  Widget _reserveCattleLayout(BuildContext context) {
    return Column(
      children: [
        // _genderSelectionLayout(),
        _commonLayout(context),
        _commonCowLayout(context),
      ],
    );
  }

  // 种牛
  Widget _breedingCattleLayout(BuildContext context) {
    return Column(
      children: [
        // _genderSelectionLayout(),
        _commonLayout(context),
        _commonCowLayout(context),
      ],
    );
  }

  // 妊娠母牛
  Widget _pregnantCowLayout(BuildContext context) {
    return Column(
      children: [
        _commonLayout(context),
        _commonCowLayout(context),
        CellButton(
            isRequired: true,
            title: '上一次配种时间',
            hint: '请选择',
            content: controller.cattleInfo.operationDate?.value,
            onPressed: () {
              Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.cattleInfo.operationDate?.value,
                  onConfirm: (date) {
                // controller.cattleInfo.pregnancyCheckTime?.value =
                //     "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                // 妊娠母牛 - 将[孕检时间]赋值到[操作时间]的字段
                if (controller.cattleInfo.currentStage == 5) {
                  controller.cattleInfo.operationDate?.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                }
              });
            }),
      ],
    );
  }

  // 哺乳母牛
  Widget _milkingCowLayout(BuildContext context) {
    return Column(
      children: [
        _commonLayout(context),
        _commonCowLayout(context),
        CellButton(
            isRequired: true,
            title: '上一次产犊时间',
            hint: '请选择',
            content: controller.cattleInfo.operationDate?.value,
            onPressed: () {
              Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.cattleInfo.operationDate?.value,
                  onConfirm: (date) {
                // controller.cattleInfo.calvingTime?.value =
                //     "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                // 哺乳母牛 - 将[产犊时间]赋值到[操作时间]的字段
                if (controller.cattleInfo.currentStage == 6) {
                  controller.cattleInfo.operationDate?.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                }
              });
            }),
        CellTextField(
          isRequired: true,
          title: '上一次产犊数量',
          hint: '请输入',
          keyboardType: TextInputType.number,
          content: controller.cattleInfo.calvingNum,
          controller: controller.calvingNumController,
          focusNode: controller.calvingNumNode,
          onChanged: (value) => {controller.cattleInfo.calvingNum = value},
        ),
      ],
    );
  }

  // 空怀母牛
  Widget _emptyCowLayout(BuildContext context) {
    return Column(
      children: [
        _commonLayout(context),
        _commonCowLayout(context),
        // CellButton(
        //     isRequired: true,
        //     title: '上一次断奶时间',
        //     hint: '请选择',
        //     content: controller.cattleInfo.operationDate?.value,
        //     onPressed: () {
        //       Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.cattleInfo.operationDate?.value,
        //           onConfirm: (date) {
        //         // controller.cattleInfo.weaningTime?.value =
        //         //     "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
        //         // 空怀母牛 - 将[断奶时间]赋值到[操作时间]的字段
        //         if (controller.cattleInfo.currentStage == 7) {
        //           controller.cattleInfo.operationDate?.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
        //         }
        //       });
        //     }),
      ],
    );
  }

  // 操作信息
  Widget _operationInfo(context) {
    return Obx(() => MyCard(children: [
          const CardTitle(title: "操作信息"),
          // 当前状态选择器
          RadioButtonGroup(
              isRequired: true,
              title: '当前状态',
              items: List<String>.from(Constant.currentStageList.map((item) => item.name).toList()),
              selectedIndex: controller.selStage.value,
              onChanged: (value) {
                // 1.更新当前状态显示
                controller.updateCurrentStage(value);

                // 2.每次切换都需要把提交的数据初始化一遍, 防止数据字段相互串用
                controller.initRequestParams(value);

                // 3.更新[胎次]
                controller.updatePregnancyNum();
              }),

          // // 犊牛
          // if (controller.cattleInfo.currentStage == 1) _youngCattleLayout(context, true),
          // // 育肥牛
          // if (controller.cattleInfo.currentStage == 2) _youngCattleLayout(context, false),
          // 后备牛
          if (controller.cattleInfo.currentStage == 3) _reserveCattleLayout(context),
          // // 种牛
          // if (controller.cattleInfo.currentStage == 4) _breedingCattleLayout(context),
          // 妊娠母牛
          if (controller.cattleInfo.currentStage == 5) _pregnantCowLayout(context),
          // 哺乳母牛
          if (controller.cattleInfo.currentStage == 6) _milkingCowLayout(context),
          // 空怀母牛
          if (controller.cattleInfo.currentStage == 7) _emptyCowLayout(context),
          // 种公牛
          if (controller.cattleInfo.currentStage == 4) _breedingCattleLayout(context),

          // 底部公共布局: 操作时间 & 备注, 但也要注意区分后3种母牛和前面4种母牛的UI差异
          _commonBottomLayout(context),
        ]));
  }

  // 提交按钮
  Widget _commitButton() {
    return Padding(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      child: MainButton(
          text: "提交",
          onPressed: () async {
            controller.commitNewCattleData();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading设置屏蔽长按返回键的back toast
          leading: WillPopScope(
            onWillPop: () async {
              // 在这里执行返回按钮的操作
              Navigator.of(context).pop();
              return false; // 返回false禁用弹框提示
            },
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // 在这里执行返回按钮的操作
                Navigator.of(context).pop();
              },
            ),
          ),
          title: const Text('档案'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: PageWrapper(
          config: controller.buildConfig(context),
          child: ListView(
              // physics: const AlwaysScrollableScrollPhysics(
              // parent: BouncingScrollPhysics()),
              children: [
                // 操作信息
                _operationInfo(context),
                // 提交按钮
                _commitButton()
              ]),
        ));
  }
}
