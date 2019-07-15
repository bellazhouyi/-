//
//  Account+CoreDataProperties.h
//  
//
//  Created by 航汇聚 on 2019/5/20.
//
//

#import "Account+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Account (CoreDataProperties)

+ (NSFetchRequest<Account *> *)fetchRequest;

@property (nonatomic) int16_t userID;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
