//
//  ChangeView.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/16.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ResourceType) {
    ResourceType_increase = 1000,
    ResourceType_decrease = 1001
};
@protocol ChangeViewDelegate <NSObject>

@optional
- (void)changingAnimatedBySender:(UIButton *)sender;

@end
IB_DESIGNABLE
@interface ChangeView : UIView

@property (nonatomic, weak) id<ChangeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
