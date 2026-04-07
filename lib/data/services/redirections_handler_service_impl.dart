import "dart:async";
import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/extensions/navigation_service_extensions.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/deep_link_helper.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/shared/redirections_helper.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class RedirectionsHandlerServiceImpl implements RedirectionsHandlerService {
  RedirectionsHandlerServiceImpl.initializeWithNavigationService({
    required this.navigationService,
    required this.bottomSheetService,
  });

  static RedirectionsHandlerServiceImpl getInstance(
    NavigationService navigationService,
    BottomSheetService bottomSheetService,
  ) {
    _instance ??=
        RedirectionsHandlerServiceImpl.initializeWithNavigationService(
      navigationService: navigationService,
      bottomSheetService: bottomSheetService,
    );
    return _instance!;
  }

  //#region Variables
  static RedirectionsHandlerServiceImpl? _instance;
  final NavigationService navigationService;
  final BottomSheetService bottomSheetService;
  Uri? _initialLinkData;
  Map<String, dynamic>? _initialPushData;

  //#endregion

  //#region Functions
  @override
  Future<void> handleInitialRedirection(void Function() callBack) async {
    if (_initialPushData == null && _initialLinkData == null) {
      callBack.call();
    } else if (_initialPushData != null) {
      navigationService.navigateTo(HomePager.routeName);

      _parseNotificationRedirection(
        notificationPayload: _initialPushData,
        isClicked: true,
      );
    } else if (_initialLinkData != null) {
      navigationService.navigateTo(HomePager.routeName);

      _parseDeepLinkRedirection(uri: _initialLinkData!);
    }
  }

  Future<void> _parseNotificationRedirection({
    required bool isClicked,
    Map<String, dynamic>? notificationPayload,
  }) async {
    if (notificationPayload == null) {
      return;
    }

    // dynamic notificationData = notificationPayload["data"];
    String iccid = notificationPayload["iccid"] ?? "";
    String notificationTypeID = notificationPayload["category"] ?? "0";
    String cashbackPercent = notificationPayload["cashback_percent"] ?? "0";
    debugPrint("notification : ${notificationPayload.values}");

    RedirectionCategoryType redirectionCategoryType =
        RedirectionsHelper.fromNotificationValue(
      categoryID: notificationTypeID,
      iccID: iccid,
      cashbackPercent: cashbackPercent,
    );

    _triggerRedirection(
      iccid: iccid,
      cashbackPercent: cashbackPercent,
      isClicked: isClicked,
      redirectionCategoryType: redirectionCategoryType,
    );

    _initialPushData = null;
  }

  Future<void> _parseDeepLinkRedirection({required Uri uri}) async {
    RedirectionCategoryType redirectionCategoryType =
        RedirectionsHelper.fromDeepLinkValue(
      uri.path,
      uri.queryParameters,
    );

    await locator<LocalStorageService>()
        .setString(LocalStorageKeys.utm, uri.path);

    if (redirectionCategoryType is ReferAndEarn) {
      //save referral code
      String referralCode =
          uri.queryParameters[DeepLinkDecodeKeys.referralCode.decodingKey] ??
              "";
      log("Referral code: $referralCode");
      await locator<LocalStorageService>()
          .setString(LocalStorageKeys.referralCode, referralCode);
      log("Referral code : $referralCode saved in local storage");
    }

    _triggerRedirection(
      isClicked: true,
      redirectionCategoryType: redirectionCategoryType,
    );

    _initialLinkData = null;
  }

  Future<void> _triggerRedirection({
    required RedirectionCategoryType redirectionCategoryType,
    String iccid = "",
    String cashbackPercent = "",
    bool isClicked = false,
    bool isUnlimitedData = false,
  }) async {
    log("Redirection type: $redirectionCategoryType");

    switch (redirectionCategoryType) {
      case BuyBundle():
        await _handleBuyBundleRedirection(iccid: iccid, isClicked: isClicked);
      case BuyTopUp():
        unawaited(refreshMyEsims());
      case ConsumptionBundleDetail():
        await _handleConsumptionBundleDetailRedirection(
          iccid: iccid,
          isClicked: isClicked,
          isUnlimitedData: isUnlimitedData,
        );
      case PlanStarted():
        unawaited(refreshMyEsims());
      case WalletTopUpSuccess():
        await _handleWalletTopUpSuccessRedirection();
      case WalletTopUpFailed():
        await _handleWalletTopUpFailedRedirection();
      case CountriesTap():
        await _handleCountriesTapRedirection();
      case RegionsTap():
        await _handleRegionsTapRedirection();
      case ReferAndEarn():
        await _handleReferAndEarnRedirection();
      case CountrySelected():
        await _handleCountrySelectedRedirection(redirectionCategoryType);
      case RegionSelected():
        await _handleRegionSelectedRedirection(redirectionCategoryType);
      case CashbackReward():
        showCashbackBottomSheet(cashbackPercent: cashbackPercent);
      case ShareBundleNotification():
      case RewardAvailable():
      case Empty():
      // do nothing
    }
  }

  Future<void> _handleBuyBundleRedirection({
    required String iccid,
    required bool isClicked,
  }) async {
    if (locator<NavigationRouter>()
            .isPageVisible(PurchaseLoadingView.routeName) &&
        !isClicked) {
      unawaited(locator<PurchaseLoadingViewModel>().getOrderDetails());
      return;
    } else if (isClicked &&
        !locator<NavigationRouter>()
            .isPageVisible(PurchaseLoadingView.routeName)) {
      unawaited(
        bottomSheetService.showCustomSheet(
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.bundleQrCode,
          data: BundleQrBottomRequest(iccID: iccid),
        ),
      );
    }
    unawaited(refreshMyEsims());
  }

  Future<void> _handleConsumptionBundleDetailRedirection({
    required String iccid,
    required bool isClicked,
    required bool isUnlimitedData,
  }) async {
    if (isClicked) {
      unawaited(
        bottomSheetService.showCustomSheet(
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.bundleConsumption,
          data: BundleConsumptionBottomRequest(
            iccID: iccid,
            isUnlimitedData: isUnlimitedData,
            showTopUp: true,
          ),
        ),
      );
    }
  }

  Future<void> _handleWalletTopUpSuccessRedirection() async {
    await GetUserInfoUseCase(locator<ApiAuthRepository>()).execute(NoParams());
    await showToast(LocaleKeys.topUpWallet_success.tr());
  }

  Future<void> _handleWalletTopUpFailedRedirection() async {
    await showToast(LocaleKeys.topUpWallet_error.tr());
  }

  Future<void> _handleCountriesTapRedirection() async {
    await _navigateToHomePagerAndSelectTab(
      mainTabIndex: 0,
      cruiseTabIndex: 1,
      tabIndex: 0,
    );
  }

  Future<void> _handleRegionsTapRedirection() async {
    await _navigateToHomePagerAndSelectTab(
      mainTabIndex: 0,
      cruiseTabIndex: 1,
      tabIndex: 1,
    );
  }

  Future<void> _handleReferAndEarnRedirection() async {
    log("Referral code saved");
    showToast(LocaleKeys.referral_code_activated.tr());

    if (!locator<UserAuthenticationService>().isUserLoggedIn) {
      await Future<void>.delayed(const Duration(seconds: 1));
      navigationService.navigateToLoginScreen();
    }
  }

  Future<void> _handleCountrySelectedRedirection(
    CountrySelected redirectionCategoryType,
  ) async {
    await _navigateToHomePagerAndSelectTab(
      mainTabIndex: 0,
      cruiseTabIndex: 1,
      tabIndex: 0,
    );
    locator<DataPlansViewModel>().navigateToCountryBundleByID(
      redirectionCategoryType.countryCode,
    );
  }

  Future<void> _handleRegionSelectedRedirection(
    RegionSelected redirectionCategoryType,
  ) async {
    await _navigateToHomePagerAndSelectTab(
      mainTabIndex: 0,
      cruiseTabIndex: 1,
      tabIndex: 1,
    );
    locator<DataPlansViewModel>().navigateToRegionBundleByID(
      redirectionCategoryType.regionCode,
    );
  }

  Future<void> _navigateToHomePagerAndSelectTab({
    required int mainTabIndex,
    required int cruiseTabIndex,
    required int tabIndex,
  }) async {
    if (!locator<NavigationRouter>().isPageVisible(HomePager.routeName)) {
      log("Page not visible");
      navigationService.clearStackAndShow(HomePager.routeName);
    } else {
      log("page visible");
      changeMainTabSelection(newIndex: mainTabIndex);
      changeCruiseSelection(newIndex: cruiseTabIndex);
      changeTabSelection(newIndex: tabIndex);
    }
  }

  @override
  Future<void> redirectToRoute({
    required InAppRedirection redirection,
  }) async {
    if (redirection.variant != null) {
      await bottomSheetService.showCustomSheet(
        data: redirection.arguments as PurchaseBundleBottomSheetArgs,
        enableDrag: false,
        isScrollControlled: true,
        variant: redirection.variant,
      );
      return;
    }
    navigationService.navigateTo(
      redirection.routeName,
      arguments: redirection.arguments,
    );
  }

  @override
  Future<void> serialiseAndRedirectNotification({
    required bool isClicked,
    required bool isInitial,
    Map<String, dynamic>? handlePushData,
  }) async {
    log("Push redirection triggered ==>> $handlePushData");
    if (isInitial) {
      _initialPushData = handlePushData;
    } else {
      _parseNotificationRedirection(
        isClicked: isClicked,
        notificationPayload: handlePushData,
      );
    }
  }

  @override
  Future<void> serialiseAndRedirectDeepLink({
    required bool isInitial,
    required Uri uriDeepLinkData,
  }) async {
    log("Link redirection triggered ==>> $uriDeepLinkData");
    if (isInitial) {
      _initialLinkData = uriDeepLinkData;
    } else {
      _parseDeepLinkRedirection(uri: uriDeepLinkData);
    }
  }

  @override
  Future<void> notificationInboxRedirections({
    required String iccID,
    required String category,
    required bool isUnlimitedData,
  }) async {
    RedirectionCategoryType redirectionCategoryType =
        RedirectionsHelper.fromNotificationValue(
      categoryID: category,
      iccID: iccID,
    );

    if (redirectionCategoryType is Empty) {
      return;
    }

    _triggerRedirection(
      iccid: iccID,
      isClicked: true,
      isUnlimitedData: isUnlimitedData,
      redirectionCategoryType: redirectionCategoryType,
    );
  }

//#endregion

//#region UI handling
  Future<void> changeMainTabSelection({
    required int newIndex,
  }) async {
    if (locator<HomePagerViewModel>().getSelectedTabIndex() != newIndex) {
      locator<HomePagerViewModel>().changeSelectedTabIndex(index: newIndex);
    }
  }

  Future<void> changeCruiseSelection({
    required int newIndex,
  }) async {
    if (DataPlansViewModel.cruiseTabBarSelectedIndex != newIndex) {
      locator<DataPlansViewModel>().onCruiseTabBarChange(newIndex);
    }
  }

  Future<void> changeTabSelection({
    required int newIndex,
  }) async {
    if (DataPlansViewModel.tabBarSelectedIndex != newIndex) {
      locator<DataPlansViewModel>().onTabBarChange(newIndex);
    }
  }

  Future<void> refreshMyEsims() async {
    await locator<MyESimViewModel>().refreshScreen();
  }

  void showCashbackBottomSheet({required String cashbackPercent}) {
    unawaited(
      bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.cashbackReward,
        data: CashbackRewardBottomRequest(
          title: LocaleKeys.hurray.tr(),
          description: LocaleKeys.cashback_reward_message.tr(),
          imagePath: EnvironmentImages.walletCashback.fullImagePath,
          percent: cashbackPercent,
        ),
      ),
    );
  }
//#endregion
}
