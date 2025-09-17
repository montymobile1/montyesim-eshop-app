import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

enum BannersViewTypes {
  liveChat,
  referAndEarn,
  cashBackRewards,
  none;

  static BannersViewTypes fromString(String action) {
    String upperCaseAction = action.toUpperCase();
    if (upperCaseAction == "CHAT") {
      return BannersViewTypes.liveChat;
    } else if (upperCaseAction == "REFER_NOW") {
      return BannersViewTypes.referAndEarn;
    } else if (upperCaseAction == "CASHBACK") {
      return BannersViewTypes.cashBackRewards;
    } else {
      return BannersViewTypes.none;
    }
  }
}

extension BannersViewTypesExtension on BannersViewTypes {
  String get buttonText {
    switch (this) {
      case BannersViewTypes.liveChat:
        return LocaleKeys.dataPlans_liveChatBannerButtonText.tr();
      case BannersViewTypes.referAndEarn:
        return LocaleKeys.dataPlans_referAndEarnBannerButtonText.tr();
      case BannersViewTypes.cashBackRewards:
        return LocaleKeys.dataPlans_cashbackRewardsBannerButtonText.tr();
      case BannersViewTypes.none:
        return "";
    }
  }
}
