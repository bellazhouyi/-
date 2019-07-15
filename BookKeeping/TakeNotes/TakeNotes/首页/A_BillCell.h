//
//  A_BillCell.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/15.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const cellIdentifier = @"a_cell";
@interface A_BillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *smallTypeIcon;
@property (weak, nonatomic) IBOutlet UILabel *smallTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

NS_ASSUME_NONNULL_END
