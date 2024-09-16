// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['_id'] as String?,
      fname: json['fname'] as String?,
      lname: json['lname'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      avatar: json['avatar'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      postsCount: json['postsCount'] as int?,
      storiesCount: json['storiesCount'] as int?,
      nodesCount: json['nodesCount'] as int?,
      connsCount: json['connsCount'] as int?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? false,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      username: json['username'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      usernameChangedAt: json['usernameChangedAt'] == null
          ? null
          : DateTime.parse(json['usernameChangedAt'] as String),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      '_id': instance.id,
      'fname': instance.fname,
      'lname': instance.lname,
      'email': instance.email,
      'password': instance.password,
      'avatar': instance.avatar,
      'emailVerified': instance.emailVerified,
      'postsCount': instance.postsCount,
      'storiesCount': instance.storiesCount,
      'nodesCount': instance.nodesCount,
      'connsCount': instance.connsCount,
      'role': instance.role,
      'status': instance.status,
      'isVerified': instance.isVerified,
      'showOnlineStatus': instance.showOnlineStatus,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'username': instance.username,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'usernameChangedAt': instance.usernameChangedAt?.toIso8601String(),
    };
