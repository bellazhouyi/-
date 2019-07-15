//
//  Account+CoreDataProperties.m
//  
//
//  Created by 航汇聚 on 2019/5/20.
//
//

#import "Account+CoreDataProperties.h"

@implementation Account (CoreDataProperties)

+ (NSFetchRequest<Account *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Account"];
}

@dynamic userID;
@dynamic name;

@end
