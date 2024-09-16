import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_conn.dart';
import 'package:rootnode/helper/http_service.dart';

final connRemoteDSProvider = Provider((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return ConnRemoteDataSource(httpService: httpService);
});

class ConnRemoteDataSource {
  final Dio httpService;

  ConnRemoteDataSource({required this.httpService});

  Future<MyConnsResponse?> getMyConns({int page = 1, int refresh = 0}) async {
    try {
      Response res =
          await httpService.get("${ApiConstants.baseUrl}${ApiConstants.conn}");

      return res.statusCode == 200 ? MyConnsResponse.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<ConnOverviewResponse?> getOldRecentConns() async {
    try {
      Response res = await httpService
          .get("${ApiConstants.baseUrl}${ApiConstants.connOverview}");
      return res.statusCode == 200
          ? ConnOverviewResponse.fromJson(res.data)
          : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<ConnResponse?> getRandomConns({int page = 1, int refresh = 0}) async {
    try {
      Response res = await httpService.get(
        "${ApiConstants.baseUrl}${ApiConstants.connRandom}?page=$page&refresh=$refresh",
      );
      return res.statusCode == 200 ? ConnResponse.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<ConnResponse?> getRecommendedConns(
      {int page = 1, int refresh = 0}) async {
    try {
      Response res = await httpService.get(
        "${ApiConstants.baseUrl}${ApiConstants.connRecom}?page=$page&refresh=$refresh",
      );
      return res.statusCode == 200 ? ConnResponse.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<bool?> hasConnection({required String id}) async {
    try {
      Response res = await httpService.get(
        "${ApiConstants.baseUrl}${ApiConstants.conn}/$id",
      );
      return res.statusCode == 200 ? res.data['hasLink'] : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<bool?> toggleConnection({required String id}) async {
    try {
      Response res = await httpService.post(
        "${ApiConstants.baseUrl}${ApiConstants.conn}/$id",
      );
      return res.statusCode == 200 ? res.data['hasLink'] : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }
}
