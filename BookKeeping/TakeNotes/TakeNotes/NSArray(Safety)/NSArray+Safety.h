//
//  NSArray+Safety.h
//  FNMenu
//
//  Created by 航汇聚科技 on 2018/9/18.
//  Copyright © 2018年 Yi Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Safety)

- (nullable id)safeObjectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
