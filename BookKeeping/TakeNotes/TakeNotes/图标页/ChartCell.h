//
//  ChartCell.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/17.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *smallTypeIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *smallTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallTypeGroupMoney;

@end

NS_ASSUME_NONNULL_END
