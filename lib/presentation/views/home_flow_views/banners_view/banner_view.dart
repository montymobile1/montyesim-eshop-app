import "package:cached_network_image/cached_network_image.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_types.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BannerView extends StatelessWidget {
  const BannerView({
    required this.bannerView,
    required this.bannersViewModel,
    super.key,
  });
  final BannerState bannerView;
  final BannersViewModel bannersViewModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bannersViewModel.onViewTap(bannerView),
      child: PaddingWidget.applySymmetricPadding(
        horizontal: 5,
        child: Stack(
          children: <Widget>[
            if (bannerView.image?.isNotEmpty ?? false)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: bannerView.image ?? "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (BuildContext context, String url) =>
                      DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha((255.0 * 0.8).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha((255.0 * 0.9).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            Row(
              children: <Widget>[
                Expanded(
                  child: PaddingWidget.applyPadding(
                    top: 10,
                    start: 20,
                    bottom: 5,
                    end: bannerView.bannersViewType == BannersViewTypes.liveChat
                        ? 0
                        : 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          bannerView.title ?? "",
                          style: bodyBoldTextStyle(
                            context: context,
                            fontColor: mainWhiteTextColor(context: context),
                          ),
                        ),
                        Text(
                          bannerView.description ?? "",
                          style: captionOneNormalTextStyle(
                            context: context,
                            fontColor: mainWhiteTextColor(context: context),
                          ),
                        ),
                        bannerView.bannersViewType != BannersViewTypes.none
                            ? MainButton.bannerButton(
                                action: () =>
                                    bannersViewModel.onViewTap(bannerView),
                                themeColor: themeColor,
                                title: bannerView.bannersViewType.buttonText,
                                textColor: bannerView.bannersViewType ==
                                        BannersViewTypes.liveChat
                                    ? bannersViewModel.textColor ??
                                        context.appColors.grey_900
                                    : context.appColors.grey_900,
                                buttonColor: bannerView.bannersViewType ==
                                        BannersViewTypes.liveChat
                                    ? bannersViewModel.buttonColor ??
                                        context.appColors.baseWhite
                                    : context.appColors.baseWhite,
                                titleTextStyle:
                                    captionTwoBoldTextStyle(context: context),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<BannersViewModel>(
          "bannersViewModel",
          bannersViewModel,
        ),
      )
      ..add(DiagnosticsProperty<BannerState>("bannerView", bannerView));
  }
}
