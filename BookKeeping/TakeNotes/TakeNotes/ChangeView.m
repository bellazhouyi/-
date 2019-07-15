//
//  ChangeView.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/16.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "ChangeView.h"
#import <Masonry/Masonry.h>
@interface ChangeView ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *resourceTypeButtons;

@end

@implementation ChangeView

// storyboard中的vc添加xib的view 需要重写这个方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIView *containerView = [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:self options:nil] firstObject];
        CGRect newframe = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newframe;
        [self addSubview:containerView];
        
        for (UIButton *sender in self.resourceTypeButtons) {
            if (sender.tag == ResourceType_increase) {
                [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(sender.mas_centerX);
                    make.width.mas_equalTo(sender.bounds.size.width/2 + 4);
                    make.top.equalTo(sender.mas_bottom).offset(-3);
                    make.height.equalTo(@(1));
                }];
            }
        }
    }
    return self;
}

- (IBAction)touchChangeResourceAction:(UIButton *)sender {
    [UIView animateWithDuration:1.0 animations:^{
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIButton *sub in self.resourceTypeButtons) {
                if (sender.tag == sub.tag) {
                    sub.titleLabel.font = [UIFont systemFontOfSize:18];
                    [sub setTitleColor:kColorWithRGB(53, 115, 183) forState:UIControlStateNormal];
                    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(sender.mas_centerX);
                        make.width.mas_equalTo(sender.bounds.size.width/2 + 4);
                        make.top.equalTo(sender.mas_bottom).offset(-3);
                        make.height.equalTo(@(1));
                    }];
                }else {
                    sub.titleLabel.font = [UIFont systemFontOfSize:15];
                    [sub setTitleColor:kColorWithRGB(133, 133, 133) forState:UIControlStateNormal];
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(changingAnimatedBySender:)]) {
                [self.delegate changingAnimatedBySender:sender];
            }
        });
    }];
}

@end
