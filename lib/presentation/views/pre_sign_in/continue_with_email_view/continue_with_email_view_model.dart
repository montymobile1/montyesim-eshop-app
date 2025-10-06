import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/auth/otp_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/login_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:phone_input/phone_input_package.dart";
import "package:stacked_services/stacked_services.dart";

class ContinueWithEmailViewModelArgs {
  ContinueWithEmailViewModelArgs({
    required this.email,
    required this.phoneNumber,
    required this.otpExpiration,
    this.redirection,
  });

  final String? email;
  final String? phoneNumber;
  final int? otpExpiration;
  final InAppRedirection? redirection;
}

class ContinueWithEmailViewModel extends BaseModel {
  ContinueWithEmailViewModel({this.redirection});

  InAppRedirection? redirection;

  //#region UseCases
  final LoginUseCase loginUseCase = LoginUseCase(locator<ApiAuthRepository>());

  //#endregion

  //#region Variables
  final ContinueWithEmailState _state = ContinueWithEmailState();

  ContinueWithEmailState? get state => _state;

  PhoneController phoneController =
      PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: ""));

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    if (AppEnvironment.appEnvironmentHelper.loginType == LoginType.email ||
        AppEnvironment.appEnvironmentHelper.loginType ==
            LoginType.emailAndPhone) {
      _state.emailController.addListener(_validateForm);
    }
  }

  void _validateForm() {
    final String emailAddress = _state.emailController.text;
    _state.emailErrorMessage = validateEmailAddress(emailAddress);

    if (AppEnvironment.appEnvironmentHelper.loginType ==
        LoginType.emailAndPhone) {
      _state.isLoginEnabled = _state.emailErrorMessage == "" &&
          _state.isTermsChecked &&
          _state.isValidPhoneNumber;
    } else if (AppEnvironment.appEnvironmentHelper.loginType ==
        LoginType.email) {
      _state.isLoginEnabled =
          _state.emailErrorMessage == "" && _state.isTermsChecked;
    }

    notifyListeners();
  }

  void validateNumber({
    required String code,
    required String number,
    required bool isValid,
  }) {
    _state.isValidPhoneNumber = isValid;

    if (AppEnvironment.appEnvironmentHelper.loginType ==
        LoginType.emailAndPhone) {
      _state.isLoginEnabled =
          _state.emailErrorMessage == "" && isValid && _state.isTermsChecked;
    } else if (AppEnvironment.appEnvironmentHelper.loginType ==
        LoginType.phoneNumber) {
      _state.isLoginEnabled = isValid && _state.isTermsChecked;
    }

    notifyListeners();
  }

  Future<void>? loginButtonTapped() async {
    await _loginWithEmail();
  }

  //tested
  void updateTermsSelections() {
    _state.isTermsChecked = !_state.isTermsChecked;
    _validateForm();
  }

  String validateEmailAddress(String text) {
    if (text.trim().isEmpty) {
      return LocaleKeys.is_required_field.tr();
    }

    if (text.trim().isValidEmail()) {
      return "";
    }

    return LocaleKeys.enter_a_valid_email_address.tr();
  }

  //tested
  void backButtonTapped() {
    navigationService.back();
  }

  Future<void>? showTermsSheet() async {
    SheetResponse<EmptyBottomSheetResponse>? response =
        await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.termsCondition,
      isScrollControlled: true,
      enableDrag: false,
    );
    if (response?.confirmed ?? false) {
      _state.isTermsChecked = true;
      _validateForm();
    }
  }

  //#endregion

  //#region Apis
  Future<void> _loginWithEmail() async {
    setViewState(ViewState.busy);

    Resource<OtpResponseModel?> loginResponse = await loginUseCase.execute(
      LoginParams(
        phoneNumber: _state.isValidPhoneNumber
            ? "+${phoneController.value?.countryCode}${phoneController.value?.nsn}"
            : null,
        email:
            _state.emailErrorMessage == "" ? _state.emailController.text : null,
      ),
    );

    await handleResponse(
      loginResponse,
      onSuccess: (Resource<OtpResponseModel?> response) async {
        final ContinueWithEmailViewModelArgs args =
            ContinueWithEmailViewModelArgs(
          redirection: redirection,
          phoneNumber: _state.isValidPhoneNumber
              ? "+${phoneController.value?.countryCode}${phoneController.value?.nsn}"
              : null,
          email: _state.emailErrorMessage == ""
              ? _state.emailController.text
              : null,
          otpExpiration: response.data?.otpExpiration,
        );
        debugPrint("args: $args");

        navigationService.navigateTo(
          VerifyLoginView.routeName,
          arguments: args,
        );
      },
      onFailure: (Resource<OtpResponseModel?> response) async {
        if (response.error?.errorCode == 429) {
          final ContinueWithEmailViewModelArgs args =
              ContinueWithEmailViewModelArgs(
            redirection: redirection,
            phoneNumber: _state.isValidPhoneNumber
                ? "+${phoneController.value?.countryCode}${phoneController.value?.nsn}"
                : null,
            email: _state.emailErrorMessage == ""
                ? _state.emailController.text
                : null,
            otpExpiration: response.data?.otpExpiration,
          );
          debugPrint("args: $args");

          navigationService.navigateTo(
            VerifyLoginView.routeName,
            arguments: args,
          );
          return;
        }
        handleError(response);
      },
    );

    setViewState(ViewState.idle);
  }
//#endregion
}

class ContinueWithEmailState {
  bool isTermsChecked = false;
  bool isLoginEnabled = false;
  String? emailErrorMessage;
  bool isValidPhoneNumber = false;

  final TextEditingController emailController = TextEditingController();
}
