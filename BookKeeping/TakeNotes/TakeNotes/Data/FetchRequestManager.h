//
//  FetchRequestManager.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/21.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FetchRequestManager : NSObject

+ (NSArray *)fetchByEntityName:(NSString *)entityName
                 predicateDesc:(NSString *)predicateDesc
               sortDescriptors:(NSArray *)sortDescriptors
                   isPredicate:(BOOL)isPredicate;

+ (BOOL)deleteByEntityName:(NSString *)entityName
             predicateDesc:(NSString *)predicateDesc;

@end

NS_ASSUME_NONNULL_END
