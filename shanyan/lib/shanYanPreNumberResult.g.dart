// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shanYanPreNumberResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShanYanPreNumberResult _$ShanYanPreNumberResultFromJson(
        Map<String, dynamic> json) =>
    ShanYanPreNumberResult(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      innerCode: (json['innerCode'] as num?)?.toInt(),
      innerDesc: json['innerDesc'] as String?,
      number: json['number'] as String?,
      telecom: json['telecom'] as String?,
      protocolName: json['protocolName'] as String?,
      protocolUrl: json['protocolUrl'] as String?,
    );

Map<String, dynamic> _$ShanYanPreNumberResultToJson(
        ShanYanPreNumberResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'innerCode': instance.innerCode,
      'innerDesc': instance.innerDesc,
      'number': instance.number,
      'telecom': instance.telecom,
      'protocolName': instance.protocolName,
      'protocolUrl': instance.protocolUrl,
    };
