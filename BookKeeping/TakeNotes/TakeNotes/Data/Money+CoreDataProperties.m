//
//  Money+CoreDataProperties.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/31.
//  Copyright © 2019 BellaZhou. All rights reserved.
//
//

#import "Money+CoreDataProperties.h"

@implementation Money (CoreDataProperties)

+ (NSFetchRequest<Money *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Money"];
}

@dynamic bigType;
@dynamic money;
@dynamic moneyID;
@dynamic note;
@dynamic smallType;
@dynamic time;
@dynamic userID;
@dynamic weekStr;

@end
