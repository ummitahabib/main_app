import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smat_crow/features/domain/entities/app_entity.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/farm_assistant/views/pages/farm_assistant_base_ui.dart';
import 'package:smat_crow/features/farm_manager/views/farm_agents.dart';
import 'package:smat_crow/features/farm_manager/views/farm_log.dart';
import 'package:smat_crow/features/farm_manager/views/farm_manager.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_details.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_log_details.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/create_budget.dart';
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
import 'package:smat_crow/features/farm_manager/views/mobile/upload_asset_archives.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_site_view.dart';
import 'package:smat_crow/features/institution/views/institution_agents.dart';
import 'package:smat_crow/features/institution/views/institution_dashboard.dart';
import 'package:smat_crow/features/institution/views/institution_invites.dart';
import 'package:smat_crow/features/institution/views/institution_settings.dart';
import 'package:smat_crow/features/institution/views/mobile/institution_menu_mobile.dart';
import 'package:smat_crow/features/institution/views/mobile/institution_site_mobile.dart';
import 'package:smat_crow/features/institution/views/notification_settings.dart';
import 'package:smat_crow/features/institution/views/web/institution_org_site.dart';
import 'package:smat_crow/features/organisation/views/pages/organisation.dart';
import 'package:smat_crow/features/organisation/views/pages/site_details.dart';
import 'package:smat_crow/features/presentation/pages/credential/forget_password/forget_password.dart';
import 'package:smat_crow/features/presentation/pages/credential/signin/signin.dart';
import 'package:smat_crow/features/presentation/pages/credential/signup/signup.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/activity_grid_item.dart';
import 'package:smat_crow/features/presentation/pages/main_dashboard/screens/main_screen.dart';
import 'package:smat_crow/features/presentation/pages/onboarding/screens/onboarding_page.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/comment_page.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/edit_comment_page.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/edit_reply_page.dart';
import 'package:smat_crow/features/presentation/pages/post/post_detail_page.dart';
import 'package:smat_crow/features/presentation/pages/post/update_post_page.dart';
import 'package:smat_crow/features/presentation/pages/post/upload_post_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/change_password.dart';
import 'package:smat_crow/features/presentation/pages/profile/edit_profile_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/single_user_profile_page.dart';
import 'package:smat_crow/features/presentation/pages/search/search_page.dart';
import 'package:smat_crow/features/presentation/pages/splash/splash_screens.dart';
import 'package:smat_crow/features/presentation/pages/verify/verify_email.dart';
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

import 'features/institution/views/mobile/inst_dashboard_mobile.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case ConfigRoute.splash:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SPLASH_SCREEN');
        return routeBuilder(
          const SplashPage(),
        );
      case ConfigRoute.onboarding:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ONBOARDING_SCREEN');
        return routeBuilder(
          const OnboardingPage(),
        );
      case ConfigRoute.login:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'LOGIN_SCREEN');
        return routeBuilder(
          const SigninPage(),
        );

      case ConfigRoute.signup:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNUP_SCREEN');
        return routeBuilder(const SignUpPage());

      case ConfigRoute.mainPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNUP_SCREEN');
        return routeBuilder(const MainDashboard());

      case ConfigRoute.userForgetPassword:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FORGET_PASSWORD_SCREEN');
        return routeBuilder(
          const ForgetPassword(),
        );
      case ConfigRoute.organization:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
        return routeBuilder(
          const Organization(),
        );
      case ConfigRoute.farmProbe:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
        return routeBuilder(
          const SmatMlPage(),
        );
      case ConfigRoute.fieldMeasure:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
        return routeBuilder(
          const FieldMeasurementPage(),
        );
      case ConfigRoute.plantAnalysis:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
        return routeBuilder(
          AnalysisDetailsPage(imagePath: arguments.toString()),
        );
      case ConfigRoute.soilSampling:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
        return routeBuilder(
          CreateSoilSamplesPage(createSoilSamplesArgs: arguments as CreateSoilSamplesArgs),
        );
      case ConfigRoute.plantDatabase:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
        return routeBuilder(
          const PlantDatabasePage(),
        );
      case ConfigRoute.dashSite:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'DashSite_SCREEN');
        return routeBuilder(
          const DashSite(),
        );
      case ConfigRoute.plantDetails:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ORGANIZATION_SCREEN');
        return routeBuilder(
          PlantDetailsPage(plantIdentifier: arguments.toString()),
        );

      case ConfigRoute.verifyEmailPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'VERIFY_EMAIL_SCREEN');
        return routeBuilder(
          const VerifyEmail(),
        );
      case ConfigRoute.uploadPost:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPLOAD_POST_SCREEN');

        return routeBuilder(
          const UploadPostPage(),
        );

      case ConfigRoute.pendingInvites:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'PendingInvites_SCREEN');
        return routeBuilder(
          const PendingInvites(),
        );
      case ConfigRoute.changePasswordPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ChangePasswordPage_SCREEN');
        return routeBuilder(
          const ChangePasswordPage(),
        );

      case ConfigRoute.searchPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SEARCH_SCREEN');
        return routeBuilder(
          const SearchPage(),
        );

      case ConfigRoute.siteDetails:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SITE_DETAILS_SCREEN');
        return routeBuilder(
          const SiteDetails(),
        );
      case ConfigRoute.farmManager:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_MANAGER_SCREEN');
        return routeBuilder(
          const FarmManager(),
        );
      case ConfigRoute.subscriptionPlanView:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SubscriptionPlanView_SCREEN');
        return routeBuilder(
          const SubscriptionPlanView(),
        );
      case ConfigRoute.subscriptionPlanListView:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SubscriptionPlanListView_SCREEN');
        return routeBuilder(
          const SubscriptionPlanListView(),
        );
      case ConfigRoute.farmManagerOverview:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_MANAGER_DETAILS_SCREEN');
        return routeBuilder(
          const FarmOverviewMobile(),
        );
      case ConfigRoute.editProfilePage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'CREATE_BUDGET_SCREEN');
        return routeBuilder(
          const EditProfilePage(),
        );
      case ConfigRoute.createBudget:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'CREATE_BUDGET_SCREEN');
        return routeBuilder(
          const CreateBudget(),
        );
      case ConfigRoute.farmManagerSiteView:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'CREATE_BUDGET_SCREEN');
        return routeBuilder(
          const Responsive(
            desktop: FarmSiteView(),
            mobile: FarmSiteViewMobile(),
            tablet: FarmSiteViewMobile(),
          ),
        );

      case ConfigRoute.farmAsset:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_ASSET_SCREEN');
        return routeBuilder(
          const FarmAssetMobile(),
        );

      case ConfigRoute.registerAsset:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'REGISTER_ASSET_SCREEN');
        return routeBuilder(
          const RegisterAsset(),
        );
      case ConfigRoute.assetDetails:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_DETAILS_SCREEN');
        return routeBuilder(
          AssetDetails(id: settings.arguments.toString()),
        );

      case ConfigRoute.updatePostPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPDATE_POST_SCREEN');
        if (arguments is PostEntity) {
          return routeBuilder(
            UpdatePostPage(
              post: arguments,
            ),
          );
        } else {
          return routeBuilder(const NoPageFound());
        }

      case ConfigRoute.commentPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'CREATE_COMMENT_SCREEN');
        if (arguments is AppEntity) {
          return routeBuilder(
            CommentPage(
              appEntity: arguments,
            ),
          );
        } else {
          return routeBuilder(const NoPageFound());
        }

      case ConfigRoute.updateCommentPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPDATE_COMMENT_SCREEN');
        if (arguments is CommentEntity) {
          return routeBuilder(
            EditCommentPage(
              comment: arguments,
            ),
          );
        } else {
          return routeBuilder(const NoPageFound());
        }

      case ConfigRoute.updateReplyPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPDATE_REPLY_SCREEN');
        if (arguments is ReplyEntity) {
          return routeBuilder(
            EditReplyPage(
              reply: arguments,
            ),
          );
        } else {
          return routeBuilder(const NoPageFound());
        }

      case ConfigRoute.postDetailPage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'POST_DETAIL_SCREEN');
        if (arguments is String) {
          return routeBuilder(
            PostDetailPage(
              postId: arguments,
            ),
          );
        } else {
          return routeBuilder(const NoPageFound());
        }

      case ConfigRoute.singleUserProfilePage:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SINGLE_USER_PROFILE_SCREEN');
        if (arguments is String) {
          return routeBuilder(
            SingleUserProfilePage(
              otherUserId: arguments,
            ),
          );
        } else {
          return routeBuilder(const NoPageFound());
        }

      case ConfigRoute.registerFarmLog:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'REGISTER_FARM_LOG_SCREEN');
        return routeBuilder(
          const RegisterFarmLog(),
        );
      case ConfigRoute.farmLogAddInfo:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_LOG_ADDITIONAL_INFO_SCREEN');
        return routeBuilder(
          const FarmLogAdditionalInfo(),
        );

      case ConfigRoute.financeLog:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FINANCE_LOG_SCREEN');
        return routeBuilder(
          const FinanceLogMobile(),
        );
      case ConfigRoute.uploadArchive:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPLOAD_ARCHIVE_SCREEN');
        return routeBuilder(
          UploadAssetArchives(title: settings.arguments.toString()),
        );
      case ConfigRoute.farmLogDetails:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'UPLOAD_ARCHIVE_SCREEN');
        return routeBuilder(
          const FarmLogDetailsMobile(),
        );

      case ConfigRoute.assetLogDetails:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ASSET_LOG_DETAILS_SCREEN');
        return routeBuilder(
          const AssetLogDetails(),
        );

      case ConfigRoute.farmLog:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FARM_LOG_SCREEN');
        return routeBuilder(
          const FarmLog(),
        );
      case ConfigRoute.manageOrgRoute:
        return routeBuilder(
          const InstitutionDashboard(),
        );
      case ConfigRoute.institutionSettingsPath:
        return routeBuilder(
          const InstitutionSettings(),
        );

      case ConfigRoute.institutionOrganizationPath:
        return routeBuilder(
          const InstitutionOrgSite(),
        );

      case ConfigRoute.institutionDashboardPath:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'INSTITUTION_DASHBOARD_SCREEN');
        return routeBuilder(
          const InstDashboardViewMobile(),
        );
      case ConfigRoute.institutionAgents:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'AGENT_TABLE_SCREEN');
        return routeBuilder(
          const InstitutionAgents(),
        );
      case ConfigRoute.institutionNotificationSettings:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'NOTIFICATION_SETTINGS_SCREEN');
        return routeBuilder(
          const InstitutionNottySettings(),
        );
      case ConfigRoute.institutionInvites:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'MANAGE_INVITE_SCREEN');
        return routeBuilder(
          const InstitutionInvites(),
        );
      case ConfigRoute.institutionOrganizationSitePath:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'INSTITUTION_SITE_SCREEN');
        return routeBuilder(
          const InstitutionSiteMobile(),
        );
      case ConfigRoute.institutionOrganizationMenuPath:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'INSTITUTION_MENU_SCREEN');
        return routeBuilder(
          const InstitutionMenuMobile(),
        );
      case ConfigRoute.farmAgent:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'INSTITUTION_MENU_SCREEN');
        return routeBuilder(
          const FarmAgents(),
        );

      case ConfigRoute.farmLogType:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'INSTITUTION_MENU_SCREEN');
        return routeBuilder(
          const LogTypeMobile(),
        );
      case ConfigRoute.farmAssistantBaseUi:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'FarmAssistantBaseUi');
        return routeBuilder(
          const FarmAssistantBaseUi(),
          // setting: settings,
        );

      default:
        GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SPLASH_SCREEN');
        return routeBuilder(
          const SplashPage(),
        );
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
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
