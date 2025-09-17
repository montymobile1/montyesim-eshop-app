import "dart:async";

import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/domain/util/pagination/pagination_state_mixin.dart";
import "package:esim_open_source/utils/value_stream.dart";

abstract class UseCase<X, Params> {
  FutureOr<X> execute(Params params);
}

abstract class PaginatedUseCase<T, Params> with PaginationState<T> {
  Future<void> loadNextPage(Params params);
  Future<void> refreshData(Params params);
  abstract PaginationService<T> paginationService;
}

abstract class StreamUseCase<X, Params> {
  ValueStream<X> execute(Params params);
}

// Parameter classes
class NoParams {}
