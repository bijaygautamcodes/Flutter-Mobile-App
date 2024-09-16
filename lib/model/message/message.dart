import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  @Entity(realClass: Message)
  factory Message({
    @JsonKey(ignore: true) @Id(assignable: true) final int? mid,
    @Unique() @JsonKey(name: '_id') final String? id,
    final String? text,
    final String? to,
    final String? from,
    @Property(type: PropertyType.date) final DateTime? createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
