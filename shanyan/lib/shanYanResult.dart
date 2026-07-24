import 'package:json_annotation/json_annotation.dart';

part 'shanYanResult.g.dart';

@JsonSerializable()
class ShanYanResult {
  // 返回码
  int? code;
  // 描述
  String? message;
  // 内层返回码
  int? innerCode;
  // 内层事件描述
  String? innerDesc;
  // token
  String? token;

  ShanYanResult({this.code ,this.message ,this.innerCode ,this.innerDesc,this.token});

  //反序列化
  factory ShanYanResult.fromJson(Map<String, dynamic> json) => _$ShanYanResultFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ShanYanResultToJson(this);
}