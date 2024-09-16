import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_story.dart';
import 'package:rootnode/helper/http_service.dart';
import 'package:rootnode/helper/utils.dart';
import 'package:rootnode/model/story.dart';

final storyRemoteDSProvider = Provider((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return StoryRemoteDataSource(httpService: httpService);
});

class StoryRemoteDataSource {
  final Dio httpService;
  StoryRemoteDataSource({required this.httpService});

  Future<StoryResponse?> getStoryFeed(
      {int page = 1, int refresh = 0, bool private = false}) async {
    try {
      Response res = await httpService.get(
        "${ApiConstants.baseUrl}${ApiConstants.story}${private ? '/feed' : ''}?page=$page&refresh=$refresh",
      );
      return res.statusCode == 200 ? StoryResponse.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<Story?> getStoryById({required String id}) async {
    try {
      Response res = await httpService
          .get("${ApiConstants.baseUrl}${ApiConstants.story}/$id");
      return res.statusCode == 200 ? Story.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<StoryResponse?> getStoryByUser(
      {int page = 1, int refresh = 0, required String id}) async {
    try {
      Response res = await httpService.get(
        "${ApiConstants.baseUrl}${ApiConstants.story}/user/$id?page=$page&refresh=$refresh",
      );
      return res.statusCode == 200 ? StoryResponse.fromJson(res.data) : null;
    } catch (_) {
      debugPrint(_.toString());
      return null;
    }
  }

  Future<bool> storyWatched({required String id}) async {
    try {
      Response res = await httpService
          .post("${ApiConstants.baseUrl}${ApiConstants.story}/$id");
      return res.statusCode == 200;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }

  Future<bool> createStory({required Story story, XFile? file}) async {
    try {
      MultipartFile? media;

      if (file != null) {
        media = await FileConverter.toMultipartFile(file: file);
      }
      Map<String, dynamic> storyMap = story.toJson();
      storyMap['media'] = media;
      FormData formData = FormData.fromMap(storyMap);
      Response res = await httpService
          .post("${ApiConstants.baseUrl}${ApiConstants.story}", data: formData);

      return res.statusCode == 201;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }
}
