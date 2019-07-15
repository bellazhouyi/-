//
//  TouchIDHandler.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/28.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "TouchIDHandler.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchIDHandler ()

@property (nonatomic, strong) LAContext *context;

@end

@implementation TouchIDHandler

+ (instancetype)sharedTouchIDHandler {
    static TouchIDHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TouchIDHandler new];
        
        instance.context = [LAContext new];
        instance.context.localizedCancelTitle = @"录入指纹";
    });
    return instance;
}
- (void)openTouchIDResult:(OpenTouchIDAuthentication)result {
    NSDate *lastDate = [kStandardUserDefaults valueForKey:@"touchIDTime"];
    if (!lastDate) {
        [kStandardUserDefaults setValue:[NSDate date] forKey:@"touchIDTime"];
    }else {
        NSLog(@"时间戳：%f",[self pleaseInsertStarTime:lastDate andInsertEndTime:[NSDate date]]);
        if ([self pleaseInsertStarTime:lastDate andInsertEndTime:[NSDate date]] / 60 < 15) {
            return;
        }else {
            [kStandardUserDefaults setValue:[NSDate date] forKey:@"touchIDTime"];
        }
    }
    //首先判断版本
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        NSLog(@"系统版本不支持TouchID");
        result(NO,@"");
    }
    NSError *err = nil;
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err]) {
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"TouchID 验证成功");
                    result(YES,@"");
                });
            }else if (error) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"TouchID 验证失败");
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"TouchID 被用户手动取消");
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"用户不使用TouchID,选择手动输入密码");
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"TouchID 无法启动,因为用户没有设置密码");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"TouchID 无法启动,因为用户没有设置TouchID");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"TouchID 无效");
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result(NO,@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                        });
                    }
                        break;
                    default:
                        break;
                }
            }else {
                result(NO,@"当前设备不支持TouchID");
            }
        }];
    }
    result(NO,@"");
}
#pragma mark - private
- (NSTimeInterval)pleaseInsertStarTime:(NSDate *)startDate andInsertEndTime:(NSDate *)endDate{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//根据自己的需求定义格式
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}
#pragma mark - setter
- (void)setOpenGlobleSwitchForTouchID:(BOOL)openGlobleSwitchForTouchID {
    [kStandardUserDefaults setValue:@(openGlobleSwitchForTouchID) forKey:@"openGlobleSwitchForTouchID"];
}
#pragma mark - getter
- (BOOL)openGlobleSwitchForTouchID {
    return [[kStandardUserDefaults valueForKey:@"openGlobleSwitchForTouchID"] boolValue];
}
@end
