import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/data_source/remote_data_store/cmnt_remote_data_source.dart';
import 'package:rootnode/data_source/remote_data_store/response/res_cmnt.dart';
import 'package:rootnode/model/comment/comment.dart';

abstract class CommentRepo {
  Future<CommentResponse?> getPostComments({
    required String id,
    int page = 1,
  });
  Future<Object?> getCommentLikers({
    required String id,
    int page = 1,
  });
  Future<bool> toggleCommentLike({required String id});
  Future<Object?> updateCommentByID({required String id});
  Future<bool> deleteCommentById({required String id});
  Future<Object?> getCommentByID({required String id});
  Future<Comment?> createComment({required String id, required String comment});
}

final commentRepoProvider = Provider((ref) {
  final cmntRemoteDataSource = ref.watch(cmntRemoteDSProvider);
  return CommentRepoImpl(remoteDataSource: cmntRemoteDataSource);
});

class CommentRepoImpl extends CommentRepo {
  final CmntRemoteDataSource remoteDataSource;

  CommentRepoImpl({required this.remoteDataSource});
  @override
  Future<bool> deleteCommentById({required String id}) {
    return remoteDataSource.deleteCommentById(id: id);
  }

  @override
  Future<Object?> getCommentByID({required String id}) {
    // TODO: implement getCommentByID
    throw UnimplementedError();
  }

  @override
  Future<Object?> getCommentLikers({required String id, int page = 1}) {
    // TODO: implement getCommentLikers
    throw UnimplementedError();
  }

  @override
  Future<CommentResponse?> getPostComments({required String id, int page = 1}) {
    return remoteDataSource.getPostComments(id: id, page: page);
  }

  @override
  Future<bool> toggleCommentLike({required String id}) {
    return remoteDataSource.toggleCommentLike(id: id);
  }

  @override
  Future<Object?> updateCommentByID({required String id}) {
    // TODO: implement updateCommentByID
    throw UnimplementedError();
  }

  @override
  Future<Comment?> createComment(
      {required String id, required String comment}) {
    return remoteDataSource.createComment(id: id, comment: comment);
  }
}
