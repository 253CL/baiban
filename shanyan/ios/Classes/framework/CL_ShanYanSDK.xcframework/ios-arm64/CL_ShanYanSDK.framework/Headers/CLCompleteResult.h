//
//  CLCompleteResult.h
//  CL_ShanYanSDK
//
//  Created by wanglijun on 2018/10/29.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CLCompleteResult;
typedef void(^CLComplete)(CLCompleteResult * completeResult);

@interface CLCompleteResult : NSObject
/// SDK外层code
@property (nonatomic,assign)NSInteger code;
/// SDK外层msg
@property (nonatomic,nullable,copy)NSString * message;
/// SDK外层data
@property (nonatomic,nullable,copy)NSDictionary * data;
/// Error
@property (nonatomic,nullable,strong)NSError * error;

/// SDK内层code
@property (nonatomic,assign)NSInteger innerCode;
/// SDK内层msg
@property (nonatomic,nullable,copy)NSString * innerDesc;

@property (nonatomic,assign)NSInteger clShanYanReportTag;

#ifdef DEBUG
@property (nonatomic,assign)NSTimeInterval debug_createTime;
#endif

+ (instancetype)clCompleteWithCode:(NSInteger)code message:(NSString *)message data:(nullable NSDictionary *)data error:(nullable NSError *)error;

- (void)fillPropertyInfo;

@end

NS_ASSUME_NONNULL_END
