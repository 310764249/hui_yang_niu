class AppDictList {
  static List dictList = [];
  /*
  static saveDict(List dictList) {
    print('setDictList----');
    if (dictList.isNotEmpty) {
      AppDictList.dictList = dictList;
      Storage.setData(Constant.dictList, dictList);
    }
  }

  static Future<List> getDictList() async {
    if (AppDictList.dictList.isEmpty) {
      AppDictList.dictList = await Storage.getData(Constant.dictList);
    } 
    return AppDictList.dictList;
  }
  */
  /*
  AppDictList._();

  // 单例模式固定格式
  static AppDictList? _instance;

  // 单例模式固定格式
  static AppDictList? getInstance() {
    if (_instance == null) {
      _instance = AppDictList._();
    }
    return _instance;
  }
  */

  // AppDictList._();

  // static final AppDictList _instance = AppDictList._();

  // static AppDictList get instance {
  //   return _instance;
  // }

  //根据 code 返回 item 列表
  static List? searchItems(String code) {
    Map? desiredMap;
    for (var map in dictList) {
      if (map['value'] == code) {
        desiredMap = map;
        break;
      }
    }
    List? children = desiredMap?['children'];
    // List<Map> children = (desiredMap ??= [] as Map<String, dynamic>?) as List<Map>;
    return children;
  }

  //过滤 children 数组
  static String findLabelByCode(List children, String code) {
    String result = '';
    // 使用 where 方法根据 value 过滤 label
    for (var dict in children) {
      if (dict["value"] == code) {
        result = dict["label"];
        break;
      }
    }
    // List filteredLabels = children
    //     .where((item) => item["value"] == code)
    //     .map((item) => item["label"])
    //     .toList();

    return result;
  }

  //过滤 children 数组 拿到指定 code 的 map 数组
  static List findMapByCode(List children, List codeList) {
    List result = [];
    //
    for (var dict in children) {
      for (String code in codeList) {
        if (dict["value"] == code) {
          result.add(dict);
        }
      }
    }
    return result;
  }

  //通过 Code 过滤数组，获取当前元素的 index
  static int findIndexByCode(List children, String code) {
    int result = 0;
    // 使用 where 方法根据 value 过滤 label
    for (var dict in children) {
      if (dict["value"] == code) {
        break;
      }
      result++;
    }
    return result;
  }
}
