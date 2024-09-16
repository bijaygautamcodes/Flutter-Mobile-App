import 'dart:convert';
import 'package:rootnode/model/comment/comment.dart';

class CommentResponse {
  CommentResponse({
    this.data,
    this.totalPages,
    this.currentPage,
  });

  Data? data;
  int? totalPages;
  int? currentPage;

  factory CommentResponse.fromRawJson(String str) =>
      CommentResponse.fromJson(json.decode(str));

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      CommentResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );
}

class Data {
  Data({
    this.comments,
    this.meta,
  });

  List<Comment>? comments;
  Meta? meta;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );
}

class Meta {
  Meta({
    this.isLiked,
  });

  List<bool>? isLiked;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        isLiked: json["isLiked"] == null
            ? []
            : List<bool>.from(json["isLiked"]!.map((x) => x)),
      );
}
