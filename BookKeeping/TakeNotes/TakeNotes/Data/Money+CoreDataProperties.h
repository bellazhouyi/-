//
//  Money+CoreDataProperties.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/31.
//  Copyright © 2019 BellaZhou. All rights reserved.
//
//

#import "Money+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Money (CoreDataProperties)

+ (NSFetchRequest<Money *> *)fetchRequest;

@property (nonatomic) int16_t bigType;
@property (nonatomic) float money;
@property (nullable, nonatomic, copy) NSString *moneyID;
@property (nullable, nonatomic, copy) NSString *note;
@property (nonatomic) int16_t smallType;
@property (nullable, nonatomic, copy) NSDate *time;
@property (nonatomic) int16_t userID;
@property (nullable, nonatomic, copy) NSString *weekStr;

@end

NS_ASSUME_NONNULL_END
