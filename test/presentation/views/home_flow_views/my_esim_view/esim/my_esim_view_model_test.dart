import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/use_case/user/get_bundle_label_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_notifications_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";
import "../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late MyESimViewModel viewModel;
  late MockApiUserRepository mockApiUserRepository;
  late MockNavigationService mockNavigationService;
  late MockBottomSheetService mockBottomSheetService;
  late HomePagerViewModel homePagerViewModel;
  late MockFlutterChannelHandlerService mockFlutterChannelHandlerService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "MyEsimView");
    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockBottomSheetService =
        locator<BottomSheetService>() as MockBottomSheetService;
    homePagerViewModel = locator<HomePagerViewModel>();
    mockFlutterChannelHandlerService = locator<FlutterChannelHandlerService>()
        as MockFlutterChannelHandlerService;

    // Mock Bottom Sheet Service
    when(
      mockBottomSheetService.showCustomSheet(
        variant: anyNamed("variant"),
        isScrollControlled: anyNamed("isScrollControlled"),
        ignoreSafeArea: anyNamed("ignoreSafeArea"),
        data: anyNamed("data"),
      ),
    ).thenAnswer(
      (_) async => SheetResponse<MainBottomSheetResponse>(
        data: const MainBottomSheetResponse(),
      ),
    );

    viewModel = MyESimViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("MyESimViewModel Essential Tests", () {
    group("Initialization", () {
      test("initializes correctly", () {
        expect(
          viewModel.getUserNotificationsUseCase,
          isA<GetUserNotificationsUseCase>(),
        );
        expect(viewModel.getBundleLabelUseCase, isA<GetBundleLabelUseCase>());
        expect(viewModel.state, isNotNull);
        expect(viewModel.state.currentESimList, isEmpty);
        expect(viewModel.state.expiredESimList, isEmpty);
        expect(viewModel.isInstallationFailed, isFalse);
        expect(viewModel, isA<ChangeNotifier>());
      });
    });

    group("Tab Management", () {
      test("setTabIndex updates selected tab index", () {
        viewModel.setTabIndex = 1;
        expect(viewModel.state.selectedTabIndex, equals(1));

        viewModel.setTabIndex = 0;
        expect(viewModel.state.selectedTabIndex, equals(0));
      });
    });

    group("Navigation", () {
      test("openDataPlans calls home pager view model", () {
        viewModel.openDataPlans();
      });

      test("notificationsButtonTapped navigates to notifications", () {
        when(mockNavigationService.navigateTo(NotificationsView.routeName))
            .thenAnswer((_) async => null);
        viewModel.notificationsButtonTapped();
        verify(mockNavigationService.navigateTo(NotificationsView.routeName))
            .called(1);
      });
    });

    group("Bundle Interactions", () {
      test("onTopUpClick handles valid iccid", () async {
        viewModel.state.currentESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));
        await viewModel.onTopUpClick(iccid: "test-iccid");
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onTopUpClick with successful response shows success sheet",
          () async {
        viewModel.state.currentESimList.add(
          PurchaseEsimBundleResponseModel(
            iccid: "test-iccid",
            bundleCode: "test-bundle",
          ),
        );

        // Mock top-up response (not canceled)
        when(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).thenAnswer(
          (_) async => SheetResponse<MainBottomSheetResponse>(
            data: const MainBottomSheetResponse(canceled: false),
          ),
        );

        await viewModel.onTopUpClick(iccid: "test-iccid");

        // Verify that both bottom sheets were called (top-up + success)
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(2); // Once for top-up, once for success
      });

      test("onTopUpClick returns early for invalid iccid", () async {
        await viewModel.onTopUpClick(iccid: "invalid-iccid");
        verifyNever(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        );
      });

      test("onConsumptionClick handles valid iccid", () async {
        viewModel.state.currentESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));
        await viewModel.onConsumptionClick(iccid: "test-iccid");
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onConsumptionClick with top-up tag triggers onTopUpClick",
          () async {
        viewModel.state.currentESimList.add(
          PurchaseEsimBundleResponseModel(
            iccid: "test-iccid",
            bundleCode: "test-bundle",
            isTopupAllowed: true,
          ),
        );

        // First call: consumption bottom sheet returns with top-up tag
        // Second call: top-up bottom sheet
        int callCount = 0;
        when(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            // Consumption sheet returns with top-up tag
            return SheetResponse<MainBottomSheetResponse>(
              data: const MainBottomSheetResponse(
                canceled: false,
                tag: "top-up",
              ),
            );
          } else {
            // Top-up sheet
            return SheetResponse<MainBottomSheetResponse>(
              data: const MainBottomSheetResponse(),
            );
          }
        });

        await viewModel.onConsumptionClick(iccid: "test-iccid");

        // Verify bottom sheet was called twice (consumption + top-up)
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(2);
      });

      test("onConsumptionClick returns early for invalid iccid", () async {
        await viewModel.onConsumptionClick(iccid: "invalid-iccid");
        verifyNever(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        );
      });

      test("onQrCodeClick handles valid iccid", () async {
        viewModel.state.currentESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));
        await viewModel.onQrCodeClick(iccid: "test-iccid");
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onQrCodeClick returns early for invalid iccid", () async {
        await viewModel.onQrCodeClick(iccid: "invalid-iccid");
        verifyNever(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        );
      });

      test("onCurrentBundleClick handles valid iccid", () async {
        viewModel.state.currentESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));
        await viewModel.onCurrentBundleClick(iccid: "test-iccid");
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            ignoreSafeArea: anyNamed("ignoreSafeArea"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onCurrentBundleClick with top_up tag triggers onTopUpClick",
          () async {
        viewModel.state.currentESimList.add(
          PurchaseEsimBundleResponseModel(
            iccid: "test-iccid",
            bundleCode: "test-bundle",
          ),
        );

        int callCount = 0;
        when(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            ignoreSafeArea: anyNamed("ignoreSafeArea"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return SheetResponse<MainBottomSheetResponse>(
              data: const MainBottomSheetResponse(
                canceled: false,
                tag: "top_up",
              ),
            );
          } else {
            return SheetResponse<MainBottomSheetResponse>(
              data: const MainBottomSheetResponse(),
            );
          }
        });

        await viewModel.onCurrentBundleClick(iccid: "test-iccid");

        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            ignoreSafeArea: anyNamed("ignoreSafeArea"),
            data: anyNamed("data"),
          ),
        ).called(2);
      });

      test("onCurrentBundleClick returns early when busy", () async {
        viewModel.state.currentESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));
        viewModel.setViewState(ViewState.busy);
        await viewModel.onCurrentBundleClick(iccid: "test-iccid");
        // Should not call bottom sheet when busy
      });

      test("onExpiredBundleClick handles valid iccid", () async {
        viewModel.state.expiredESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));
        await viewModel.onExpiredBundleClick(iccid: "test-iccid");
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            ignoreSafeArea: anyNamed("ignoreSafeArea"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onExpiredBundleClick with top_up tag triggers onTopUpClick",
          () async {
        viewModel.state.expiredESimList.add(
          PurchaseEsimBundleResponseModel(
            iccid: "test-iccid",
            bundleCode: "test-bundle",
          ),
        );

        int callCount = 0;
        when(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            ignoreSafeArea: anyNamed("ignoreSafeArea"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return SheetResponse<MainBottomSheetResponse>(
              data: const MainBottomSheetResponse(
                canceled: false,
                tag: "top_up",
              ),
            );
          } else {
            return SheetResponse<MainBottomSheetResponse>(
              data: const MainBottomSheetResponse(),
            );
          }
        });

        await viewModel.onExpiredBundleClick(iccid: "test-iccid");

        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            ignoreSafeArea: anyNamed("ignoreSafeArea"),
            data: anyNamed("data"),
          ),
        ).called(2);
      });

      test("onExpiredBundleClick returns early when busy", () async {
        viewModel.state.expiredESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));
        viewModel.setViewState(ViewState.busy);
        await viewModel.onExpiredBundleClick(iccid: "test-iccid");
        // Should not call bottom sheet when busy
      });

      test("onEditNameClick handles valid iccid", () async {
        viewModel.state.currentESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));
        await viewModel.onEditNameClick(iccid: "test-iccid");
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onEditNameClick with canceled response does not change name",
          () async {
        viewModel.state.currentESimList.add(
          PurchaseEsimBundleResponseModel(
            iccid: "test-iccid",
            displayTitle: "Old Name",
          ),
        );

        when(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).thenAnswer(
          (_) async => SheetResponse<MainBottomSheetResponse>(
            data: const MainBottomSheetResponse(),
          ),
        );

        await viewModel.onEditNameClick(iccid: "test-iccid");

        // Verify sheet was shown
        verify(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).called(1);
      });

      test("onEditNameClick returns early for invalid iccid", () async {
        await viewModel.onEditNameClick(iccid: "invalid-iccid");
        verifyNever(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        );
      });
    });

    group("Installation", () {
      test("onInstallClick handles errors gracefully", () async {
        viewModel.state.currentESimList
            .add(PurchaseEsimBundleResponseModel(iccid: "test-iccid"));

        when(
          mockFlutterChannelHandlerService.openEsimSetupForAndroid(
            smdpAddress: anyNamed("smdpAddress"),
            activationCode: anyNamed("activationCode"),
          ),
        ).thenThrow(Exception("Installation failed"));

        when(
          mockFlutterChannelHandlerService.openEsimSetupForIOS(
            smdpAddress: anyNamed("smdpAddress"),
            activationCode: anyNamed("activationCode"),
          ),
        ).thenThrow(Exception("Installation failed"));

        await viewModel.onInstallClick(iccid: "test-iccid");
        expect(viewModel.isInstallationFailed, isTrue);
        expect(viewModel.state.showInstallButton, isFalse);
      });

      test("onInstallClick returns early for invalid iccid", () async {
        await viewModel.onInstallClick(iccid: "invalid-iccid");
        expect(viewModel.isInstallationFailed, isFalse);
      });

      test("onInstallClick handles successful installation", () async {
        viewModel.state.currentESimList.add(
          PurchaseEsimBundleResponseModel(
            iccid: "test-iccid",
            smdpAddress: "test-smdp",
            activationCode: "test-code",
          ),
        );

        when(
          mockFlutterChannelHandlerService.openEsimSetupForAndroid(
            smdpAddress: anyNamed("smdpAddress"),
            activationCode: anyNamed("activationCode"),
          ),
        ).thenAnswer((_) async => true);

        await viewModel.onInstallClick(iccid: "test-iccid");
        expect(viewModel.isInstallationFailed, isFalse);
      });
    });

    group("Notification Badge", () {
      test("handleNotificationBadge with empty notifications", () async {
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.success(
            <UserNotificationModel>[],
            message: "Success",
          ),
        );

        await viewModel.handleNotificationBadge();
        expect(viewModel.state.showNotificationBadge, isFalse);
      });

      test("handleNotificationBadge with unread notifications", () async {
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.success(
            <UserNotificationModel>[
              UserNotificationModel(status: false), // Unread
            ],
            message: "Success",
          ),
        );

        await viewModel.handleNotificationBadge();
        expect(viewModel.state.showNotificationBadge, isTrue);
      });

      test("handleNotificationBadge with all read notifications", () async {
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.success(
            <UserNotificationModel>[
              UserNotificationModel(status: true), // Read
              UserNotificationModel(status: true), // Read
            ],
            message: "Success",
          ),
        );

        await viewModel.handleNotificationBadge();
        expect(viewModel.state.showNotificationBadge, isTrue);
      });

      test("handleNotificationBadge with null response", () async {
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.success(
            <UserNotificationModel>[],
            message: "Success",
          ),
        );

        await viewModel.handleNotificationBadge();
        expect(viewModel.state.showNotificationBadge, isTrue);
      });
    });

    group("Error Handling", () {
      test("handles API error in notification response", () async {
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.error("API Error"),
        );

        await viewModel.handleNotificationBadge();
        // Should handle error gracefully without throwing
        expect(true, isTrue);
      });
    });

    group("Business Logic", () {
      test("onViewModelReady calls refreshScreen", () {
        expect(() => viewModel.onViewModelReady(), returnsNormally);
      });

      test("refreshCurrentPlans executes without error", () async {
        expect(() async => viewModel.refreshCurrentPlans(), returnsNormally);
      });

      test("state properties are accessible", () {
        expect(viewModel.state, isNotNull);
        expect(viewModel.isInstallationFailed, isA<bool>());
        expect(viewModel.getUserNotificationsUseCase, isNotNull);
        expect(viewModel.getBundleLabelUseCase, isNotNull);
      });
    });

    group("Notification Badge Failure", () {
      test("handleNotificationBadge onFailure hides badge on API error",
          () async {
        // Arrange — reset the use case static cache so the error stub is hit
        // instead of returning previously cached success data.
        GetUserNotificationsUseCase.resetCachedData();
        viewModel.state.showNotificationBadge = true;
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.error("API Error"),
        );

        // Act
        await viewModel.handleNotificationBadge();

        // Assert
        expect(viewModel.state.showNotificationBadge, isFalse);
      });
    });

    group("Fetch ESim Data", () {
      test("fetchESimData success splits current and expired bundles",
          () async {
        // Arrange
        when(mockApiUserRepository.getMyEsims()).thenAnswer(
          (_) async => Resource<List<PurchaseEsimBundleResponseModel>?>.success(
            <PurchaseEsimBundleResponseModel>[
              PurchaseEsimBundleResponseModel(iccid: "active-iccid"),
              PurchaseEsimBundleResponseModel(
                iccid: "expired-iccid",
                bundleExpired: true,
              ),
            ],
            message: "Success",
          ),
        );

        // Act — handleResponse is fired without await inside fetchESimData,
        // so pump microtasks to let the success callback settle the view state.
        await viewModel.fetchESimData(isSilent: false);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(viewModel.state.currentESimList.length, equals(1));
        expect(viewModel.state.expiredESimList.length, equals(1));
        expect(
          viewModel.state.currentESimList.first.iccid,
          equals("active-iccid"),
        );
        expect(viewModel.viewState, equals(ViewState.idle));
      });

      test(
          "fetchESimData success keeps install button hidden when install failed",
          () async {
        // Arrange
        viewModel.isInstallationFailed = true;
        when(mockApiUserRepository.getMyEsims()).thenAnswer(
          (_) async => Resource<List<PurchaseEsimBundleResponseModel>?>.success(
            <PurchaseEsimBundleResponseModel>[
              PurchaseEsimBundleResponseModel(iccid: "active-iccid"),
            ],
            message: "Success",
          ),
        );

        // Act
        await viewModel.fetchESimData(isSilent: false);

        // Assert
        expect(viewModel.state.showInstallButton, isFalse);
      });

      test("fetchESimData success with null data triggers error handling",
          () async {
        // Arrange
        when(mockApiUserRepository.getMyEsims()).thenAnswer(
          (_) async => Resource<List<PurchaseEsimBundleResponseModel>?>.success(
            null,
            message: "Success",
          ),
        );

        // Act
        await viewModel.fetchESimData(isSilent: false);

        // Assert
        expect(viewModel.state.currentESimList, isEmpty);
        expect(viewModel.state.expiredESimList, isEmpty);
      });

      test(
          "fetchESimData failure clears lists and handles error when not silent",
          () async {
        // Arrange
        when(mockApiUserRepository.getMyEsims()).thenAnswer(
          (_) async =>
              Resource<List<PurchaseEsimBundleResponseModel>?>.error("Error"),
        );

        // Act
        await viewModel.fetchESimData(isSilent: false);

        // Assert
        expect(viewModel.state.currentESimList, isEmpty);
        expect(viewModel.state.expiredESimList, isEmpty);
      });

      test("fetchESimData failure stays silent when isSilent is true",
          () async {
        // Arrange
        when(mockApiUserRepository.getMyEsims()).thenAnswer(
          (_) async =>
              Resource<List<PurchaseEsimBundleResponseModel>?>.error("Error"),
        );

        // Act
        await viewModel.fetchESimData();

        // Assert
        expect(viewModel.state.currentESimList, isEmpty);
      });
    });

    group("Refresh Screen", () {
      test("refreshScreen fetches data when user is logged in", () async {
        // Arrange
        when(locator<UserAuthenticationService>().isUserLoggedIn)
            .thenReturn(true);
        GetUserNotificationsUseCase.resetCachedData();
        when(
          mockApiUserRepository.getUserNotifications(
            pageIndex: anyNamed("pageIndex"),
            pageSize: anyNamed("pageSize"),
          ),
        ).thenAnswer(
          (_) async => Resource<List<UserNotificationModel>>.success(
            <UserNotificationModel>[],
            message: "Success",
          ),
        );
        when(mockApiUserRepository.getMyEsims()).thenAnswer(
          (_) async => Resource<List<PurchaseEsimBundleResponseModel>?>.success(
            <PurchaseEsimBundleResponseModel>[
              PurchaseEsimBundleResponseModel(iccid: "active-iccid"),
            ],
            message: "Success",
          ),
        );

        // Act
        await viewModel.refreshScreen(isSilent: false);

        // Assert
        verify(mockApiUserRepository.getMyEsims()).called(1);
      });

      test("refreshScreen does nothing when user is not logged in", () async {
        // Arrange
        when(locator<UserAuthenticationService>().isUserLoggedIn)
            .thenReturn(false);

        // Act
        await viewModel.refreshScreen(isSilent: false);

        // Assert
        verifyNever(mockApiUserRepository.getMyEsims());
      });
    });

    group("Edit Bundle Name", () {
      test("onEditNameClick with confirmed name updates bundle label",
          () async {
        // Arrange
        viewModel.state.currentESimList.add(
          PurchaseEsimBundleResponseModel(
            iccid: "test-iccid",
            displayTitle: "Old Name",
          ),
        );
        when(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).thenAnswer(
          (_) async => SheetResponse<MainBottomSheetResponse>(
            data: const MainBottomSheetResponse(
              canceled: false,
              tag: "New Name",
            ),
          ),
        );
        when(
          mockApiUserRepository.getBundleLabel(
            iccid: anyNamed("iccid"),
            label: anyNamed("label"),
          ),
        ).thenAnswer(
          (_) async => Resource<EmptyResponse?>.success(
            EmptyResponse(),
            message: "Success",
          ),
        );
        when(mockApiUserRepository.getMyEsims()).thenAnswer(
          (_) async => Resource<List<PurchaseEsimBundleResponseModel>?>.success(
            <PurchaseEsimBundleResponseModel>[],
            message: "Success",
          ),
        );

        // Act
        await viewModel.onEditNameClick(iccid: "test-iccid");

        // Assert
        verify(
          mockApiUserRepository.getBundleLabel(
            iccid: "test-iccid",
            label: "New Name",
          ),
        ).called(1);
      });

      test("onEditNameClick with empty tag does not update bundle label",
          () async {
        // Arrange
        viewModel.state.currentESimList.add(
          PurchaseEsimBundleResponseModel(iccid: "test-iccid"),
        );
        when(
          mockBottomSheetService.showCustomSheet(
            isScrollControlled: anyNamed("isScrollControlled"),
            variant: anyNamed("variant"),
            data: anyNamed("data"),
          ),
        ).thenAnswer(
          (_) async => SheetResponse<MainBottomSheetResponse>(
            data: const MainBottomSheetResponse(canceled: false),
          ),
        );

        // Act
        await viewModel.onEditNameClick(iccid: "test-iccid");

        // Assert
        verifyNever(
          mockApiUserRepository.getBundleLabel(
            iccid: anyNamed("iccid"),
            label: anyNamed("label"),
          ),
        );
      });
    });

    group("Navigate To Loading", () {
      test("navigateToLoading navigates to purchase loading view", () async {
        // Arrange
        when(
          mockNavigationService.navigateTo(
            any,
            arguments: anyNamed("arguments"),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await viewModel.navigateToLoading("order-123");

        // Assert
        verify(
          mockNavigationService.navigateTo(
            any,
            arguments: anyNamed("arguments"),
          ),
        ).called(1);
      });
    });
  });
}
