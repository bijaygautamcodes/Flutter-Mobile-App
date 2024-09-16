import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:rootnode/model/user/user.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
class Comment with _$Comment {
  @Assert('user != null', 'user cannot be empty')
  @Entity(realClass: Comment)
  factory Comment({
    @JsonKey(ignore: true) @Id(assignable: true) final int? cid,
    @Unique() @JsonKey(name: '_id') final String? id,
    final User? user,
    final String? comment,
    final String? type,
    final int? likesCount,
    final String? status,
    @Property(type: PropertyType.date) final DateTime? createdAt,
    @Property(type: PropertyType.date) final DateTime? updatedAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
