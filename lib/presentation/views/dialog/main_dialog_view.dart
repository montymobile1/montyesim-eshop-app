import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/enums/dialog_icon_type.dart";
import "package:esim_open_source/presentation/extensions/color_extension.dart";
import "package:esim_open_source/presentation/setup_dialog_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:esim_open_source/presentation/views/dialog/main_dialog_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:stacked/stacked.dart";
import "package:stacked_services/stacked_services.dart";

Widget getImageFromType(DialogIconType type, Color themeColor) {
  switch (type) {
    case DialogIconType.none:
      return Container();
    case DialogIconType.warning:
      return SvgPicture.asset(
        EnvironmentImages.iconWarning.fullImagePath,
        colorFilter: ColorFilter.mode(themeColor, BlendMode.srcIn),
      );
    case DialogIconType.warningRed:
      return SvgPicture.asset(
        EnvironmentImages.iconWarning.fullImagePath,
        colorFilter:
            ColorFilter.mode(HexColor.fromHex("#951624"), BlendMode.srcIn),
      );
    case DialogIconType.check:
      return SvgPicture.asset(
        EnvironmentImages.iconCheck.fullImagePath,
        colorFilter: ColorFilter.mode(themeColor, BlendMode.srcIn),
      );
    case DialogIconType.dataSharing:
      return SvgPicture.asset(
        "assets/images/icon_data_sharing.svg",
        colorFilter: ColorFilter.mode(themeColor, BlendMode.srcIn),
      );
  }
}

class MainBasicDialog extends StatelessWidget {
  const MainBasicDialog({
    required this.requestBase,
    required this.completer,
    super.key,
  });
  final DialogRequest<MainDialogRequest> requestBase;
  final Function(DialogResponse<MainDialogResponse>) completer;

  @override
  Widget build(BuildContext context) {
    MainDialogRequest request = requestBase.data ?? const MainDialogRequest();
    return ViewModelBuilder<MainDialogViewModel>.reactive(
      viewModelBuilder: MainDialogViewModel.new,
      onViewModelReady: (MainDialogViewModel model) => model.initializeData(),
      builder:
          (BuildContext context, MainDialogViewModel model, Widget? child) =>
              Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          _buildMainContainer(context, request, model),
          _buildCloseButton(context, request, model),
          _buildTopIcon(context, request, model),
        ],
      ),
    );
  }

  Widget _buildMainContainer(
    BuildContext context,
    MainDialogRequest request,
    MainDialogViewModel model,
  ) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 45,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cBackground(context),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTitle(context, request),
          _buildDescription(context, request),
          _buildMainButton(request, model),
          _buildSecondaryButton(request, model),
          _buildCancelButton(context, request, model),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, MainDialogRequest request) {
    if (request.title == null) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          request.title!,
          style: headerThreeMediumTextStyle(context: context),
        ),
        verticalSpaceTiny,
      ],
    );
  }

  Widget _buildDescription(BuildContext context, MainDialogRequest request) {
    if (request.description == null) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          request.description!,
          style: request.descriptionTextStyle ??
              headerThreeMediumTextStyle(
                context: context,
                fontColor: contentTextColor(context: context),
              ),
          textAlign: TextAlign.center,
        ),
        verticalSpaceSmall,
      ],
    );
  }

  Widget _buildMainButton(
    MainDialogRequest request,
    MainDialogViewModel model,
  ) {
    if (request.mainButtonTitle == null) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MainButton(
          title: request.mainButtonTitle!,
          themeColor: request.mainButtonColor ?? model.themeColor,
          onPressed: () => model.mainButtonClicked(
            completer: completer,
            request: request,
          ),
        ),
        verticalSpaceSmall,
      ],
    );
  }

  Widget _buildSecondaryButton(
    MainDialogRequest request,
    MainDialogViewModel model,
  ) {
    if (request.secondaryButtonTitle == null) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MainButton(
          title: request.secondaryButtonTitle!,
          themeColor: request.secondaryButtonColor ?? model.themeColor,
          onPressed: () => model.secondaryButtonClicked(
            completer: completer,
            request: request,
          ),
        ),
        verticalSpaceSmall,
      ],
    );
  }

  Widget _buildCancelButton(
    BuildContext context,
    MainDialogRequest request,
    MainDialogViewModel model,
  ) {
    if (!request.showCancelButton) {
      return Container();
    }

    return Column(
      children: <Widget>[
        request.informativeOnly
            ? _buildInformativeButton(request, model)
            : _buildCancelGesture(context, request, model),
        verticalSpaceTiniest,
      ],
    );
  }

  Widget _buildInformativeButton(
    MainDialogRequest request,
    MainDialogViewModel model,
  ) {
    return MainButton(
      themeColor: model.themeColor,
      title: request.cancelText ?? LocaleKeys.ok.tr(),
      onPressed: () => model.mainButtonClicked(
        completer: completer,
        request: request,
      ),
    );
  }

  Widget _buildCancelGesture(
    BuildContext context,
    MainDialogRequest request,
    MainDialogViewModel model,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => model.cancelClicked(completer),
      child: Align(
        child: Text(
          request.cancelText ?? LocaleKeys.cancel.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.cHintTextColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(
    BuildContext context,
    MainDialogRequest request,
    MainDialogViewModel model,
  ) {
    if (!request.hideXButton) {
      return const SizedBox(height: 0);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.close_sharp,
            size: 30,
          ),
          color: Theme.of(context).colorScheme.cForeground(context),
          onPressed: () => model.closeClicked(completer),
          enableFeedback: true,
        ),
      ],
    );
  }

  Widget _buildTopIcon(
    BuildContext context,
    MainDialogRequest request,
    MainDialogViewModel model,
  ) {
    if (request.iconType == DialogIconType.none) {
      return const SizedBox(height: 0);
    }

    return Positioned(
      top: -30,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.cBackground(context),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .cHintTextColor(context)
                  .withAlpha(20),
              spreadRadius: 2,
              blurRadius: 3,
            ),
          ],
        ),
        child: ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(30),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: getImageFromType(
                request.iconType,
                model.themeColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<DialogRequest<MainDialogRequest>>(
          "requestBase",
          requestBase,
        ),
      )
      ..add(
        ObjectFlagProperty<Function(DialogResponse<MainDialogResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
