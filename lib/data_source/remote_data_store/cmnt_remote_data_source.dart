import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_cmnt.dart';
import 'package:rootnode/helper/http_service.dart';
import 'package:rootnode/model/comment/comment.dart';

final cmntRemoteDSProvider = Provider((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return CmntRemoteDataSource(httpService: httpService);
});

class CmntRemoteDataSource {
  final Dio httpService;
  CmntRemoteDataSource({required this.httpService});

  Future<CommentResponse?> getPostComments(
      {required String id, required int page}) async {
    try {
      Response res = await httpService.get(
          "${ApiConstants.baseUrl}${ApiConstants.post}/$id/comment?page=$page");
      return res.statusCode == 200 ? CommentResponse.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return Future.value(null);
    }
  }

  Future<bool> toggleCommentLike({required String id}) async {
    try {
      Response res = await httpService.post(
          "${ApiConstants.baseUrl}${ApiConstants.post}/comment/$id/like-unlike");
      return res.statusCode == 200 ? res.data['data']['liked'] : false;
    } catch (_) {
      debugPrint(_.toString());
      return Future.value(false);
    }
  }

  Future<Comment?> createComment(
      {required String id, required String comment}) async {
    try {
      Response res = await httpService.post(
          "${ApiConstants.baseUrl}${ApiConstants.post}/$id/comment",
          data: {"comment": comment});
      return res.statusCode == 201 ? Comment.fromJson(res.data['data']) : null;
    } catch (_) {
      debugPrint(_.toString());
      return Future.value(null);
    }
  }

  Future<bool> deleteCommentById({required String id}) async {
    try {
      Response res = await httpService
          .delete("${ApiConstants.baseUrl}${ApiConstants.post}/comment/$id");
      return res.statusCode == 200 ? true : false;
    } catch (_) {
      debugPrint(_.toString());
      return Future.value(false);
    }
  }
}
