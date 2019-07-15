//
//  UIView+ResignFirstResponder.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/22.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "UIView+ResignFirstResponder.h"

@implementation UIView (ResignFirstResponder)

+ (void)resignTheFirstResponder {
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}
@end
