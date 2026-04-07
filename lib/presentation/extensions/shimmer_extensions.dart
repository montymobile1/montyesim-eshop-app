import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

/// Shimmer Extensions
extension ShimmerEffect on Widget {
  Widget applyShimmer({
    required ShimmerParams params,
  }) {
    if (params.enable) {
      return Shimmer.fromColors(
        baseColor: params.baseColor ?? greyBackGroundColor(context: params.context),
        highlightColor: params.highlightColor ?? mainShimmerColor(context: params.context),
        enabled: params.enable,
        child: Container(
          height: params.height,
          width: params.width,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(params.borderRadius),
          ),
          child: this,
        ),
      ).disabled(disabled: params.disabled);
    } else {
      return this;
    }
  }

  Widget disabled({bool disabled = true}) {
    return IgnorePointer(ignoring: disabled, child: this);
  }
}

class ShimmerParams {
  ShimmerParams({
    required this.context,
    required this.enable,
    this.disabled = true,
    this.borderRadius = 12,
    this.baseColor,
    this.highlightColor,
    this.height,
    this.width,
  });

  final BuildContext context;
  final bool enable;
  final bool disabled;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final double? height;
  final double? width;
}
