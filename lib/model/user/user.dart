import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:string_extensions/string_extensions.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();
  @Entity(realClass: User)
  factory User({
    @JsonKey(ignore: true) @Id(assignable: true) final int? uid,
    @Unique() @JsonKey(name: '_id') final String? id,
    final String? fname,
    final String? lname,
    @Unique() final String? email,
    final String? password,
    final String? avatar,
    final bool? emailVerified,
    final int? postsCount,
    final int? storiesCount,
    final int? nodesCount,
    final int? connsCount,
    final String? role,
    final String? status,
    @Default(false) final bool? isVerified,
    @Default(false) final bool? showOnlineStatus,
    @Property(type: PropertyType.date) final DateTime? lastSeen,
    @Unique() final String? username,
    @Property(type: PropertyType.date) final DateTime? createdAt,
    @Property(type: PropertyType.date) final DateTime? updatedAt,
    @Property(type: PropertyType.date) final DateTime? usernameChangedAt,
  }) = _User;

  String get fullname {
    if (fname == null && lname == null) return "Anonymous";
    return "${fname ?? ''} ${lname ?? ''}".toTitleCase!;
  }

  String get fullnameMin {
    if (fname == null && lname == null) return "Anonymous";
    return "${fname ?? ''} ${lname?.charAt(0) ?? ''}.".toTitleCase!;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
