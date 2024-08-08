import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/my_card.dart';

import '../models/cattle.dart';
import '../services/colors.dart';
import '../services/screenAdapter.dart';

class AssessEditCowView extends StatelessWidget{

  var bodyAssessList = AppDictList.searchItems('tkpg') ?? [];
  var breedAssessList = AppDictList.searchItems('fzpg') ?? [];


  Cattle? cow;

  AssessEditCowView(this.cow);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return cow == null ? Container() :
    Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Column(children: [

        Container(height: 5,color: SaienteColors.backGrey,),


        MyCard(children:[
          Container(
            height: ScreenAdapter.height(52),
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Text(
              "个体档案",
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(16),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Row(children: [
            tagVal("日龄", "${cow?.ageOfDay}"),
            tagVal("胎次", "${cow?.calvNum}")
          ],),
          Row(children: [
            tagVal("产活仔率", cow?.calfLiveRate),
            tagVal("上次孕检", cow?.lastPregcy)
          ],),
          Row(children: [
            tagVal("上次产犊", cow?.lastCalv),
            tagVal("空怀天数", "${cow?.nonantCount}")
          ],),
          Row(children: [
            tagVal("体况评估", AppDictList.findLabelByCode(bodyAssessList,cow!.bodyStatus.toString())),
            tagVal("体况描述", cow?.bodyDesc)
          ],),
          Row(children: [
            tagVal("繁殖评估", AppDictList.findLabelByCode(breedAssessList, cow!.breedStatus.toString())),
            tagVal("遗传说明", cow?.heredity)
          ],),
          Container(height: 10,)
        ],)
      ],),);
  }


  Widget tagVal(String tag,String? val){
    return Expanded(
        child: Row(children: [
          Text(
            tag,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontWeight: FontWeight.w500,
                fontSize: ScreenAdapter.fontSize(14)),
          ),
          SizedBox(height: ScreenAdapter.height(3),width: 10,),
          Text(
            val ?? "",
            style: TextStyle(
                color: SaienteColors.black80,
                fontSize: ScreenAdapter.fontSize(14)),
          )
        ]));
  }

}