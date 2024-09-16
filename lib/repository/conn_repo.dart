import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/data_source/remote_data_store/conn_remote_data_source.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_conn.dart';

abstract class ConnRepo {
  Future<MyConnsResponse?> getMyConns({int page = 1, int refresh = 0});
  Future<ConnResponse?> getRecommendedConns({int page = 1, int refresh = 0});
  Future<ConnResponse?> getRandomConns({int page = 1, int refresh = 0});
  Future<bool?> hasConnection({required String id});
  Future<bool?> toggleConnection({required String id});
  Future<String?> updateConn({required String id});
  Future<ConnOverviewResponse?> getOldRecentConns();
}

final connRepoProvider = Provider((ref) {
  final connRemoteDS = ref.watch(connRemoteDSProvider);
  return ConnRepoImpl(remoteDataSource: connRemoteDS);
});

class ConnRepoImpl extends ConnRepo {
  final ConnRemoteDataSource remoteDataSource;
  ConnRepoImpl({required this.remoteDataSource});

  @override
  Future<bool?> hasConnection({required String id}) {
    return remoteDataSource.hasConnection(id: id);
  }

  @override
  Future<MyConnsResponse?> getMyConns({int page = 1, int refresh = 0}) {
    return remoteDataSource.getMyConns(page: page, refresh: refresh);
  }

  @override
  Future<ConnOverviewResponse?> getOldRecentConns() {
    return remoteDataSource.getOldRecentConns();
  }

  @override
  Future<ConnResponse?> getRandomConns({int page = 1, int refresh = 0}) {
    return remoteDataSource.getRandomConns(page: page, refresh: refresh);
  }

  @override
  Future<ConnResponse?> getRecommendedConns({int page = 1, int refresh = 0}) {
    return remoteDataSource.getRecommendedConns(page: page, refresh: refresh);
  }

  @override
  Future<bool?> toggleConnection({required String id}) {
    return remoteDataSource.toggleConnection(id: id);
  }

  @override
  Future<String?> updateConn({required String id}) {
    throw UnimplementedError();
  }
}
