// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  @JsonKey(ignore: true)
  @Id(assignable: true)
  int? get uid => throw _privateConstructorUsedError;
  @Unique()
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get fname => throw _privateConstructorUsedError;
  String? get lname => throw _privateConstructorUsedError;
  @Unique()
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  bool? get emailVerified => throw _privateConstructorUsedError;
  int? get postsCount => throw _privateConstructorUsedError;
  int? get storiesCount => throw _privateConstructorUsedError;
  int? get nodesCount => throw _privateConstructorUsedError;
  int? get connsCount => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;
  bool? get showOnlineStatus => throw _privateConstructorUsedError;
  @Property(type: PropertyType.date)
  DateTime? get lastSeen => throw _privateConstructorUsedError;
  @Unique()
  String? get username => throw _privateConstructorUsedError;
  @Property(type: PropertyType.date)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @Property(type: PropertyType.date)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @Property(type: PropertyType.date)
  DateTime? get usernameChangedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {@JsonKey(ignore: true) @Id(assignable: true) int? uid,
      @Unique() @JsonKey(name: '_id') String? id,
      String? fname,
      String? lname,
      @Unique() String? email,
      String? password,
      String? avatar,
      bool? emailVerified,
      int? postsCount,
      int? storiesCount,
      int? nodesCount,
      int? connsCount,
      String? role,
      String? status,
      bool? isVerified,
      bool? showOnlineStatus,
      @Property(type: PropertyType.date) DateTime? lastSeen,
      @Unique() String? username,
      @Property(type: PropertyType.date) DateTime? createdAt,
      @Property(type: PropertyType.date) DateTime? updatedAt,
      @Property(type: PropertyType.date) DateTime? usernameChangedAt});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? id = freezed,
    Object? fname = freezed,
    Object? lname = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? avatar = freezed,
    Object? emailVerified = freezed,
    Object? postsCount = freezed,
    Object? storiesCount = freezed,
    Object? nodesCount = freezed,
    Object? connsCount = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? isVerified = freezed,
    Object? showOnlineStatus = freezed,
    Object? lastSeen = freezed,
    Object? username = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? usernameChangedAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      fname: freezed == fname
          ? _value.fname
          : fname // ignore: cast_nullable_to_non_nullable
              as String?,
      lname: freezed == lname
          ? _value.lname
          : lname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: freezed == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      postsCount: freezed == postsCount
          ? _value.postsCount
          : postsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      storiesCount: freezed == storiesCount
          ? _value.storiesCount
          : storiesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      nodesCount: freezed == nodesCount
          ? _value.nodesCount
          : nodesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      connsCount: freezed == connsCount
          ? _value.connsCount
          : connsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      showOnlineStatus: freezed == showOnlineStatus
          ? _value.showOnlineStatus
          : showOnlineStatus // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usernameChangedAt: freezed == usernameChangedAt
          ? _value.usernameChangedAt
          : usernameChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(ignore: true) @Id(assignable: true) int? uid,
      @Unique() @JsonKey(name: '_id') String? id,
      String? fname,
      String? lname,
      @Unique() String? email,
      String? password,
      String? avatar,
      bool? emailVerified,
      int? postsCount,
      int? storiesCount,
      int? nodesCount,
      int? connsCount,
      String? role,
      String? status,
      bool? isVerified,
      bool? showOnlineStatus,
      @Property(type: PropertyType.date) DateTime? lastSeen,
      @Unique() String? username,
      @Property(type: PropertyType.date) DateTime? createdAt,
      @Property(type: PropertyType.date) DateTime? updatedAt,
      @Property(type: PropertyType.date) DateTime? usernameChangedAt});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? id = freezed,
    Object? fname = freezed,
    Object? lname = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? avatar = freezed,
    Object? emailVerified = freezed,
    Object? postsCount = freezed,
    Object? storiesCount = freezed,
    Object? nodesCount = freezed,
    Object? connsCount = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? isVerified = freezed,
    Object? showOnlineStatus = freezed,
    Object? lastSeen = freezed,
    Object? username = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? usernameChangedAt = freezed,
  }) {
    return _then(_$_User(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      fname: freezed == fname
          ? _value.fname
          : fname // ignore: cast_nullable_to_non_nullable
              as String?,
      lname: freezed == lname
          ? _value.lname
          : lname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: freezed == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      postsCount: freezed == postsCount
          ? _value.postsCount
          : postsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      storiesCount: freezed == storiesCount
          ? _value.storiesCount
          : storiesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      nodesCount: freezed == nodesCount
          ? _value.nodesCount
          : nodesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      connsCount: freezed == connsCount
          ? _value.connsCount
          : connsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      showOnlineStatus: freezed == showOnlineStatus
          ? _value.showOnlineStatus
          : showOnlineStatus // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usernameChangedAt: freezed == usernameChangedAt
          ? _value.usernameChangedAt
          : usernameChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@Entity(realClass: User)
class _$_User extends _User {
  _$_User(
      {@JsonKey(ignore: true) @Id(assignable: true) this.uid,
      @Unique() @JsonKey(name: '_id') this.id,
      this.fname,
      this.lname,
      @Unique() this.email,
      this.password,
      this.avatar,
      this.emailVerified,
      this.postsCount,
      this.storiesCount,
      this.nodesCount,
      this.connsCount,
      this.role,
      this.status,
      this.isVerified = false,
      this.showOnlineStatus = false,
      @Property(type: PropertyType.date) this.lastSeen,
      @Unique() this.username,
      @Property(type: PropertyType.date) this.createdAt,
      @Property(type: PropertyType.date) this.updatedAt,
      @Property(type: PropertyType.date) this.usernameChangedAt})
      : super._();

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  @JsonKey(ignore: true)
  @Id(assignable: true)
  final int? uid;
  @override
  @Unique()
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? fname;
  @override
  final String? lname;
  @override
  @Unique()
  final String? email;
  @override
  final String? password;
  @override
  final String? avatar;
  @override
  final bool? emailVerified;
  @override
  final int? postsCount;
  @override
  final int? storiesCount;
  @override
  final int? nodesCount;
  @override
  final int? connsCount;
  @override
  final String? role;
  @override
  final String? status;
  @override
  @JsonKey()
  final bool? isVerified;
  @override
  @JsonKey()
  final bool? showOnlineStatus;
  @override
  @Property(type: PropertyType.date)
  final DateTime? lastSeen;
  @override
  @Unique()
  final String? username;
  @override
  @Property(type: PropertyType.date)
  final DateTime? createdAt;
  @override
  @Property(type: PropertyType.date)
  final DateTime? updatedAt;
  @override
  @Property(type: PropertyType.date)
  final DateTime? usernameChangedAt;

  @override
  String toString() {
    return 'User(uid: $uid, id: $id, fname: $fname, lname: $lname, email: $email, password: $password, avatar: $avatar, emailVerified: $emailVerified, postsCount: $postsCount, storiesCount: $storiesCount, nodesCount: $nodesCount, connsCount: $connsCount, role: $role, status: $status, isVerified: $isVerified, showOnlineStatus: $showOnlineStatus, lastSeen: $lastSeen, username: $username, createdAt: $createdAt, updatedAt: $updatedAt, usernameChangedAt: $usernameChangedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fname, fname) || other.fname == fname) &&
            (identical(other.lname, lname) || other.lname == lname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.postsCount, postsCount) ||
                other.postsCount == postsCount) &&
            (identical(other.storiesCount, storiesCount) ||
                other.storiesCount == storiesCount) &&
            (identical(other.nodesCount, nodesCount) ||
                other.nodesCount == nodesCount) &&
            (identical(other.connsCount, connsCount) ||
                other.connsCount == connsCount) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.showOnlineStatus, showOnlineStatus) ||
                other.showOnlineStatus == showOnlineStatus) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.usernameChangedAt, usernameChangedAt) ||
                other.usernameChangedAt == usernameChangedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uid,
        id,
        fname,
        lname,
        email,
        password,
        avatar,
        emailVerified,
        postsCount,
        storiesCount,
        nodesCount,
        connsCount,
        role,
        status,
        isVerified,
        showOnlineStatus,
        lastSeen,
        username,
        createdAt,
        updatedAt,
        usernameChangedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User extends User {
  factory _User(
      {@JsonKey(ignore: true)
      @Id(assignable: true)
          final int? uid,
      @Unique()
      @JsonKey(name: '_id')
          final String? id,
      final String? fname,
      final String? lname,
      @Unique()
          final String? email,
      final String? password,
      final String? avatar,
      final bool? emailVerified,
      final int? postsCount,
      final int? storiesCount,
      final int? nodesCount,
      final int? connsCount,
      final String? role,
      final String? status,
      final bool? isVerified,
      final bool? showOnlineStatus,
      @Property(type: PropertyType.date)
          final DateTime? lastSeen,
      @Unique()
          final String? username,
      @Property(type: PropertyType.date)
          final DateTime? createdAt,
      @Property(type: PropertyType.date)
          final DateTime? updatedAt,
      @Property(type: PropertyType.date)
          final DateTime? usernameChangedAt}) = _$_User;
  _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  @JsonKey(ignore: true)
  @Id(assignable: true)
  int? get uid;
  @override
  @Unique()
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get fname;
  @override
  String? get lname;
  @override
  @Unique()
  String? get email;
  @override
  String? get password;
  @override
  String? get avatar;
  @override
  bool? get emailVerified;
  @override
  int? get postsCount;
  @override
  int? get storiesCount;
  @override
  int? get nodesCount;
  @override
  int? get connsCount;
  @override
  String? get role;
  @override
  String? get status;
  @override
  bool? get isVerified;
  @override
  bool? get showOnlineStatus;
  @override
  @Property(type: PropertyType.date)
  DateTime? get lastSeen;
  @override
  @Unique()
  String? get username;
  @override
  @Property(type: PropertyType.date)
  DateTime? get createdAt;
  @override
  @Property(type: PropertyType.date)
  DateTime? get updatedAt;
  @override
  @Property(type: PropertyType.date)
  DateTime? get usernameChangedAt;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
