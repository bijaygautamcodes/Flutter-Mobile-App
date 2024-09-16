import 'package:rootnode/model/conn.dart';
import 'package:rootnode/model/user/user.dart';

class ConnResponse {
  ConnResponse({
    this.success,
    this.users,
    this.totalPages,
    this.currentPage,
  });

  bool? success;
  List<User>? users;
  int? totalPages;
  int? currentPage;

  factory ConnResponse.fromJson(Map<String, dynamic> json) => ConnResponse(
        success: json["success"],
        users: json["data"] == null
            ? []
            : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );
}

class ConnOverviewResponse {
  ConnOverviewResponse({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory ConnOverviewResponse.fromJson(Map<String, dynamic> json) =>
      ConnOverviewResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.old,
    this.recent,
    this.limit,
    this.count,
  });

  List<Node>? old;
  List<Node>? recent;
  int? limit;
  int? count;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        old: json["old"] == null
            ? []
            : List<Node>.from(json["old"]!.map((x) => Node.fromJson(x))),
        recent: json["recent"] == null
            ? []
            : List<Node>.from(json["recent"]!.map((x) => Node.fromJson(x))),
        limit: json["limit"],
        count: json["count"],
      );
}

class MyConnsResponse {
  MyConnsResponse(
      {this.success, this.totalPages, this.currentPage, this.conns});
  bool? success;
  int? totalPages;
  int? currentPage;
  List<Connection>? conns;
  factory MyConnsResponse.fromJson(Map<String, dynamic> json) =>
      MyConnsResponse(
        success: json["success"],
        conns: json["data"] == null
            ? []
            : List<Connection>.from(
                json["data"]!.map((x) => Connection.fromJson(x))),
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );
}

class Node {
  Node({
    this.user,
    this.date,
  });

  User? user;
  DateTime? date;

  factory Node.fromJson(Map<String, dynamic> json) => Node(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );
}
