// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      id: json['_id'] as String?,
      text: json['text'] as String?,
      to: json['to'] as String?,
      from: json['from'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'to': instance.to,
      'from': instance.from,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
