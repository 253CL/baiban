# 创蓝闪验SDK集成文档

<br>**更新日志**

| **SDK版本** | 更新日期       | 更新内容                                                                                                                                                                                                    |
|-----------|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| v1.1.2    | 2025.3.14  | 1.更新内置电信SDK，优化电信卡概率性Native Crash<br/>2.更新内置联通SDK，细化联通卡内层码410021，拆分新增下面 3 个：<br/>410022：不支持该服务，接口调用错误；<br/>410023：取号进行中，接口重复调用；<br/>410025：操作频繁,流控受限，稍后重试<br/>3.更新json_serializable、dart SDK、gradle工具等版本 |
| v1.1.1    | 2024.11.22 | 1.更新AndroidSDK到官网2.4.5.6版本；<br/>2.适配androidx.core:core:1.7.0                                                                                                                                            |
| v1.1.0    | 2024.6.13  | 增加是否获取通道IP的开关                                                                                                                                                                                           |
| ***       | ***        | ***                                                                                                                                                                                                     |

### 集成方式
在工程 pubspec.yaml 中加入 dependencies

- github集成
```dart
dependencies:
  shanyan:
    git:
      url: git://github.com/253CL/baiban.git
      path: shanyan
      ref: main
```
    或使用具体tag版本号：
```dart
dependencies:
  shanyan:
    git:
      url: git://github.com/253CL/baiban.git
      path: shanyan
      ref: v1.1.2
```
- 码云集成（已同步到码云，如github拉取超时，可换码云）
```dart
dependencies:
  shanyan:
    git:
      url: git://github.com/BeyondWg/shanyan_baiban.git
      path: shanyan
      ref: v1.1.2
```
### 使用

```dart
import 'package:shanyan/shanyan.dart';
```

### Android 开发环境搭建
​

**a.权限配置（AndroidManifest.xml文件里面添加权限）**

必要权限：


```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE"/>
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE"/>
```
配置权限说明

| **权限名称** | 权限说明 | 使用说明 |
| --- | --- | --- |
| INTERNET | 允许应用程序联网 | 用于访问网关和认证服务器 |
| ACCESS_WIFI_STATE | 允许访问WiFi网络状态信息 | 允许程序访问WiFi网络状态信息 |
| ACCESS_NETWORK_STATE | 允许访问网络状态 | 区分移动网络或WiFi网络 |
| CHANGE_NETWORK_STATE | 允许改变网络连接状态 | 设备在WiFi跟数据双开时，强行切换使用数据网络 |
| CHANGE_WIFI_STATE | 允许改变WiFi网络连接状态 | 设备在WiFi跟数据双开时，强行切换使用 |

**b.配置Android 对http协议的支持(任选其一)：**

方式①：


```xml
android:usesCleartextTraffic="true"
```
示例代码：

```xml
<application
    android:name=".view.MyApplication"
    ***
    android:usesCleartextTraffic="true"
    ></application>
```
方式②：
运营商个别接口为http请求，对于全局禁用Http的项目，需要设置Http白名单。以下为运营商http接口域名：cmpassport.com；10010.com

**c.混淆规则：**


```java
-dontwarn com.cmic.gen.sdk.**
        -keep class com.cmic.gen.sdk.**{*;}
        -dontwarn cn.com.chinatelecom.account.**
        -keep class cn.com.chinatelecom.account.**{*;}
        -keep class com.unicom.online.account.shield.** {*;}
        -keep class com.unicom.online.account.kernel.** {*;}
        -dontwarn org.bouncycastle.**
        -keep class org.bouncycastle.** { *;}
        -keep public class * extends android.app.Activity
        -keep  class com.chuanglan.shanyan_sdk.OneKeyLoginManager{
public  *;
        }
        -keep  class com.chuanglan.shanyan_sdk.tool.CheckAuthTool{
public  *;
        }
        -keep  class com.chuanglan.shanyan_sdk.listener.**{
public  *;
        }

```

通过上面的几个步骤，工程就配置完成了，接下来就可以在工程中使用闪验SDK进行开发了。


## 一、免密登录API使用说明


### 1.初始化

使用一键登录功能前，必须先进行初始化操作。

调用示例


```dart
ClShanyan.init(appId: "******").then((shanYanResult) {
      setState(() {
           _method = "初始化";
           _code = shanYanResult.code ?? 0;
           _msg = shanYanResult.message ?? "";
           _content = shanYanResult.toJson().toString();
     });
    print(shanYanResult.toJson().toString());
});
```



参数描述

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| appId | String | 闪验平台获取到的appId |

返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String | 内层事件描述 |
| token | String | token（初始化时返回空） |

### 2.预取号


- **建议在判断当前用户属于未登录状态时使用，已登录状态用户请不要调用该方法**
- **避免大量资源下载时调用，例如游戏中加载资源或者更新补丁的时候要顺序执行**



调用示例：


```dart
  ClShanyan.getPrePhoneInfo().then((shanYanResult) {
        setState(() {
        _method = "预取号";
        _code = shanYanResult.code ?? 0;
        _msg = shanYanResult.message ?? "";
        _content = shanYanResult.toJson().toString();
    });
    print(shanYanResult.toJson().toString());
 });
```


返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String | 内层事件描述 |
| number | String | 脱敏手机号 |
| telecom | String | 运营商类型 |
| protocolName | String | 运营商协议名称 |
| protocolUrl | String | 运营商协议链接 |

返回示例：
```java
{innerCode: 1022, innerDesc: 预取号成功, number: 173****4253, telecom: CTCC, protocolName: 天翼服务及隐私协议, protocolUrl: https://e.189.cn/sdk/agreement/detail.do?hidetop=true}
```
### 3.获取token


- 调用获取token应同步拉起运营商授权页面。
- **授权页具体规则参考 **[**官方文档**](https://sdk.253.com/document)** 上闪验相关部分**
- **授权页须包含一键登录按钮、运营商协议名称（可查看协议链接详情）、脱敏手机号**




调用示例：


```dart
ClShanyan.openLoginAuth().then((shanYanResult) {
    setState(() {
        _method = "获取token";
        _code = shanYanResult.code ?? 0;
        _msg = shanYanResult.message ?? "";
        _content = shanYanResult.toJson().toString();
    });
    print(shanYanResult.toJson().toString());
});
```



返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String | 内层事件描述 |
| token | String | token（成功情况下返回）用来后台置换手机号。token一次有效。 |



**


### 4.置换手机号


当一键登录外层code为1000时，您将获取到返回的参数，请将这些参数传递给后端开发人员，并参考「[服务端](https://flash.253.com/document/details?lid=300&cid=93&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK)」文档来实现获取手机号码的步骤。



**注意：如果添加布局为自定义控件，监听实现请参考demo示例。**
**


## 二、本机认证API使用说明



**注：本机认证同免密登录，需要初始化，本机认证、免密登录可共用初始化，两个功能同时使用时，只需调用一次初始化即可。**​


### 1.初始化

**同免密登录初始化**​


### 2.本机号校验



在初始化执行之后调用，本机号校验界面需自行实现，可以在多个需要校验的页面中调用。

调用示例：


```dart
//闪验SDK 本机号校验获取token (Android+iOS)
ClShanyan.localAuthentication().then((shanYanResult) {
    setState(() {
        _method = "本机号校验获取token";
        _code = shanYanResult.code ?? 0;
        _msg = shanYanResult.message ?? "";
        _content = shanYanResult.toJson().toString();
    });
    print(shanYanResult.toJson().toString());
});
```



返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String | 内层事件描述 |
| token | String | token（成功情况下返回）用来和后台校验手机号。一次有效。 |



### 3.校验手机号

当本机号校验外层code为2000时，您将获取到返回的参数，请将这些参数传递给后端开发人员，并参考「[服务端](http://flash.253.com/document/details?lid=300&cid=93&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK)」文档来实现校验本机号的步骤


## 三、返回码


该返回码为闪验SDK自身的返回码，请注意1003及1023错误内均含有运营商返回码，具体错误在碰到之后查阅「[返回码](http://flash.253.com/document/details?lid=301&cid=93&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK)」
