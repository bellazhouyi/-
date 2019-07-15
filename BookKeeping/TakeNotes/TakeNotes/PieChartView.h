//
//  PieChartView.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/16.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PieChartView : UIView
@property (weak, nonatomic) IBOutlet UILabel *centerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerMoneyLabel;

- (void)drawPieWithScaleArray:(nullable NSArray *)scaleArray colors:(nullable NSArray *)colors;

@end

NS_ASSUME_NONNULL_END
