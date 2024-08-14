import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/events/breed_assess/bindings/breed_assess_binding.dart';
import 'package:intellectual_breed/app/modules/events/breed_assess/views/breed_assess_view.dart';
import 'package:intellectual_breed/app/modules/events_detail/breed_assess_detail/views/breed_assess_detail_view.dart';
import 'package:intellectual_breed/app/modules/material_management/collect/bindings/collect_bindings.dart';
import 'package:intellectual_breed/app/modules/material_management/collect/view/collect_view.dart';
import 'package:intellectual_breed/app/modules/material_management/material_scrap/bindings/material_scrap_bindings.dart';
import 'package:intellectual_breed/app/modules/material_management/material_scrap/view/material_scrap_view.dart';
import 'package:intellectual_breed/app/modules/material_management/take_inventory/bindings/take_inventory_bindings.dart';
import 'package:intellectual_breed/app/modules/material_management/take_inventory/view/take_inventory_view.dart';
import 'package:intellectual_breed/app/modules/material_management/warehouse_entry/bindings/warehouse_entry_binding.dart';
import 'package:intellectual_breed/app/modules/material_management/warehouse_entry/view/add_inventory.dart';
import 'package:intellectual_breed/app/modules/material_management/warehouse_entry/view/warehouse_entry_view.dart';
import 'package:intellectual_breed/app/modules/message/Production_Guide/bindings/production_guide_binding.dart';

import '../modules/about_us/bindings/about_us_binding.dart';
import '../modules/about_us/views/about_us_view.dart';
import '../modules/application/views/application_view.dart';
import '../modules/batch_detail/bindings/batch_detail_binding.dart';
import '../modules/batch_detail/views/batch_detail_view.dart';
import '../modules/batch_list/bindings/batch_list_binding.dart';
import '../modules/batch_list/views/batch_list_view.dart';
import '../modules/cattle_detail/bindings/cattle_detail_binding.dart';
import '../modules/cattle_detail/breeding_info/bindings/breeding_info_binding.dart';
import '../modules/cattle_detail/breeding_info/views/breeding_info_view.dart';
import '../modules/cattle_detail/views/cattle_detail_view.dart';
import '../modules/cattle_edit/bindings/cattle_edit_binding.dart';
import '../modules/cattle_edit/views/cattle_edit_view.dart';
import '../modules/cattle_house/add_cattle_house/bindings/add_cattle_house_binding.dart';
import '../modules/cattle_house/add_cattle_house/views/add_cattle_house_view.dart';
import '../modules/cattle_house/cattle_house_list/bindings/cattle_house_list_binding.dart';
import '../modules/cattle_house/cattle_house_list/views/cattle_house_list_view.dart';
import '../modules/cattlelist/bindings/cattle_list_binding.dart';
import '../modules/cattlelist/views/cattle_list_view.dart';
import '../modules/event_list/bindings/event_list_binding.dart';
import '../modules/event_list/views/event_list_view.dart';
import '../modules/events/allot_cattle/bindings/allot_cattle_binding.dart';
import '../modules/events/allot_cattle/views/allot_cattle_view.dart';
import '../modules/events/assay/bindings/assay_binding.dart';
import '../modules/events/assay/views/assay_view.dart';
import '../modules/events/assessment/bindings/assessment_binding.dart';
import '../modules/events/assessment/views/assessment_view.dart';
import '../modules/events/ban/bindings/ban_binding.dart';
import '../modules/events/ban/views/ban_view.dart';
import '../modules/events/body_assess/bindings/body_assess_binding.dart';
import '../modules/events/body_assess/views/body_assess_view.dart';
import '../modules/events/breed_value/bindings/breed_value_binding.dart';
import '../modules/events/breed_value/views/breed_value_view.dart';
import '../modules/events/buy_in/bindings/buy_in_binding.dart';
import '../modules/events/buy_in/views/buy_in_view.dart';
import '../modules/events/calv/bindings/calv_binding.dart';
import '../modules/events/calv/views/calv_view.dart';
import '../modules/events/change_group/bindings/change_group_binding.dart';
import '../modules/events/change_group/views/change_group_view.dart';
import '../modules/events/characters/bindings/characters_binding.dart';
import '../modules/events/characters/views/characters_view.dart';
import '../modules/events/check_cattle/bindings/check_cattle_binding.dart';
import '../modules/events/check_cattle/views/check_cattle_view.dart';
import '../modules/events/descendants/bindings/descendants_binding.dart';
import '../modules/events/descendants/views/descendants_view.dart';
import '../modules/events/die_cattle/bindings/die_cattle_binding.dart';
import '../modules/events/die_cattle/views/die_cattle_view.dart';
import '../modules/events/environment_assess/bindings/environment_assess_binding.dart';
import '../modules/events/environment_assess/views/environment_assess_view.dart';
import '../modules/events/event_cattle_list/bindings/event_cattle_list_binding.dart';
import '../modules/events/event_cattle_list/views/event_cattle_list_view.dart';
import '../modules/events/feed_cattle/bindings/feed_cattle_binding.dart';
import '../modules/events/feed_cattle/views/feed_cattle_view.dart';
import '../modules/events/health_assess/bindings/health_assess_binding.dart';
import '../modules/events/health_assess/views/health_assess_view.dart';
import '../modules/events/health_care/bindings/health_care_binding.dart';
import '../modules/events/health_care/views/health_care_view.dart';
import '../modules/events/inbreeding/bindings/inbreeding_binding.dart';
import '../modules/events/inbreeding/views/inbreeding_view.dart';
import '../modules/events/inherent/bindings/inherent_binding.dart';
import '../modules/events/inherent/views/inherent_view.dart';
import '../modules/events/knock_out/bindings/knock_out_binding.dart';
import '../modules/events/knock_out/views/knock_out_view.dart';
import '../modules/events/manual_assess/bindings/manual_assess_binding.dart';
import '../modules/events/manual_assess/views/manual_assess_view.dart';
import '../modules/events/mating/bindings/mating_binding.dart';
import '../modules/events/mating/views/mating_view.dart';
import '../modules/events/measurement/bindings/measurement_binding.dart';
import '../modules/events/measurement/views/measurement_view.dart';
import '../modules/events/new_cattle/bindings/new_cattle_binding.dart';
import '../modules/events/new_cattle/views/new_cattle_view.dart';
import '../modules/events/pregcy/bindings/pregcy_binding.dart';
import '../modules/events/pregcy/views/pregcy_view.dart';
import '../modules/events/prevention/bindings/prevention_binding.dart';
import '../modules/events/prevention/views/prevention_view.dart';
import '../modules/events/purchase_assess/bindings/purchase_assess_binding.dart';
import '../modules/events/purchase_assess/views/purchase_assess_view.dart';
import '../modules/events/rut/bindings/rut_binding.dart';
import '../modules/events/rut/views/rut_view.dart';
import '../modules/events/sales_assess/bindings/sales_assess_binding.dart';
import '../modules/events/sales_assess/views/sales_assess_view.dart';
import '../modules/events/select_cattle/bindings/select_cattle_binding.dart';
import '../modules/events/select_cattle/views/select_cattle_view.dart';
import '../modules/events/sell_cattle/bindings/sell_cattle_binding.dart';
import '../modules/events/sell_cattle/views/sell_cattle_view.dart';
import '../modules/events/semen/bindings/semen_binding.dart';
import '../modules/events/semen/views/semen_view.dart';
import '../modules/events/treatment/bindings/treatment_binding.dart';
import '../modules/events/treatment/views/treatment_view.dart';
import '../modules/events/unBan/bindings/un_ban_binding.dart';
import '../modules/events/unBan/views/un_ban_view.dart';
import '../modules/events/wean/bindings/wean_binding.dart';
import '../modules/events/wean/views/wean_view.dart';
import '../modules/events_detail/allot_cattle_detail/bindings/allot_cattle_detail_binding.dart';
import '../modules/events_detail/allot_cattle_detail/views/allot_cattle_detail_view.dart';
import '../modules/events_detail/assay_detail/bindings/assay_detail_binding.dart';
import '../modules/events_detail/assay_detail/views/assay_detail_view.dart';
import '../modules/events_detail/assessment_detail/bindings/assessment_detail_binding.dart';
import '../modules/events_detail/assessment_detail/views/assessment_detail_view.dart';
import '../modules/events_detail/ban_detail/bindings/ban_detail_binding.dart';
import '../modules/events_detail/ban_detail/views/ban_detail_view.dart';
import '../modules/events_detail/body_assess_detail/bindings/body_assess_detail_binding.dart';
import '../modules/events_detail/body_assess_detail/views/body_assess_detail_view.dart';
import '../modules/events_detail/breed_assess_detail/bindings/breed_assess_detail_binding.dart';
import '../modules/events_detail/breed_value_detail/bindings/breed_value_detail_binding.dart';
import '../modules/events_detail/breed_value_detail/views/breed_value_detail_view.dart';
import '../modules/events_detail/buy_in_detail/bindings/buy_in_detail_binding.dart';
import '../modules/events_detail/buy_in_detail/views/buy_in_detail_view.dart';
import '../modules/events_detail/calv_detail/bindings/calv_detail_binding.dart';
import '../modules/events_detail/calv_detail/views/calv_detail_view.dart';
import '../modules/events_detail/change_group_detail/bindings/change_group_detail_binding.dart';
import '../modules/events_detail/change_group_detail/views/change_group_detail_view.dart';
import '../modules/events_detail/characters_detail/bindings/characters_detail_binding.dart';
import '../modules/events_detail/characters_detail/views/characters_detail_view.dart';
import '../modules/events_detail/check_cattle_detail/bindings/check_cattle_detail_binding.dart';
import '../modules/events_detail/check_cattle_detail/views/check_cattle_detail_view.dart';
import '../modules/events_detail/descendants_detail/bindings/descendants_detail_binding.dart';
import '../modules/events_detail/descendants_detail/views/descendants_detail_view.dart';
import '../modules/events_detail/die_cattle_detail/bindings/die_cattle_detail_binding.dart';
import '../modules/events_detail/die_cattle_detail/views/die_cattle_detail_view.dart';
import '../modules/events_detail/environment_assess_detail/bindings/environment_assess_detail_binding.dart';
import '../modules/events_detail/environment_assess_detail/views/environment_assess_detail_view.dart';
import '../modules/events_detail/feed_cattle_detail/bindings/feed_cattle_detail_binding.dart';
import '../modules/events_detail/feed_cattle_detail/views/feed_cattle_detail_view.dart';
import '../modules/events_detail/health_assess_detail/bindings/health_assess_detail_binding.dart';
import '../modules/events_detail/health_assess_detail/views/health_assess_detail_view.dart';
import '../modules/events_detail/health_care_detail/bindings/health_care_detail_binding.dart';
import '../modules/events_detail/health_care_detail/views/health_care_detail_view.dart';
import '../modules/events_detail/inbreeding_details/bindings/inbreeding_details_binding.dart';
import '../modules/events_detail/inbreeding_details/views/inbreeding_details_view.dart';
import '../modules/events_detail/inherent_detail/bindings/inherent_detail_binding.dart';
import '../modules/events_detail/inherent_detail/views/inherent_detail_view.dart';
import '../modules/events_detail/knock_out_detail/bindings/knock_out_detail_binding.dart';
import '../modules/events_detail/knock_out_detail/views/knock_out_detail_view.dart';
import '../modules/events_detail/manual_assess_detail/bindings/manual_assess_detail_binding.dart';
import '../modules/events_detail/manual_assess_detail/views/manual_assess_detail_view.dart';
import '../modules/events_detail/mating_detail/bindings/mating_detail_binding.dart';
import '../modules/events_detail/mating_detail/views/mating_detail_view.dart';
import '../modules/events_detail/measurement_detail/bindings/measurement_detail_binding.dart';
import '../modules/events_detail/measurement_detail/views/measurement_detail_view.dart';
import '../modules/events_detail/pregcy_detail/bindings/pregcy_detail_binding.dart';
import '../modules/events_detail/pregcy_detail/views/pregcy_detail_view.dart';
import '../modules/events_detail/prevention_detail/bindings/prevention_detail_binding.dart';
import '../modules/events_detail/prevention_detail/views/prevention_detail_view.dart';
import '../modules/events_detail/purchase_assess_detail/bindings/purchase_assess_detail_binding.dart';
import '../modules/events_detail/purchase_assess_detail/views/purchase_assess_detail_view.dart';
import '../modules/events_detail/rut_detail/bindings/rut_detail_binding.dart';
import '../modules/events_detail/rut_detail/views/rut_detail_view.dart';
import '../modules/events_detail/sales_assess_detail/bindings/sales_assess_detail_binding.dart';
import '../modules/events_detail/sales_assess_detail/views/sales_assess_detail_view.dart';
import '../modules/events_detail/select_cattle_detail/bindings/select_cattle_detail_binding.dart';
import '../modules/events_detail/select_cattle_detail/views/select_cattle_detail_view.dart';
import '../modules/events_detail/sell_cattle_detail/bindings/sell_cattle_detail_binding.dart';
import '../modules/events_detail/sell_cattle_detail/views/sell_cattle_detail_view.dart';
import '../modules/events_detail/semen_detail/bindings/semen_detail_binding.dart';
import '../modules/events_detail/semen_detail/views/semen_detail_view.dart';
import '../modules/events_detail/treatment_detail/bindings/treatment_detail_binding.dart';
import '../modules/events_detail/treatment_detail/views/treatment_detail_view.dart';
import '../modules/events_detail/unBan_detail/bindings/un_ban_detail_binding.dart';
import '../modules/events_detail/unBan_detail/views/un_ban_detail_view.dart';
import '../modules/events_detail/wean_detail/bindings/wean_detail_binding.dart';
import '../modules/events_detail/wean_detail/views/wean_detail_view.dart';
import '../modules/feed_back/bindings/feed_back_binding.dart';
import '../modules/feed_back/views/feed_back_view.dart';
import '../modules/home/informationDetail/bindings/information_detail_binding.dart';
import '../modules/home/informationDetail/views/information_detail_view.dart';
import '../modules/home/information_list/bindings/information_list_binding.dart';
import '../modules/home/information_list/views/information_list_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/like_article_list/bindings/like_article_list_binding.dart';
import '../modules/like_article_list/views/like_article_list_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/map_location/bindings/map_location_binding.dart';
import '../modules/map_location/views/map_location_view.dart';
import '../modules/message/Production_Guide/views/production_guide_view.dart';
import '../modules/message/action_message_list/bindings/action_message_list_binding.dart';
import '../modules/message/action_message_list/views/action_message_list_view.dart';
import '../modules/message/message_detail/bindings/message_detail_binding.dart';
import '../modules/message/message_detail/views/message_detail_view.dart';
import '../modules/message/views/message_view.dart';
import '../modules/mine/views/mine_view.dart';
import '../modules/new_batch/bindings/new_batch_binding.dart';
import '../modules/new_batch/views/new_batch_view.dart';
import '../modules/recipe/views/recipe_view.dart';
import '../modules/recipe_create/bindings/recipe_create_binding.dart';
import '../modules/recipe_create/views/recipe_create_view.dart';
import '../modules/recipe_detail/bindings/recipe_detail_binding.dart';
import '../modules/recipe_detail/views/recipe_detail_view.dart';
import '../modules/record_center/bindings/record_center_binding.dart';
import '../modules/record_center/views/record_center_view.dart';
import '../modules/tabs/bindings/tabs_binding.dart';
import '../modules/tabs/views/tabs_view.dart';
import '../modules/user_profile/bindings/user_profile_binding.dart';
import '../modules/user_profile/views/user_profile_view.dart';
import '../services/login_middleware.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TABS;

  static final routes = [
    GetPage(
      name: _Paths.TABS,
      page: () => const TabsView(),
      binding: TabsBinding(),
    ),
    GetPage(
      name: _Paths.APPLICATION,
      page: () => ApplicationView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      page: () => MessageView(),
    ),
    GetPage(
      name: _Paths.RECIPE,
      page: () => RecipeView(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.MINE,
      page: () => MineView(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.INFORMATION_LIST,
      page: () => const InformationListView(),
      binding: InformationListBinding(),
    ),
    GetPage(
      name: _Paths.CATTLELIST,
      page: () => const CattleListView(),
      binding: CattleListBinding(),
      fullscreenDialog: true,
      //移除黑边问题
      transition: Transition.downToUp,
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.INFORMATION_DETAIL,
      page: () => const InformationDetailView(),
      binding: InformationDetailBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      fullscreenDialog: true,
      //移除黑边问题
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.CATTLE_DETAIL,
      page: () => const CattleDetailView(),
      binding: CattleDetailBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.BUY_IN,
      page: () => const BuyInView(),
      binding: BuyInBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.NEW_CATTLE,
      page: () => const NewCattleView(),
      binding: NewCattleBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.SELECT_CATTLE,
      page: () => const SelectCattleView(),
      binding: SelectCattleBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.ALLOT_CATTLE,
      page: () => const AllotCattleView(),
      binding: AllotCattleBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.CHANGE_GROUP,
      page: () => const ChangeGroupView(),
      binding: ChangeGroupBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.KNOCK_OUT,
      page: () => const KnockOutView(),
      binding: KnockOutBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.DIE_CATTLE,
      page: () => const DieCattleView(),
      binding: DieCattleBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.SELL_CATTLE,
      page: () => const SellCattleView(),
      binding: SellCattleBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.CHECK_CATTLE,
      page: () => const CheckCattleView(),
      binding: CheckCattleBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.FEED_CATTLE,
      page: () => const FeedCattleView(),
      binding: FeedCattleBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.BATCH_LIST,
      page: () => const BatchListView(),
      binding: BatchListBinding(),
      fullscreenDialog: true,
      //移除黑边问题
      transition: Transition.downToUp,
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.SEMEN,
      page: () => const SemenView(),
      binding: SemenBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.RUT,
      page: () => const RutView(),
      binding: RutBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.BAN,
      page: () => const BanView(),
      binding: BanBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.UN_BAN,
      page: () => const UnBanView(),
      binding: UnBanBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.MATING,
      page: () => const MatingView(),
      binding: MatingBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.PREGCY,
      page: () => const PregcyView(),
      binding: PregcyBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.CALV,
      page: () => const CalvView(),
      binding: CalvBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.WEAN,
      page: () => const WeanView(),
      binding: WeanBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.PREVENTION,
      page: () => const PreventionView(),
      binding: PreventionBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.TREATMENT,
      page: () => const TreatmentView(),
      binding: TreatmentBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.HEALTH_CARE,
      page: () => const HealthCareView(),
      binding: HealthCareBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.EVENT_CATTLE_LIST,
      page: () => const EventCattleListView(),
      binding: EventCattleListBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.MESSAGE_DETAIL,
      page: () => const MessageDetailView(),
      binding: MessageDetailBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_LIST,
      page: () => const EventListView(),
      binding: EventListBinding(),
    ),
    GetPage(
      name: _Paths.ACTION_MESSAGE_LIST,
      page: () => const ActionMessageListView(),
      binding: ActionMessageListBinding(),
    ),
    GetPage(
      name: _Paths.Production_Guide,
      page: () => const ProductionGuideView(),
      binding: ProductionGuideBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_US,
      page: () => const AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: _Paths.FEED_BACK,
      page: () => const FeedBackView(),
      binding: FeedBackBinding(),
    ),
    GetPage(
      name: _Paths.NEW_BATCH,
      page: () => const NewBatchView(),
      binding: NewBatchBinding(),
    ),
    GetPage(
      name: _Paths.RUT_DETAIL,
      page: () => const RutDetailView(),
      binding: RutDetailBinding(),
    ),
    GetPage(
      name: _Paths.SEMEN_DETAIL,
      page: () => const SemenDetailView(),
      binding: SemenDetailBinding(),
    ),
    GetPage(
      name: _Paths.WEAN_DETAIL,
      page: () => const WeanDetailView(),
      binding: WeanDetailBinding(),
    ),
    GetPage(
      name: _Paths.BAN_DETAIL,
      page: () => const BanDetailView(),
      binding: BanDetailBinding(),
    ),
    GetPage(
      name: _Paths.PREGCY_DETAIL,
      page: () => const PregcyDetailView(),
      binding: PregcyDetailBinding(),
    ),
    GetPage(
      name: _Paths.ALLOT_CATTLE_DETAIL,
      page: () => const AllotCattleDetailView(),
      binding: AllotCattleDetailBinding(),
    ),
    GetPage(
      name: _Paths.BUY_IN_DETAIL,
      page: () => const BuyInDetailView(),
      binding: BuyInDetailBinding(),
    ),
    GetPage(
      name: _Paths.CALV_DETAIL,
      page: () => const CalvDetailView(),
      binding: CalvDetailBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_GROUP_DETAIL,
      page: () => const ChangeGroupDetailView(),
      binding: ChangeGroupDetailBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_CATTLE_DETAIL,
      page: () => const CheckCattleDetailView(),
      binding: CheckCattleDetailBinding(),
      children: [
        GetPage(
          name: _Paths.BREEDING_INFO,
          page: () => const BreedingInfoView(),
          binding: BreedingInfoBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.DIE_CATTLE_DETAIL,
      page: () => const DieCattleDetailView(),
      binding: DieCattleDetailBinding(),
    ),
    GetPage(
      name: _Paths.FEED_CATTLE_DETAIL,
      page: () => const FeedCattleDetailView(),
      binding: FeedCattleDetailBinding(),
    ),
    GetPage(
      name: _Paths.HEALTH_CARE_DETAIL,
      page: () => const HealthCareDetailView(),
      binding: HealthCareDetailBinding(),
    ),
    GetPage(
      name: _Paths.KNOCK_OUT_DETAIL,
      page: () => const KnockOutDetailView(),
      binding: KnockOutDetailBinding(),
    ),
    GetPage(
      name: _Paths.MATING_DETAIL,
      page: () => const MatingDetailView(),
      binding: MatingDetailBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_CATTLE_DETAIL,
      page: () => const SelectCattleDetailView(),
      binding: SelectCattleDetailBinding(),
    ),
    GetPage(
      name: _Paths.UN_BAN_DETAIL,
      page: () => const UnBanDetailView(),
      binding: UnBanDetailBinding(),
    ),
    GetPage(
      name: _Paths.PREVENTION_DETAIL,
      page: () => const PreventionDetailView(),
      binding: PreventionDetailBinding(),
    ),
    GetPage(
      name: _Paths.TREATMENT_DETAIL,
      page: () => const TreatmentDetailView(),
      binding: TreatmentDetailBinding(),
    ),
    GetPage(
      name: _Paths.SELL_CATTLE_DETAIL,
      page: () => const SellCattleDetailView(),
      binding: SellCattleDetailBinding(),
    ),
    GetPage(
      name: _Paths.CATTLE_HOUSE_LIST,
      page: () => const CattleHouseListView(),
      binding: CattleHouseListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CATTLE_HOUSE,
      page: () => const AddCattleHouseView(),
      binding: AddCattleHouseBinding(),
    ),
    GetPage(
      name: _Paths.LIKE_ARTICLE_LIST,
      page: () => const LikeArticleListView(),
      binding: LikeArticleListBinding(),
    ),
    GetPage(
      name: _Paths.RECIPE_DETAIL,
      page: () => const RecipeDetailView(),
      binding: RecipeDetailBinding(),
    ),
    GetPage(
      name: _Paths.RECIPE_CREATE,
      page: () => const RecipeCreateView(),
      binding: RecipeCreateBinding(),
    ),
    GetPage(
      name: _Paths.CATTLE_EDIT,
      page: () => const CattleEditView(),
      binding: CattleEditBinding(),
    ),
    GetPage(
      name: _Paths.BATCH_DETAIL,
      page: () => const BatchDetailView(),
      binding: BatchDetailBinding(),
    ),
    GetPage(
      name: _Paths.USER_PROFILE,
      page: () => const UserProfileView(),
      binding: UserProfileBinding(),
      middlewares: [LoginMiddleware()],
    ),
    GetPage(
      name: _Paths.MAP_LOCATION,
      page: () => const MapLocationView(),
      binding: MapLocationBinding(),
    ),
    GetPage(
      name: _Paths.RECORD_CENTER,
      page: () => const RecordCenterView(),
      binding: RecordCenterBinding(),
    ),
    GetPage(
      name: _Paths.DESCENDANTS,
      page: () => const DescendantsView(),
      binding: DescendantsBinding(),
    ),
    GetPage(
      name: _Paths.MEASUREMENT,
      page: () => const MeasurementView(),
      binding: MeasurementBinding(),
    ),
    GetPage(
      name: _Paths.ASSESSMENT,
      page: () => const AssessmentView(),
      binding: AssessmentBinding(),
    ),
    GetPage(
      name: _Paths.INHERENT,
      page: () => const InherentView(),
      binding: InherentBinding(),
    ),
    GetPage(
      name: _Paths.ASSESSMENT_DETAIL,
      page: () => const AssessmentDetailView(),
      binding: AssessmentDetailBinding(),
    ),
    GetPage(
      name: _Paths.DESCENDANTS_DETAIL,
      page: () => const DescendantsDetailView(),
      binding: DescendantsDetailBinding(),
    ),
    GetPage(
      name: _Paths.MEASUREMENT_DETAIL,
      page: () => const MeasurementDetailView(),
      binding: MeasurementDetailBinding(),
    ),
    GetPage(
      name: _Paths.INHERENT_DETAIL,
      page: () => const InherentDetailView(),
      binding: InherentDetailBinding(),
    ),
    GetPage(
      name: _Paths.INBREEDING,
      page: () => const InbreedingView(),
      binding: InbreedingBinding(),
    ),
    GetPage(
      name: _Paths.INBREEDING_DETAILS,
      page: () => const InbreedingDetailsView(),
      binding: InbreedingDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CHARACTERS,
      page: () => const CharactersView(),
      binding: CharactersBinding(),
    ),
    GetPage(
      name: _Paths.ASSAY,
      page: () => const AssayView(),
      binding: AssayBinding(),
    ),
    GetPage(
      name: _Paths.ASSAY_DETAIL,
      page: () => const AssayDetailView(),
      binding: AssayDetailBinding(),
    ),
    GetPage(
      name: _Paths.CHARACTERS_DETAIL,
      page: () => const CharactersDetailView(),
      binding: CharactersDetailBinding(),
    ),
    GetPage(
      name: _Paths.BREED_VALUE,
      page: () => const BreedValueView(),
      binding: BreedValueBinding(),
    ),
    GetPage(
      name: _Paths.BREED_VALUE_DETAIL,
      page: () => const BreedValueDetailView(),
      binding: BreedValueDetailBinding(),
    ),
    //体况评估
    GetPage(
      name: _Paths.BODY_ASSESS,
      page: () => const BodyAssessView(),
      binding: BodyAssessBinding(),
    ),
    //体况评估详情
    GetPage(
      name: _Paths.BODY_ASSESS_DETAIL,
      page: () => const BodyAssessDetailView(),
      binding: BodyAssessDetailBinding(),
    ),
    //繁殖评估
    GetPage(
      name: _Paths.BREED_ASSESS,
      page: () => const BreedAssessView(),
      binding: BreedAssessBinding(),
    ),
    //繁殖评估详情
    GetPage(
      name: _Paths.BREED_ASSESS_DETAIL,
      page: () => const BreedAssessDetailView(),
      binding: BreedAssessDetailBinding(),
    ),
    //健康评估
    GetPage(
      name: _Paths.HEALTH_ASSESS,
      page: () => const HealthAssessView(),
      binding: HealthAssessBinding(),
    ),
    //健康评估详情
    GetPage(
      name: _Paths.HEALTH_ASSESS_DETAIL,
      page: () => const HealthAssessDetailView(),
      binding: HealthAssessDetailBinding(),
    ),
    //环境评估
    GetPage(
      name: _Paths.ENVIRONMENT_ASSESS,
      page: () => const EnvironmentAssessView(),
      binding: EnvironmentAssessBinding(),
    ),
    //环境评估详情
    GetPage(
      name: _Paths.ENVIRONMENT_ASSESS_DETAIL,
      page: () => const EnvironmentAssessDetailView(),
      binding: EnvironmentAssessDetailBinding(),
    ),
    //采购评估
    GetPage(
      name: _Paths.PURCHASE_ASSESS,
      page: () => const PurchaseAssessView(),
      binding: PurchaseAssessBinding(),
    ),
    //采购评估详情
    GetPage(
      name: _Paths.PURCHASE_ASSESS_DETAIL,
      page: () => const PurchaseAssessDetailView(),
      binding: PurchaseAssessDetailBinding(),
    ),
    //人工评估
    GetPage(
      name: _Paths.MANUAL_ASSESS,
      page: () => const ManualAssessView(),
      binding: ManualAssessBinding(),
    ),
    //人工评估详情
    GetPage(
      name: _Paths.MANUAL_ASSESS_DETAIL,
      page: () => const ManualAssessDetailView(),
      binding: ManualAssessDetailBinding(),
    ),
    //销售评估
    GetPage(
      name: _Paths.SALES_ASSESS,
      page: () => const SalesAssessView(),
      binding: SalesAssessBinding(),
    ),
    //销售评估详情
    GetPage(
      name: _Paths.SALES_ASSESS_DETAIL,
      page: () => const SalesAssessDetailView(),
      binding: SalesAssessDetailBinding(),
    ),
    GetPage(
      name: _Paths.Warehouse_Entry,
      page: () => const WarehouseEntryView(),
      binding: WarehouseEntryBinding(),
    ),
    GetPage(
      name: _Paths.Collect,
      page: () => const CollectView(),
      binding: CollectBindings(),
    ),
    GetPage(
      name: _Paths.AddInventory,
      page: () => const AddInventoryView(),
    ),
    GetPage(
      name: _Paths.MaterialScrap,
      page: () => const MaterialScrapView(),
      binding: MaterialScrapBindings(),
    ),
    GetPage(
      name: _Paths.TakeInventory,
      page: () => const TakeInventoryView(),
      binding: TakeInventoryBindings(),
    ),
  ];
}
