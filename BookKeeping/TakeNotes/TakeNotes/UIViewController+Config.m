//
//  UIViewController+Config.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/15.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "UIViewController+Config.h"
#import "Money+CoreDataProperties.h"
#import "FetchRequestManager.h"
@implementation UIViewController (Config)
- (void)configOriginalUI {
    
}
- (NSArray *)allMoneyData {
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *result = [FetchRequestManager fetchByEntityName:NSStringFromClass([Money class]) predicateDesc:@"" sortDescriptors:@[dateDescriptor] isPredicate:NO];
    return result;
}
@end
