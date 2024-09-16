import 'package:objectbox/objectbox.dart';
import 'package:rootnode/model/user/user.dart';
import 'dart:convert';

@Entity()
class Post {
  Post({
    this.id,
    this.type,
    this.owner,
    this.caption,
    this.isMarkdown,
    this.mediaFiles = const [],
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.status,
    this.visibility,
    this.commentable,
    this.likeable,
    this.shareable,
    this.createdAt,
    this.updatedAt,
    this.pid = 0,
  });

  @Id(assignable: true)
  int pid;

  @Unique()
  String? id;
  String? type;

  User? owner;
  List<MediaFile> mediaFiles;

  String? caption;
  bool? isMarkdown;
  int? likesCount;
  int? commentsCount;
  int? sharesCount;
  String? status;
  String? visibility;
  bool? commentable;
  bool? likeable;
  bool? shareable;
  @Property(type: PropertyType.date)
  DateTime? createdAt;
  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["_id"],
        type: json["type"],
        owner: json["owner"] == null ? null : User.fromJson(json["owner"]),
        caption: json["caption"],
        isMarkdown: json["isMarkdown"],
        mediaFiles: json["mediaFiles"] == null
            ? []
            : List<MediaFile>.from(
                json["mediaFiles"]!.map((x) => MediaFile.fromJson(x))),
        likesCount: json["likesCount"],
        commentsCount: json["commentsCount"],
        sharesCount: json["sharesCount"],
        status: json["status"],
        visibility: json["visibility"],
        commentable: json["commentable"],
        likeable: json["likeable"],
        shareable: json["shareable"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "owner": owner?.toJson(),
        "caption": caption,
        "isMarkdown": isMarkdown,
        "mediaFiles": mediaFiles.isEmpty
            ? []
            : List<MediaFile>.from(mediaFiles.map((x) => x.toJson())),
        "likesCount": likesCount,
        "commentsCount": commentsCount,
        "sharesCount": sharesCount,
        "status": status,
        "visibility": visibility,
        "commentable": commentable,
        "likeable": likeable,
        "shareable": shareable,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

@Entity()
class MediaFile {
  MediaFile({
    this.id,
    this.url,
    this.type,
    this.mediaId = 0,
  });

  @Id(assignable: true)
  int mediaId;

  String? url;
  String? type;

  @Unique()
  String? id;

  factory MediaFile.fromRawJson(String str) =>
      MediaFile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        url: json["url"],
        type: json["type"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
        "_id": id,
      };
}

class Meta {
  Meta({
    this.isLiked,
  });

  List<bool>? isLiked;

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        isLiked: json["isLiked"] == null
            ? []
            : List<bool>.from(json["isLiked"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "isLiked":
            isLiked == null ? [] : List<dynamic>.from(isLiked!.map((x) => x)),
      };
}
