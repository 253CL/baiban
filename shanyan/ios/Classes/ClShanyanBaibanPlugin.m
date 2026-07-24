#import "ClShanyanBaibanPlugin.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>

@implementation ClShanyanBaibanPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"shanyan"
            binaryMessenger:[registrar messenger]];
  ClShanyanBaibanPlugin* instance = [[ClShanyanBaibanPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getShanyanVersion" isEqualToString:call.method]) {
        result([CLShanYanSDKManager clShanYanSDKVersion]);
  }
  else if ([@"init" isEqualToString:call.method]) {
        [self init:call complete:result];
  }
  else if ([@"getPrePhoneInfo" isEqualToString:call.method]) {
        [self preGetPhonenumber:result];
  }
  else if ([@"authentication" isEqualToString:call.method]) {
        [CLShanYanSDKManager loginAuth:^(CLCompleteResult * _Nonnull completeResult) {
                NSLog(@"%@",completeResult.message);
                if (result) {
                    result([ClShanyanBaibanPlugin completeResultToJson:completeResult]);
                }
            }];
  }
  else if ([@"localAuthentication" isEqualToString:call.method]) {
        [CLShanYanSDKManager mobileCheckWithLocalPhoneNumberComplete:^(CLCompleteResult * _Nonnull completeResult) {
                NSLog(@"%@",completeResult.message);
                if (result) {
                    result([ClShanyanBaibanPlugin completeResultToJson:completeResult]);
                }
            }];
  }
  else if ([@"clearScripCache" isEqualToString:call.method]) {
      [CLShanYanSDKManager clearScripCache];
  }
  else if ([@"printConsoleEnable" isEqualToString:call.method]) {
        NSDictionary * argv = call.arguments;
        if (argv == nil || ![argv isKindOfClass:[NSDictionary class]]) {
             NSLog(@"请设置参数");
            return;
        }
         bool enable = [argv[@"enable"] boolValue];
        [CLShanYanSDKManager printConsoleEnable:enable];
  }
  else if ([@"setPreGetPhonenumberTimeOut" isEqualToString:call.method]) {
        NSDictionary * argv = call.arguments;
        if (argv == nil || ![argv isKindOfClass:[NSDictionary class]]) {
            NSLog(@"请设置参数");
            return;
        }
        int preGetPhoneTimeOut = [argv[@"preGetPhoneTimeOut"] intValue];
        [CLShanYanSDKManager setPreGetPhonenumberTimeOut:preGetPhoneTimeOut];
  }
  else {
        result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall*)call complete:(FlutterResult)complete {
    NSDictionary * argv = call.arguments;
    if (argv == nil || ![argv isKindOfClass:[NSDictionary class]]) {
        if (complete) {
            NSMutableDictionary * result = [NSMutableDictionary new];
            result[@"code"] = @(1001);
            result[@"message"] = @"请设置参数";
            complete(result);
        }
        return;
    }
    NSString * appId = argv[@"appId"];
    [CLShanYanSDKManager initWithAppId:appId complete:^(CLCompleteResult * _Nonnull completeResult) {
        if (complete) {
            complete([ClShanyanBaibanPlugin completeResultToJson:completeResult]);
        }
    }];
}

- (void)preGetPhonenumber:(FlutterResult)complete {
    [CLShanYanSDKManager preGetPhonenumber:^(CLCompleteResult * _Nonnull completeResult) {
        NSLog(@"%@",completeResult.message);
        if (complete) {
            complete([ClShanyanBaibanPlugin completePreNumberResultToJson:completeResult]);
        }
    }];
}

/**
 *int code; //返回码
 String message; //描述
 String innerCode; //内层返回码
 String innerDesc; //内层事件描述
 String token; //token
 */
+(NSDictionary *)completeResultToJson:(CLCompleteResult *)completeResult{
    NSMutableDictionary * result = [NSMutableDictionary new];
    if (completeResult.error != nil) {
        result[@"code"] = @(completeResult.code);
        result[@"message"] = completeResult.message;
        if (completeResult.innerCode != 0) {
            result[@"innerCode"] = @(completeResult.innerCode);
        }
        if ([completeResult.innerDesc isKindOfClass:NSString.class] && completeResult.innerDesc.length > 0) {
            result[@"innerDesc"] = completeResult.innerDesc;
        }
    }else{
        result[@"code"] = @(1000);
        result[@"message"] = completeResult.message;
        if (completeResult.innerCode != 0) {
            result[@"innerCode"] = @(completeResult.innerCode);
        }
        if ([completeResult.innerDesc isKindOfClass:NSString.class] && completeResult.innerDesc.length > 0) {
            result[@"innerDesc"] = completeResult.innerDesc;
        }
        if ([completeResult.data isKindOfClass:NSDictionary.class] && completeResult.data.count > 0) {
            result[@"token"] = completeResult.data[@"token"];
        }
    }
    return result;
}

+(NSDictionary *)completePreNumberResultToJson:(CLCompleteResult *)completeResult{
    NSMutableDictionary * result = [NSMutableDictionary new];
    if (completeResult.error != nil) {
        result[@"code"] = @(completeResult.code);
        result[@"message"] = completeResult.message;
        if (completeResult.innerCode != 0) {
            result[@"innerCode"] = @(completeResult.innerCode);
        }
        if ([completeResult.innerDesc isKindOfClass:NSString.class] && completeResult.innerDesc.length > 0) {
            result[@"innerDesc"] = completeResult.innerDesc;
        }
    }else{
        result[@"code"] = @(1000);
        result[@"message"] = completeResult.message;
        if (completeResult.innerCode != 0) {
            result[@"innerCode"] = @(completeResult.innerCode);
        }
        if ([completeResult.innerDesc isKindOfClass:NSString.class] && completeResult.innerDesc.length > 0) {
            result[@"innerDesc"] = completeResult.innerDesc;
        }
        if ([completeResult.data isKindOfClass:NSDictionary.class] && completeResult.data.count > 0) {
            result[@"number"] = completeResult.data[@"number"];
            result[@"telecom"] = completeResult.data[@"telecom"];
            result[@"protocolName"] = completeResult.data[@"protocolName"];
            result[@"protocolUrl"] = completeResult.data[@"protocolUrl"];
        }
    }
    return result;
}

@end
