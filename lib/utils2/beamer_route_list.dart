import 'package:beamer/beamer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smat_crow/features/domain/entities/app_entity.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/farm_assistant/views/pages/farm_assistant_base_ui.dart';
import 'package:smat_crow/features/farm_manager/views/farm_log.dart';
import 'package:smat_crow/features/farm_manager/views/farm_manager.dart';
import 'package:smat_crow/features/farm_manager/views/farm_manager_overview.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_details.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_log_details.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_agents_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_asset.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_log_additional_info.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_log_details_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_overview_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_site_view_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/finance_log.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/log_type_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/pending_invites.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_asset.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_farm_log.dart';
import 'package:smat_crow/features/farm_manager/views/web/asset_log_details_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_agents_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_asset_details_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_asset_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_log_additional_info_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_log_details_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_log_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_site_view.dart';
import 'package:smat_crow/features/farm_manager/views/web/finanace_log_details.dart';
import 'package:smat_crow/features/farm_manager/views/web/finance_log_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/full_log_table_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/log_type_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/register_asset_web.dart';
import 'package:smat_crow/features/farm_manager/views/web/register_farm_log_web.dart';
import 'package:smat_crow/features/institution/views/institution_dashboard.dart';
import 'package:smat_crow/features/institution/views/institution_organization.dart';
import 'package:smat_crow/features/institution/views/institution_settings.dart';
import 'package:smat_crow/features/institution/views/web/institution_org_site.dart';
import 'package:smat_crow/features/organisation/views/pages/organisation.dart';
import 'package:smat_crow/features/presentation/pages/credential/forget_password/forget_password.dart';
import 'package:smat_crow/features/presentation/pages/credential/reset_password/reset_page.dart';
import 'package:smat_crow/features/presentation/pages/home_page/screens/desktop/home_desktop.dart';
import 'package:smat_crow/features/presentation/pages/home_page/screens/mobile/home_page_mobile.dart';
import 'package:smat_crow/features/presentation/pages/home_page/screens/tablet/home_page_tablet.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/activity_grid_item.dart';
import 'package:smat_crow/features/presentation/pages/news/views/presentation/screens/news_page_animated_tab.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/comment_page.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/edit_comment_page.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/edit_reply_page.dart';
import 'package:smat_crow/features/presentation/pages/post/post_detail_page.dart';
import 'package:smat_crow/features/presentation/pages/post/update_post_page.dart';
import 'package:smat_crow/features/presentation/pages/post/upload_post_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/change_password.dart';
import 'package:smat_crow/features/presentation/pages/profile/edit_profile_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/profile_main_screen.dart';
import 'package:smat_crow/features/presentation/pages/profile/single_user_profile_page.dart';
import 'package:smat_crow/features/presentation/pages/search/search_page.dart';
import 'package:smat_crow/features/presentation/pages/socials/social_page.dart';
import 'package:smat_crow/features/presentation/pages/verify/verify_email.dart';
import 'package:smat_crow/features/shared/views/dashboard_view_web.dart';
import 'package:smat_crow/screens/fieldagents/pages/create_soil_samples_page.dart';
import 'package:smat_crow/screens/fieldagents/pages/field_measurement_page.dart';
import 'package:smat_crow/screens/fieldagents/pages/plant_database_page.dart';
import 'package:smat_crow/screens/fieldagents/pages/plant_details_page.dart';
import 'package:smat_crow/screens/home/pages/smat_ml_page.dart';
import 'package:smat_crow/screens/home/widgets/smatml/analysis_details_page.dart';
import 'package:smat_crow/screens/subscription/subscription_plan_list_view.dart';
import 'package:smat_crow/screens/subscription/subscription_plan_view.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';

class Routes {
  static final routing = <Pattern, dynamic Function(BuildContext, BeamState, Object?)>{
    ConfigRoute.organization: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
      return BeamPage(
        child: const Organization(),
        popToNamed: ConfigRoute.homeDashborad,
        key: ValueKey("organization - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.uploadPost: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPLOAD_POST_SCREEN');
      return BeamPage(
        child: const UploadPostPage(),
        key: ValueKey("upload-post - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.searchPage: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SEARCH_SCREEN');
      return BeamPage(
        child: const SearchPage(),
        key: ValueKey("search - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.editProfilePage: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'EDIT_PROFILE_SCREEN');
      return BeamPage(
        child: const EditProfilePage(),
        key: ValueKey("editProfile - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.updatePostPage: (BuildContext context, BeamState state, Object? data) {
      if (data is PostEntity) {
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPDATE_POST_SCREEN');
        return BeamPage(
          child: UpdatePostPage(
            post: data,
          ),
          key: ValueKey("editProfile - ${DateTime.now()}"),
          type: BeamPageType.noTransition,
        );
      } else {
        return const NoPageFound();
      }
    },
    ConfigRoute.updateCommentPage: (BuildContext context, BeamState state, Object? data) {
      if (data is CommentEntity) {
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPDATE_COMMENT_SCREEN');
        return BeamPage(
          child: EditCommentPage(
            comment: data,
          ),
          key: ValueKey("editProfile - ${DateTime.now()}"),
          type: BeamPageType.noTransition,
        );
      } else {
        return const NoPageFound();
      }
    },
    ConfigRoute.updateReplyPage: (BuildContext context, BeamState state, Object? data) {
      if (data is ReplyEntity) {
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPDATE_REPLY_SCREEN');
        return BeamPage(
          child: EditReplyPage(
            reply: data,
          ),
          key: ValueKey("editProfile - ${DateTime.now()}"),
          type: BeamPageType.noTransition,
        );
      } else {
        return const NoPageFound();
      }
    },
    ConfigRoute.commentPage: (BuildContext context, BeamState state, Object? data) {
      if (data is AppEntity) {
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'POST_DETAIL_SCREEN');
        return BeamPage(
          child: CommentPage(
            appEntity: data,
          ),
          key: ValueKey("edit-Profile - ${DateTime.now()}"),
          type: BeamPageType.noTransition,
        );
      } else {
        return const NoPageFound();
      }
    },
    ConfigRoute.postDetailPage: (BuildContext context, BeamState state, Object? data) {
      if (data is String) {
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'POST_DETAIL_SCREEN');
        return BeamPage(
          child: PostDetailPage(
            postId: data,
          ),
          key: ValueKey("edit-Profile - ${DateTime.now()}"),
          type: BeamPageType.noTransition,
        );
      } else {
        return const NoPageFound();
      }
    },
    ConfigRoute.singleUserProfilePage: (BuildContext context, BeamState state, Object? data) {
      if (data is String) {
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SINGLE_USER_PROFILE_SCREEN');
        return BeamPage(
          child: SingleUserProfilePage(
            otherUserId: data,
          ),
          key: ValueKey("editProfile - ${DateTime.now()}"),
          type: BeamPageType.noTransition,
        );
      } else {
        return const NoPageFound();
      }
    },
    ConfigRoute.farmManager: (BuildContext context, BeamState state, Object? data) {
      return BeamPage(
        child: const FarmManager(),
        popToNamed: ConfigRoute.homeDashborad,
        key: ValueKey("FarmManager-${DateTime.now()}"),
      );
    },
    "${ConfigRoute.farmManagerSiteView}?orgId=:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_SITE_VIEW_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: FarmSiteView(),
          mobile: FarmSiteViewMobile(),
          tablet: FarmSiteViewMobile(),
        ),
        key: ValueKey("FarmSiteView - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.farmManagerOverview}/:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_MANAGER_DETAILS_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: FarmManagerOverview(),
          mobile: FarmOverviewMobile(),
          tablet: FarmOverviewMobile(),
        ),
        popToNamed: "${ConfigRoute.farmManagerSiteView}?orgId=:id",
        key: ValueKey("FarmManagerOverview - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.farmAsset}/:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_MANAGER_DETAILS_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: FarmAssetWeb(),
          mobile: FarmAssetMobile(),
          tablet: FarmAssetMobile(),
        ),
        name: "FarmAssetWeb",
        popToNamed: "${ConfigRoute.farmManagerOverview}/:id",
        key: ValueKey("FarmAssetWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.assetDetails}/:id?assetId:ids": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_DETAILS_SCREEN');

      return BeamPage(
        child: Responsive(
          desktop: const FarmAssetDetailsWeb(),
          tablet: AssetDetails(id: state.uri.pathSegments.last),
          mobile: AssetDetails(id: state.uri.pathSegments.last),
        ),
        popToNamed: "${ConfigRoute.farmAsset}/:id",
        key: ValueKey("FarmAssetDetailsWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.assetLogDetails}/:id?logTypeName=:type": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_DETAILS_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: AssetLogDetailsWeb(),
          mobile: AssetLogDetails(),
          tablet: AssetLogDetails(),
        ),
        popToNamed: ConfigRoute.farmAsset,
        key: ValueKey("AssetLogDetailsWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.farmLogDetails}/:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_LOG_DETAILS_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: FarmLogDetailsWeb(),
          mobile: FarmLogDetailsMobile(),
          tablet: FarmLogDetailsMobile(),
        ),
        popToNamed: "${ConfigRoute.farmLogType}/:id?logTypeName=:type",
        key: ValueKey("FarmLogDetailsWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.farmLog}/:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_LOG_DETAILS_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: FarmLogWeb(),
          mobile: FarmLog(),
          tablet: FarmLog(),
        ),
        popToNamed: "${ConfigRoute.farmLogDetails}/:id",
        key: ValueKey("FarmLogWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.farmLogType}/:id?logTypeName=:type": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_DETAILS_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: LogTypeWeb(),
          mobile: LogTypeMobile(),
          tablet: LogTypeMobile(),
        ),
        popToNamed: "${ConfigRoute.farmLog}/:id",
        key: ValueKey("LogTypeWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.farmLogTable}/:id?logTypeName=:type&logStatusName=:status":
        (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_DETAILS_SCREEN');
      return BeamPage(
        child: const FullLogTableWeb(),
        popToNamed: "${ConfigRoute.farmLogType}/:id?logTypeName=:type",
        key: ValueKey("FullLogTableWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.financeLog}/:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_DETAILS_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: FinanceLogWeb(),
          tablet: FinanceLogMobile(),
          mobile: FinanceLogMobile(),
        ),
        popToNamed: "${ConfigRoute.farmManagerOverview}/:id",
        key: ValueKey("FinanceLogWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.financeLogDetails}/:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_LOG_DETAILS_SCREEN');
      return BeamPage(
        child: const FinanceLogDetailsWeb(),
        popToNamed: "${ConfigRoute.financeLog}/:id",
        key: ValueKey("FinanceLogDetailsWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.subscriptionPlanView: (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SubscriptionPlanView_SCREEN');
      return BeamPage(
        popToNamed: ConfigRoute.mainPage,
        child: const SubscriptionPlanView(),
        key: ValueKey("SubscriptionPlanView - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.subscriptionPlanListView: (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SubscriptionPlanListView_SCREEN');
      return BeamPage(
        child: const SubscriptionPlanListView(),
        key: ValueKey("SubscriptionPlanListView - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
        popToNamed: ConfigRoute.mainPage,
      );
    },
    "${ConfigRoute.farmAgent}/:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_AGENT_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: FarmAgentWeb(),
          mobile: FarmAgentMobile(),
          tablet: FarmAgentMobile(),
        ),
        popToNamed: "${ConfigRoute.farmManagerOverview}/:id",
        key: ValueKey("${ConfigRoute.farmAgent} - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.registerFarmLog: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'REGISTER_FARM_LOG_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: RegisterFarmLogWeb(),
          tablet: RegisterFarmLog(),
          mobile: RegisterFarmLog(),
        ),
        popToNamed: "${ConfigRoute.farmManagerOverview}/:id",
        key: ValueKey("RegisterFarmLogWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.registerAsset: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'REGISTER_FARM_ASSET_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: RegisterAssetWeb(),
          tablet: RegisterAsset(),
          mobile: RegisterAsset(),
        ),
        popToNamed: "${ConfigRoute.farmManagerOverview}/:id",
        key: ValueKey("RegisterFarmLogWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.registerAsset}?assetId=:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'REGISTER_FARM_ASSET_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: RegisterAssetWeb(),
          tablet: RegisterAsset(),
          mobile: RegisterAsset(),
        ),
        popToNamed: "${ConfigRoute.farmManagerOverview}/:id",
        key: ValueKey("UpdateFarmLogWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.farmLogAddInfo}/:id": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'REGISTER_FARM_LOG_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: FarmLogAdditionalInfoWeb(),
          mobile: FarmLogAdditionalInfo(),
          tablet: FarmLogAdditionalInfo(),
        ),
        popToNamed: "${ConfigRoute.registerFarmLog}/:id",
        key: ValueKey("FarmLogAdditionalInfoWeb - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.resetPasswordPage: (context, state, data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNUP_SCREEN');
      return const BeamPage(
        child: ResetPasswordPage(),
        key: ValueKey("Reset-Password"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.verifyEmailPage: (context, state, data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNUP_SCREEN');
      return const BeamPage(
        child: VerifyEmail(),
        key: ValueKey("Verify-Email"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.userForgetPassword: (context, state, data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNUP_SCREEN');
      return const BeamPage(
        child: ForgetPassword(),
        key: ValueKey("Forget-Password"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.pendingInvites: (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'PendingInvites_SCREEN');
      return const BeamPage(
        popToNamed: ConfigRoute.farmManager,
        child: PendingInvites(),
        key: ValueKey("PendingInvites"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.socialRoute: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'Socials_SCREEN');
      return BeamPage(
        child: const SocialPage(),
        key: ValueKey("Socials- ${DateTime.now()}"),
      );
    },
    ConfigRoute.newsRoute: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'Socials_SCREEN');
      return BeamPage(
        child: const NewsPage(),
        key: ValueKey("NewsPage- ${DateTime.now()}"),
      );
    },
    ConfigRoute.changePasswordPage: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ChangePasswordPage_SCREEN');
      return BeamPage(
        child: const ChangePasswordPage(),
        key: ValueKey("ChangePasswordPage- ${DateTime.now()}"),
      );
    },
    ConfigRoute.profileRoute: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'Profile_SCREEN');
      return BeamPage(
        child: const ProfileMainScreen(),
        key: ValueKey("Profile- ${DateTime.now()}"),
      );
    },
    ConfigRoute.homeDashborad: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SINGLE_USER_PROFILE_SCREEN');
      return BeamPage(
        child: const Responsive(
          desktop: HomeDesktop(),
          mobile: HomePageMobile(),
          tablet: HomePageTablet(),
        ),
        key: ValueKey("Home-Page - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.farmProbe: (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SmatMlPage_SCREEN');
      return BeamPage(
        child: const SmatMlPage(),
        key: ValueKey("SmatMlPage - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.fieldMeasure: (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FieldMeasurementPage_SCREEN');
      return BeamPage(
        child: const FieldMeasurementPage(),
        key: ValueKey("FieldMeasurementPage - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.plantAnalysis: (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'AnalysisDetailsPage_SCREEN');
      return BeamPage(
        child: AnalysisDetailsPage(imagePath: p2.toString()),
        key: ValueKey("AnalysisDetailsPage - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.soilSampling}/*": (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'CreateSoilSamplesPage_SCREEN');
      return BeamPage(
        child: CreateSoilSamplesPage(createSoilSamplesArgs: p2 as CreateSoilSamplesArgs),
        key: ValueKey("CreateSoilSamplesPage - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.plantDatabase: (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'PlantDatabasePage_SCREEN');
      return BeamPage(
        child: const PlantDatabasePage(),
        key: ValueKey("PlantDatabasePage - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.plantDetails}/*": (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
      return BeamPage(
        child: PlantDetailsPage(plantIdentifier: p2.toString()),
        key: ValueKey("PlantDetailsPage - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.dashSite}/*": (p0, p1, p2) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'DashSite_SCREEN');
      return BeamPage(
        child: const DashSite(),
        key: ValueKey("DashSite - ${DateTime.now()}"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.mainPage: (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SINGLE_USER_PROFILE_SCREEN');
      return const BeamPage(
        child: Responsive(
          desktop: HomeDesktop(),
          mobile: HomePageMobile(),
          tablet: HomePageTablet(),
        ),
        key: ValueKey("Home-Page-Main"),
        type: BeamPageType.noTransition,
      );
    },
    "*": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SPLASH_SCREEN');
      return const BeamPage(
        child: Responsive(
          desktop: DashboardView(),
          mobile: DashboardView(),
          tablet: DashboardView(),
        ),
        key: ValueKey("Dash-boardView"),
        type: BeamPageType.noTransition,
      );
    },
    "/*": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SPLASH_SCREEN');
      return const BeamPage(
        child: NoPageFound(),
        key: ValueKey("NoPageFound"),
        type: BeamPageType.noTransition,
      );
    },
    "/": (BuildContext context, BeamState state, Object? data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SPLASH_SCREEN');
      return const BeamPage(
        child: Responsive(
          desktop: DashboardView(),
          mobile: DashboardView(),
          tablet: DashboardView(),
        ),
        key: ValueKey("Dashboard-View"),
        type: BeamPageType.noTransition,
      );
    },
    ConfigRoute.institutionDashboardPath: (BuildContext context, BeamState state, Object? data) => BeamPage(
          child: const InstitutionDashboard(),
          key: ValueKey("InstitutionDashboard-${DateTime.now()}"),
          type: BeamPageType.noTransition,
        ),
    ConfigRoute.institutionOrganizationPath: (BuildContext context, BeamState state, Object? data) => BeamPage(
          child: const InstitutionOrganization(),
          key: ValueKey("InstitutionOrganization-${DateTime.now()}"),
          type: BeamPageType.noTransition,
        ),
    ConfigRoute.institutionSettingsPath: (BuildContext context, BeamState state, Object? data) => BeamPage(
          child: const InstitutionSettings(),
          key: ValueKey("InstitutionSettings-${DateTime.now()}"),
          type: BeamPageType.noTransition,
        ),
    ConfigRoute.manageOrgRoute: (BuildContext context, BeamState state, Object? data) {
      return BeamPage(
        child: SizedBox(
          height: Responsive.yHeight(context, percent: 0.89),
          child: const InstitutionDashboard(),
        ),
        key: const ValueKey("Manage Organization"),
      );
    },
    ConfigRoute.farmAssistantBaseUi: (context, state, data) {
      GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FarmAssistantBaseUi');
      return const BeamPage(
        child: FarmAssistantBaseUi(),
        key: ValueKey("FarmAssistant"),
        type: BeamPageType.noTransition,
      );
    },
    "${ConfigRoute.institutionOrganizationPath}/:id": (BuildContext context, BeamState state, Object? data) => BeamPage(
          child: const InstitutionOrgSite(),
          popToNamed: ConfigRoute.institutionOrganizationPath,
          key: ValueKey("InstitutionOrgSite-${DateTime.now()}"),
        ),
  };
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page not found"),
      ),
      body: const Center(
        child: Text("Page not found"),
      ),
    );
  }
}
