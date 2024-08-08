///
class FormulaModel {
  late final String? id; //ID
  late final String? nutritionId; //营养标准ID
  late final String? name; //名称
  late final int? individualCate; //品种 西门塔尔、秦川牛
  late final int?
      individualType; //配方目标 1：妊娠母牛配方；2：哺乳母牛配方；3：犊牛配方；4：育肥牛配方；5：公牛配方；
  late final int? weightType; //个体重量
  late final int? calvingMonths; //产犊后月数
  late final int? gestationMonths; //妊娠月数
  late final double? dailyGainWeight; //日增重
  late final double? milkProduction; //泌乳量
  late final int? milkGrade; //泌乳等级
  late final double? baseDM; //基准干物质(%鲜样)
  late final double? dm; //干物质(%鲜样)R
  late final double? baseAsh; //基准灰分(%DM)
  late final double? ash; //灰分(%DM)
  late final double? baseStarch; //基准淀粉(%DM)
  late final double? starch; //淀粉(%DM)
  late final double? baseFat; //基准脂肪(%DM)
  late final double? fat; //脂肪(%DM)
  late final double? baseFibre; //基准粗纤维(%DM)
  late final double? fibre; //粗纤维(%DM)
  late final double? baseNDF; //基准中性洗涤纤维(%DM)
  late final double? ndf; //中性洗涤纤维(%DM)
  late final double? baseADF; //基准酸性洗涤纤维(%DM)
  late final double? adf; //酸性洗涤纤维(%DM)
  late final double? baseCP; //基准粗蛋白(%DM)
  late final double? cp; //粗蛋白(%DM)
  late final double? baseDE; //基准消化能
  late final double? de; //消化能
  late final double? baseMJ; //基准综合净能
  late final double? mj; //综合净能
  late final double? baseRND; //基准肉牛能量单位
  late final double? rnd; //肉牛能量单位
  late final double? baseCa; //基准钙(%DM)
  late final double? ca; //钙(%DM)
  late final double? baseP; //基准磷(%DM)
  late final double? p; //磷(%DM)
  late final double? baseNEm; //基准维持净能(Kcal/d)
  late final double? nEm; //维持净能(Kcal/d)
  late final double? baseNEg; //基准生长净能(Kcal/d)
  late final double? nEg; //生长净能(Kcal/d)
  late final double? baseMP; //基准代谢蛋白(g/d)
  late final double? mp; //代谢蛋白(g/d)
  late final double? weight; //重量
  late final double? price;
  late final bool? enable; //是否启用
  late final String? date; //发明时间
  late final String? description; //描述
  late final String? taboo; //禁忌事项
  late final String? executor; //制作人
  late final int?
      status; //状态 1：有效；2-营养标准更新；3-原料营养成分更新；3-营养标准删除；4-原料删除；5-配方更新；6-配方删除
  late final String? remark; //备注
  late final String? tenantId; //租户
  late final String? created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String? rowVersion; //行版本
  // 创建配方跳转参数, 考虑到列表进详情的用处, 这里去掉了late final
  List<FormulaItemModel>? roughages; //粗饲料集
  List<FormulaItemModel>? energyFeed; //能量饲料集
  List<FormulaItemModel>? proteinFeed; //蛋白饲料集
  List<FormulaItemModel>? additives; //添加剂集
  List<FormulaItemModel>? premix; //预混料集

  FormulaModel(
      {required this.id,
      required this.nutritionId,
      this.name,
      required this.individualCate,
      required this.individualType,
      required this.weightType,
      required this.calvingMonths,
      required this.gestationMonths,
      required this.dailyGainWeight,
      required this.milkProduction,
      required this.milkGrade,
      required this.baseDM,
      required this.dm,
      required this.baseAsh,
      required this.ash,
      required this.baseStarch,
      required this.starch,
      required this.baseFat,
      required this.fat,
      required this.baseFibre,
      required this.fibre,
      required this.baseNDF,
      required this.ndf,
      required this.baseADF,
      required this.adf,
      required this.baseCP,
      required this.cp,
      required this.baseDE,
      required this.de,
      required this.baseMJ,
      required this.mj,
      required this.baseRND,
      required this.rnd,
      required this.baseCa,
      required this.ca,
      required this.baseP,
      required this.p,
      required this.baseNEm,
      required this.nEm,
      required this.baseNEg,
      required this.nEg,
      required this.baseMP,
      required this.mp,
      required this.weight,
      required this.price,
      required this.enable,
      required this.date,
      this.description,
      this.taboo,
      this.executor,
      required this.status,
      this.remark,
      required this.tenantId,
      required this.created,
      this.createdBy,
      this.modified,
      this.modifiedBy,
      required this.rowVersion,
      this.roughages,
      this.energyFeed,
      this.proteinFeed,
      this.additives,
      this.premix});

  FormulaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nutritionId = json['nutritionId'];
    name = json['name'];
    individualCate = json['individualCate'];
    individualType = json['individualType'];
    weightType = json['weightType'];
    calvingMonths = json['calvingMonths'];
    gestationMonths = json['gestationMonths'];
    dailyGainWeight = double.parse((json['dailyGainWeight'] ?? 0).toString());
    milkProduction = double.parse((json['milkProduction'] ?? 0).toString());
    milkGrade = json['milkGrade'];
    baseDM = double.parse((json['baseDM'] ?? 0).toString());
    dm = double.parse((json['dm'] ?? 0).toString());
    baseAsh = double.parse((json['baseAsh'] ?? 0).toString());
    ash = double.parse((json['ash'] ?? 0).toString());
    baseStarch = double.parse((json['baseStarch'] ?? 0).toString());
    starch = double.parse((json['starch'] ?? 0).toString());
    baseFat = double.parse((json['baseFat'] ?? 0).toString());
    fat = double.parse((json['fat'] ?? 0).toString());
    baseFibre = double.parse((json['baseFibre'] ?? 0).toString());
    fibre = double.parse((json['fibre'] ?? 0).toString());
    baseNDF = double.parse((json['baseNDF'] ?? 0).toString());
    ndf = double.parse((json['ndf'] ?? 0).toString());
    baseADF = double.parse((json['baseADF'] ?? 0).toString());
    adf = double.parse((json['adf'] ?? 0).toString());
    baseCP = double.parse((json['baseCP'] ?? 0).toString());
    cp = double.parse((json['cp'] ?? 0).toString());
    baseDE = double.parse((json['baseDE'] ?? 0).toString());
    de = double.parse((json['de'] ?? 0).toString());
    baseMJ = double.parse((json['baseMJ'] ?? 0).toString());
    mj = double.parse((json['mj'] ?? 0).toString());
    baseRND = double.parse((json['baseRND'] ?? 0).toString());
    rnd = double.parse((json['rnd'] ?? 0).toString());
    baseCa = double.parse((json['baseCa'] ?? 0).toString());
    ca = double.parse((json['ca'] ?? 0).toString());
    baseP = double.parse((json['baseP'] ?? 0).toString());
    p = double.parse((json['p'] ?? 0).toString());
    baseNEm = double.parse((json['baseNEm'] ?? 0).toString());
    nEm = double.parse((json['nEm'] ?? 0).toString());
    baseNEg = double.parse((json['baseNEg'] ?? 0).toString());
    nEg = double.parse((json['nEg'] ?? 0).toString());
    baseMP = double.parse((json['baseMP'] ?? 0).toString());
    mp = double.parse((json['mp'] ?? 0).toString());
    weight = double.parse((json['weight'] ?? 0).toString());
    price = double.parse((json['price'] ?? 0).toString());
    enable = json['enable'];
    date = json['date'];
    description = json['description'];
    taboo = json['taboo'];
    executor = json['executor'];
    status = json['status'];
    remark = json['remark'];
    tenantId = json['tenantId'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
    if (json['roughages'] != null) {
      roughages = <FormulaItemModel>[];
      json['roughages'].forEach((v) {
        roughages!.add(FormulaItemModel.fromJson(v));
      });
    }
    if (json['energyFeed'] != null) {
      energyFeed = <FormulaItemModel>[];
      json['energyFeed'].forEach((v) {
        energyFeed!.add(FormulaItemModel.fromJson(v));
      });
    }
    if (json['proteinFeed'] != null) {
      proteinFeed = <FormulaItemModel>[];
      json['proteinFeed'].forEach((v) {
        proteinFeed!.add(FormulaItemModel.fromJson(v));
      });
    }
    if (json['additives'] != null) {
      additives = <FormulaItemModel>[];
      json['additives'].forEach((v) {
        additives!.add(FormulaItemModel.fromJson(v));
      });
    }
    if (json['premix'] != null) {
      premix = <FormulaItemModel>[];
      json['premix'].forEach((v) {
        premix!.add(FormulaItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nutritionId'] = nutritionId;
    data['name'] = name;
    data['individualCate'] = individualCate;
    data['individualType'] = individualType;
    data['weightType'] = weightType;
    data['calvingMonths'] = calvingMonths;
    data['gestationMonths'] = gestationMonths;
    data['dailyGainWeight'] = dailyGainWeight;
    data['milkProduction'] = milkProduction;
    data['milkGrade'] = milkGrade;
    data['baseDM'] = baseDM;
    data['dm'] = dm;
    data['baseAsh'] = baseAsh;
    data['ash'] = ash;
    data['baseStarch'] = baseStarch;
    data['starch'] = starch;
    data['baseFat'] = baseFat;
    data['fat'] = fat;
    data['baseFibre'] = baseFibre;
    data['fibre'] = fibre;
    data['baseNDF'] = baseNDF;
    data['ndf'] = ndf;
    data['baseADF'] = baseADF;
    data['adf'] = adf;
    data['baseCP'] = baseCP;
    data['cp'] = cp;
    data['baseDE'] = baseDE;
    data['de'] = de;
    data['baseMJ'] = baseMJ;
    data['mj'] = mj;
    data['baseRND'] = baseRND;
    data['rnd'] = rnd;
    data['baseCa'] = baseCa;
    data['ca'] = ca;
    data['baseP'] = baseP;
    data['p'] = p;
    data['baseNEm'] = baseNEm;
    data['nEm'] = nEm;
    data['baseNEg'] = baseNEg;
    data['nEg'] = nEg;
    data['baseMP'] = baseMP;
    data['mp'] = mp;
    data['weight'] = weight;
    data['price'] = price;
    data['enable'] = enable;
    data['date'] = date;
    data['description'] = description;
    data['taboo'] = taboo;
    data['executor'] = executor;
    data['status'] = status;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    if (roughages != null) {
      data['roughages'] = roughages!.map((e) => e.toJson()).toList();
    } else {
      data['roughages'] = null;
    }
    if (energyFeed != null) {
      data['energyFeed'] = energyFeed!.map((e) => e.toJson()).toList();
    } else {
      data['energyFeed'] = null;
    }
    if (proteinFeed != null) {
      data['proteinFeed'] = proteinFeed!.map((e) => e.toJson()).toList();
    } else {
      data['proteinFeed'] = null;
    }
    if (additives != null) {
      data['additives'] = additives!.map((e) => e.toJson()).toList();
    } else {
      data['additives'] = null;
    }
    if (premix != null) {
      data['premix'] = premix!.map((e) => e.toJson()).toList();
    } else {
      data['premix'] = null;
    }
    return data;
  }
}

//配方原料项目
class FormulaItemModel {
  late final String? formulaId; //配方ID
  late final String id; //原料ID
  late final double? demand; //干物质需要量重量(kg)
  late final double? weight; //毛重重量(kg)
  late final int type; //原料类型 0: 未知；1: 粗饲料; 2: 能量饲料；3：蛋白饲料；4：添加剂；5：预混料；6：精补料；
  late final String? name; //原料名称
  late final int code; //原料编号
  late final double? dm; //原料干物质(%鲜样)
  late final double? ash; //原料灰分(%DM)
  late final double? starch; //原料淀粉(%DM)
  late final double? fat; //原料脂肪(%DM)
  late final double? fibre; //原料粗纤维(%DM)
  late final double? ndf; //原料中性洗涤纤维(%DM)
  late final double? adf; //原料酸性洗涤纤维(%DM)
  late final double? cp; //原料粗蛋白(%DM)
  late final double? de; //原料消化能
  late final double? mj; //原料综合净能
  late final double? rnd; //原料肉牛能量单位
  late final double? ca; //原料钙(%DM)
  late final double? p; //原料磷(%DM)

  late final double? nEm;
  late final double? nEg;
  late final double? mp;
  late final double? price;
  late final int? variable;
  late final int? correlation;
  late final double? referenceValues;
  late final String? ruleCode;
  late final String? ruleRemark;

  late final String? remark; //原料备注

  FormulaItemModel({
    this.formulaId,
    required this.id,
    required this.demand,
    required this.weight,
    required this.type,
    this.name,
    required this.code,
    required this.dm,
    required this.ash,
    required this.starch,
    required this.fat,
    required this.fibre,
    required this.ndf,
    required this.adf,
    required this.cp,
    required this.de,
    required this.mj,
    required this.rnd,
    required this.ca,
    required this.p,
    required this.nEm,
    required this.nEg,
    required this.mp,
    required this.price,
    required this.variable,
    required this.correlation,
    required this.referenceValues,
    required this.ruleCode,
    required this.ruleRemark,
    this.remark,
  });
  FormulaItemModel.fromJson(Map<String, dynamic> json) {
    formulaId = json['formulaId'];
    id = json['id'];
    demand = double.parse((json['demand'] ?? 0).toString());
    weight = double.parse((json['weight'] ?? 0).toString());
    type = json['type'];
    name = json['name'];
    code = json['code'];
    dm = double.parse((json['dm'] ?? 0).toString());
    ash = double.parse((json['ash'] ?? 0).toString());
    starch = double.parse((json['starch'] ?? 0).toString());
    fat = double.parse((json['fat'] ?? 0).toString());
    fibre = double.parse((json['fibre'] ?? 0).toString());
    ndf = double.parse((json['ndf'] ?? 0).toString());
    adf = double.parse((json['adf'] ?? 0).toString());
    cp = double.parse((json['cp'] ?? 0).toString());
    de = double.parse((json['de'] ?? 0).toString());
    mj = double.parse((json['mj'] ?? 0).toString());
    rnd = double.parse((json['rnd'] ?? 0).toString());
    ca = double.parse((json['ca'] ?? 0).toString());
    p = double.parse((json['p'] ?? 0).toString());

    nEm = double.parse((json['nEm'] ?? 0).toString());
    nEg = double.parse((json['nEg'] ?? 0).toString());
    mp = double.parse((json['mp'] ?? 0).toString());
    price = double.parse((json['price'] ?? 0).toString());
    variable = json['variable'];
    correlation = json['correlation'];
    referenceValues = double.parse((json['referenceValues'] ?? 0).toString());
    ruleCode = json['ruleCode'];
    ruleRemark = json['ruleRemark'];

    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formulaId'] = formulaId;
    data['id'] = id;
    data['demand'] = demand;
    data['weight'] = weight;
    data['type'] = type;
    data['name'] = name;
    data['code'] = code;
    data['dm'] = dm;
    data['ash'] = ash;
    data['starch'] = starch;
    data['fat'] = fat;
    data['fibre'] = fibre;
    data['ndf'] = ndf;
    data['adf'] = adf;
    data['cp'] = cp;
    data['de'] = de;
    data['mj'] = mj;
    data['rnd'] = rnd;
    data['ca'] = ca;
    data['p'] = p;

    data['nEm'] = nEm;
    data['nEg'] = nEg;
    data['mp'] = mp;
    data['price'] = price;
    data['variable'] = variable;
    data['correlation'] = correlation;
    data['referenceValues'] = referenceValues;
    data['ruleCode'] = ruleCode;
    data['ruleRemark'] = ruleRemark;

    data['remark'] = remark;
    return data;
  }
}
