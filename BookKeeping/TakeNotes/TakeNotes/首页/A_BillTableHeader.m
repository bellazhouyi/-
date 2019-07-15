//
//  A_BillTableHeader.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/15.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "A_BillTableHeader.h"

@implementation A_BillTableHeader

+ (instancetype)xibInstance {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

@end
