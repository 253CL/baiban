import 'package:json_annotation/json_annotation.dart';

part 'shanYanPreNumberResult.g.dart';

@JsonSerializable()
class ShanYanPreNumberResult {
  // 返回码
  int? code;
  // 描述
  String? message;
  // 内层返回码
  int? innerCode;
  // 内层事件描述
  String? innerDesc;

  // 预取号
  String? number; //  脱敏手机号
  String? telecom; // 运营商：CMCC：移动 CUCC：联通 CTCC：电信
  String? protocolName; // 协议名
  String? protocolUrl; // 协议URL

  ShanYanPreNumberResult({this.code ,this.message ,this.innerCode ,this.innerDesc, this.number, this.telecom, this.protocolName, this.protocolUrl});

  //反序列化
  factory ShanYanPreNumberResult.fromJson(Map<String, dynamic> json) => _$ShanYanPreNumberResultFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ShanYanPreNumberResultToJson(this);
}