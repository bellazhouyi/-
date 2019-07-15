//
//  NSArray+Safety.m
//  FNMenu
//
//  Created by 航汇聚科技 on 2018/9/18.
//  Copyright © 2018年 Yi Zhou. All rights reserved.
//

#import "NSArray+Safety.h"

@implementation NSArray (Safety)

- (nullable id)safeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    id object = [self objectAtIndex:index];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    return object;
}

@end
