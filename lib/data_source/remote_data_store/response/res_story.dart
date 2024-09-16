import 'package:rootnode/model/story.dart';

class StoryResponse {
  StoryResponse({
    this.stories,
    this.totalPages,
    this.currentPage,
  });

  List<Story>? stories;
  int? totalPages;
  int? currentPage;

  factory StoryResponse.fromJson(Map<String, dynamic> json) => StoryResponse(
        stories: json["data"] == null
            ? []
            : List<Story>.from(json["data"]!.map((x) => Story.fromJson(x))),
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );
}
