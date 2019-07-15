//
//  TouchIDHandler.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/28.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OpenTouchIDAuthentication)(BOOL result, NSString *msg);
@interface TouchIDHandler : NSObject

@property (nonatomic, assign) BOOL openGlobleSwitchForTouchID;

+ (instancetype)sharedTouchIDHandler;

- (void)openTouchIDResult:(OpenTouchIDAuthentication)result;

- (BOOL)closeTouchID;
@end

NS_ASSUME_NONNULL_END
