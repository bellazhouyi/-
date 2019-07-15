//
//  SearchResultViewController.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/6/8.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController

@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic, assign) int16_t searchForBigType;
@property (nonatomic, assign) int16_t searchForSmallType;

@end

NS_ASSUME_NONNULL_END
