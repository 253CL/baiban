import 'dart:async';
import 'dart:io';

import 'package:shanyan/shanYanPreNumberResult.dart';
import 'package:shanyan/shanYanResult.dart';
import 'package:flutter/services.dart';

class ClShanyan {
  static const MethodChannel _channel =
      const MethodChannel('shanyan');

  // 获取iOS SDK版本
  static Future<String?> getShanyanVersion() async {
    if (Platform.isIOS || Platform.isAndroid) {
      final String? version = await _channel.invokeMethod('getShanyanVersion');
      return version;
    }
    return "";
  }

  ///闪验SDK 初始化(Android+iOS)
  static Future<ShanYanResult> init({required String appId}) async {
    if (Platform.isIOS || Platform.isAndroid) {
      Map result = await _channel.invokeMethod("init", {"appId": appId});
      Map<String, dynamic> newResult = new Map<String, dynamic>.from(result);
      return ShanYanResult.fromJson(newResult);
    }
    return ShanYanResult(code: 1003, message: "初始化失败,暂不支持此设备类型");
  }

  ///闪验SDK 预取号(Android+iOS)
  static Future<ShanYanPreNumberResult> getPrePhoneInfo() async {
    if (Platform.isIOS || Platform.isAndroid) {
      Map<dynamic, dynamic> result =
          await _channel.invokeMethod("getPrePhoneInfo");
      Map<String, dynamic> newResult = new Map<String, dynamic>.from(result);
      return ShanYanPreNumberResult.fromJson(newResult);
    }
    return ShanYanPreNumberResult(code: 1003, message: "预取号失败,暂不支持此设备类型");
  }

  ///闪验SDK 获取token(Android+iOS)
  static Future<ShanYanResult> openLoginAuth() async {
    if (Platform.isIOS || Platform.isAndroid) {
      Map<dynamic, dynamic> result =
          await _channel.invokeMethod("authentication");
      Map<String, dynamic> newResult = new Map<String, dynamic>.from(result);
      return ShanYanResult.fromJson(newResult);
    }
    return ShanYanResult(code: 1003, message: "获取token失败,暂不支持此设备类型");
  }

  ///闪验SDK 本机号校验获取token (Android+iOS)
  static Future<ShanYanResult> localAuthentication() async {
    if (Platform.isIOS || Platform.isAndroid) {
      Map<dynamic, dynamic> result =
          await _channel.invokeMethod("localAuthentication");
      Map<String, dynamic> newResult = new Map<String, dynamic>.from(result);
      return ShanYanResult.fromJson(newResult);
    }
    return ShanYanResult(code: 1003, message: "本机号校验失败,暂不支持此设备类型");
  }

  ///闪验SDK 清理缓存 (Android+iOS)
  static void clearScripCache() {
    if (Platform.isIOS || Platform.isAndroid) {
      _channel.invokeMethod("clearScripCache");
    }
  }

  ///闪验SDK 日志开关(默认关闭)(Android+iOS)
  static void printConsoleEnable({required bool enable}) {
    if (Platform.isIOS || Platform.isAndroid) {
      _channel.invokeMethod("printConsoleEnable", {"enable": enable});
    }
  }

  ///闪验SDK 设置预取号超时(Android+iOS)
  static void setPreGetPhonenumberTimeOut({required int preGetPhoneTimeOut}) {
    if (Platform.isIOS || Platform.isAndroid) {
      _channel.invokeMethod("setPreGetPhonenumberTimeOut",
          {"preGetPhoneTimeOut": preGetPhoneTimeOut});
    }
  }
  ///闪验SDK Android端获取预取号是否有缓存
  static Future<bool?> getScripCache() async {
    if (Platform.isAndroid) {
      final bool? isScripCache = await _channel.invokeMethod('getScripCache');
      return isScripCache;
    }
    return false;
  }
  ///闪验SDK 通道IP获取开关(默认开启)(Android)
  static void getIpEnable({required bool enable}) {
    if (Platform.isAndroid) {
      _channel.invokeMethod("getIEnable", {"enable": enable});
    }
  }
}
