import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_story.dart';
import 'package:rootnode/data_source/remote_data_store/story_remote_data_source.dart';
import 'package:rootnode/model/story.dart';

abstract class StoryRepo {
  Future<StoryResponse?> getStoryFeed(
      {int page = 1, int refresh = 0, bool private = false});
  Future<StoryResponse?> getStoryByUser(
      {int page = 1, int refresh = 0, required String id});
  Future<Story?> getStoryById({required String id});
  Future<bool> storyWatched({required String id});
  Future<bool> createStory({required Story story, XFile? file});
}

final storyRepoProvider = Provider((ref) {
  final storyRemoteDS = ref.watch(storyRemoteDSProvider);
  return StoryRepoImpl(remoteDataSource: storyRemoteDS);
});

class StoryRepoImpl extends StoryRepo {
  final StoryRemoteDataSource remoteDataSource;

  StoryRepoImpl({required this.remoteDataSource});
  @override
  Future<StoryResponse?> getStoryFeed(
      {int page = 1, int refresh = 0, bool private = false}) {
    return remoteDataSource.getStoryFeed(
        page: page, refresh: refresh, private: private);
  }

  @override
  Future<Story?> getStoryById({required String id}) {
    return remoteDataSource.getStoryById(id: id);
  }

  @override
  Future<StoryResponse?> getStoryByUser(
      {int page = 1, int refresh = 0, required String id}) {
    return remoteDataSource.getStoryByUser(
        page: page, refresh: refresh, id: id);
  }

  @override
  Future<bool> createStory({required Story story, XFile? file}) {
    return remoteDataSource.createStory(story: story, file: file);
  }

  @override
  Future<bool> storyWatched({required String id}) {
    return remoteDataSource.storyWatched(id: id);
  }
}
