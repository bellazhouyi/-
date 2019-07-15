//
//  MoneyModel.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/23.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyModel : NSObject
@property (nonatomic, assign) float money;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, assign) int bigType;
@property (nonatomic, assign) int userID;
@property (nonatomic, assign) int smallType;
@property (nonatomic, copy) NSString *moneyID;
@property (nonatomic, copy) NSString *weekStr;
@end

NS_ASSUME_NONNULL_END
