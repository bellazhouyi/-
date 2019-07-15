//
//  A_BillTableHeader.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/15.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface A_BillTableHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outgoingMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

+ (instancetype)xibInstance;

@end

NS_ASSUME_NONNULL_END
