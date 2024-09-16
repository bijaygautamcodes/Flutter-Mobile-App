import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_post.dart';
import 'package:rootnode/helper/http_service.dart';
import 'package:rootnode/helper/utils.dart';
import 'package:rootnode/model/post.dart';

final postRemoteDSProvider = Provider((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return PostRemoteDataSource(httpService: httpService);
});

class PostRemoteDataSource {
  final Dio httpService;
  PostRemoteDataSource({required this.httpService});

  Future<PostResponse?> getPostFeed(
      {int page = 1, int refresh = 0, bool private = false}) async {
    try {
      Response res = await httpService.get(
        "${ApiConstants.baseUrl}${ApiConstants.post}${private ? '/feed' : ''}?page=$page&refresh=$refresh",
      );
      return res.statusCode == 200 ? PostResponse.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<PostResponse?> getPostByUser(
      {int page = 1, int refresh = 0, required String id}) async {
    try {
      Response res = await httpService.get(
        "${ApiConstants.baseUrl}${ApiConstants.post}/user/$id?page=$page&refresh=$refresh",
      );
      return res.statusCode == 200 ? PostResponse.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<bool> togglePostLike({required String id}) async {
    try {
      Response res = await httpService.post(
        "${ApiConstants.baseUrl}${ApiConstants.post}/$id/like-unlike",
      );
      return res.data['data']['liked'];
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }

  Future<bool> createPost(Post post, List<XFile>? files) async {
    try {
      List<MultipartFile>? mediaFiles;
      if (files != null && files.isNotEmpty) {
        mediaFiles = await FileConverter.toManyMultipartFile(files: files);
      }
      Map<String, dynamic> postMap = post.toJson();
      postMap['mediaFiles'] = mediaFiles;
      FormData formData = FormData.fromMap(postMap);
      Response res = await httpService
          .post("${ApiConstants.baseUrl}${ApiConstants.post}", data: formData);

      return res.statusCode == 201;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }

  Future<Post?> getPostById({required String id}) async {
    try {
      Response res = await httpService
          .get("${ApiConstants.baseUrl}${ApiConstants.post}/$id");
      return res.statusCode == 200 ? Post.fromJson(res.data['data']) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<bool> deletePost({required String id}) async {
    try {
      Response res = await httpService.delete(
        "${ApiConstants.baseUrl}${ApiConstants.post}/$id",
      );
      return res.statusCode == 200;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }
}
