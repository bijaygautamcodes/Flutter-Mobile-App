import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_conn.dart';
import 'package:rootnode/repository/conn_repo.dart';

class ConnOverviewModel {
  final List<Node> recent;
  final List<Node> old;
  final int count;
  final int limit;
  final bool animating;

  const ConnOverviewModel({
    this.animating = false,
    this.recent = const [],
    this.old = const [],
    this.count = 0,
    this.limit = 3,
  });

  ConnOverviewModel copyWith({
    List<Node>? recent,
    List<Node>? old,
    bool? animating,
    int? count,
    int? limit,
  }) {
    return ConnOverviewModel(
      animating: animating ?? this.animating,
      recent: recent ?? this.recent,
      limit: limit ?? this.limit,
      count: count ?? this.count,
      old: old ?? this.old,
    );
  }
}

class ConnOverviewProvider extends StateNotifier<ConnOverviewModel> {
  final Ref ref;
  static const _initial = ConnOverviewModel();
  final ConnRepo connRepo;
  ConnOverviewProvider(
    this.ref,
    this.connRepo, [
    ConnOverviewModel connOverviewModel = _initial,
  ]) : super(connOverviewModel);

  void replaceAllOld({required List<Node> old}) {
    state = state.copyWith(old: old);
  }

  void replaceAllRecent({required List<Node> recent}) {
    state = state.copyWith(recent: recent);
  }

  void replaceOldAt({required Node oldOne, int index = 2}) {
    if (state.recent.isEmpty) state.copyWith(old: [oldOne]);
    assert(index < state.limit);
    state.old.replaceRange(index, index, [oldOne]);
    // state.old!.insert(index, oldOne);
    // state.old!.removeAt(index + 1);
  }

  void replaceRecentAt({required Node recentOne, int index = 2}) {
    if (state.recent.isEmpty) state.copyWith(recent: [recentOne]);
    assert(index < state.limit);
    state.recent.replaceRange(index, index, [recentOne]);
    // state.recent!.insert(index, recentOne);
    // state.recent!.removeAt(index + 1);
  }

  void updateState(
      {List<Node>? old,
      List<Node>? recent,
      int? count,
      int? limit,
      bool? animating}) {
    state = state.copyWith(
      recent: recent ?? state.recent,
      old: old ?? state.old,
      count: count ?? state.count,
      limit: limit ?? state.limit,
      animating: animating ?? state.animating,
    );
  }

  // TODO
  void animate({Duration? duration}) {
    state = state.copyWith(animating: true);
    Future.delayed(
      duration ?? const Duration(seconds: 1),
      () => state = state.copyWith(animating: false),
    );
  }

  Future<void> fetchOverview() async {
    ConnOverviewResponse? overview = await connRepo.getOldRecentConns();
    if (overview == null || overview.data == null) return;
    state = state.copyWith(
      old: overview.data!.old ?? [],
      recent: overview.data!.recent ?? [],
      count: overview.data!.count ?? 0,
      limit: overview.data!.limit ?? 0,
    );
  }

  List<Node> get getOldNodes => state.old;
  List<Node> get getRecentNodes => state.recent;
  int get getCount => state.count;
  int get getLimit => state.count;

  set setCount(int count) => state = state.copyWith(count: count);
  set setLimit(int limit) => state = state.copyWith(count: limit);
}

final connOverviewProvider =
    StateNotifierProvider<ConnOverviewProvider, ConnOverviewModel>(
  (ref) {
    final connRepo = ref.watch(connRepoProvider);
    return ConnOverviewProvider(ref, connRepo);
  },
);
