import 'package:rootnode/model/post.dart';

class PostResponse {
  PostResponse({
    this.data,
    this.totalPages,
    this.currentPage,
  });

  Posts? data;
  int? totalPages;
  int? currentPage;

  factory PostResponse.fromJson(Map<String, dynamic> json) => PostResponse(
        data: json["data"] == null ? null : Posts.fromJson(json["data"]),
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );
}

class Posts {
  Posts({this.posts, this.meta});
  List<Post>? posts;
  Meta? meta;

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        posts: json["feed"] == null
            ? []
            : List<Post>.from(json["feed"]!.map((x) => Post.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );
}
