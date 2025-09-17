import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  test("basic coverage", () {
    final EsimArguments args = const EsimArguments(id: "1", name: "test", type: "region");
    args.id;
    args.name;
    args.type;
    args.copyWith();
    args.copyWith(code: "2");
    args.copyWith(name: "test2");
    args.copyWith(type: "country");
    args.copyWith(code: "3", name: "test3", type: "country");
    
    EsimArgumentType.region;
    EsimArgumentType.country;
    
    // Test different types
    const EsimArguments regionArgs = EsimArguments(id: "r1", name: "Region", type: EsimArgumentType.region);
    const EsimArguments countryArgs = EsimArguments(id: "c1", name: "Country", type: EsimArgumentType.country);
    
    regionArgs.id;
    countryArgs.id;
  });

  Future<void> tearDown() async {
    await tearDownTest();
  }
}