import "dart:math";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/data/response/bundles/supported_ships_response_model.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/info_row_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class SupportedShipsCard extends StatefulWidget {
  const SupportedShipsCard({required this.ships, super.key});

  final List<SupportedShipsResponseModel> ships;

  @override
  State<SupportedShipsCard> createState() => _SupportedShipsCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(IterableProperty<SupportedShipsResponseModel>("ships", ships));
  }
}

class _SupportedShipsCardState extends State<SupportedShipsCard> {
  bool _isExpanded = false;

  double getHeight() {
    double maxHeight = 180;
    double cellHeight = _isExpanded ? 40 + 40 : 40;
    double allHeight = widget.ships.length * cellHeight;
    return min(maxHeight, allHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: lightGreyBackGroundColor(context: context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PaddingWidget.applySymmetricPadding(
            vertical: 12,
            horizontal: 12,
            child: Text(
              LocaleKeys.supportedShips_card_tittleText.tr(
                namedArgs: <String, String>{
                  "ships": "(${widget.ships.length})",
                },
              ),
              style: captionTwoMediumTextStyle(
                context: context,
                fontColor: mainDarkTextColor(context: context),
              ),
            ),
          ),
          //verticalSpaceSmall,
          SizedBox(
            height: getHeight(),
            child: Scrollbar(
              thickness: 4,
              radius: const Radius.circular(2),
              child: ListView.builder(
                itemCount: widget.ships.length,
                itemBuilder: (BuildContext context, int index) {
                  final SupportedShipsResponseModel ship = widget.ships[index];
                  final bool hasOperators = !(ship.operatorList?.isEmpty ?? true);
                  final IconData expansionIcon = _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down;

                  return AbsorbPointer(
                    absorbing: ship.operatorList?.isEmpty ?? true,
                    child: ExpansionTile(
                      collapsedIconColor:
                          mainTabBackGroundColor(context: context),
                      iconColor: mainTabBackGroundColor(context: context),
                      minTileHeight: 0,
                      shape: const Border(),
                      onExpansionChanged: (bool isExpanded) {
                        setState(() {
                          _isExpanded = isExpanded;
                        });
                      },
                      trailing: hasOperators
                          ? Icon(expansionIcon, size: 20)
                          : const SizedBox.shrink(),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                      title: Row(
                        children: <Widget>[
                          CountryFlagImage(
                            icon: widget.ships[index].icon ?? "",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            ship.country ?? "",
                            style: captionTwoMediumTextStyle(
                              context: context,
                              fontColor: titleTextColor(
                                context: context,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: <Widget>[
                        ship.operatorList?.isEmpty ?? true
                            ? Container()
                            : InfoRow(
                                title: ship.operatorList?.join(",") ??
                                    LocaleKeys.supportedCountries_noNetworks
                                        .tr(),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@AppPreview(name: "Supported Ships Card")
Widget supportedShipsCardPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: SupportedShipsCard(
        ships: SupportedShipsResponseModel.getMockCountries().take(5).toList(),
      ),
    ),
  );
}
