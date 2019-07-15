//
//  FetchRequestManager.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/21.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "FetchRequestManager.h"
@import CoreData;
#import "CoreDataStackManager.h"
@implementation FetchRequestManager

+ (NSArray *)fetchByEntityName:(NSString *)entityName
                 predicateDesc:(NSString *)predicateDesc
               sortDescriptors:(NSArray *)sortDescriptors
                   isPredicate:(BOOL)isPredicate{
    //1.创建一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    if (isPredicate) {
        //2.创建查询谓词（查询条件）
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateDesc];
        //3.给查询请求设置谓词
        request.predicate = predicate;
        //4.查询数据
        return [CoreDataStackManagerInstance.managerContenxt executeFetchRequest:request error:nil];
    }else {
        request.sortDescriptors = sortDescriptors;
        NSAsynchronousFetchResult *result = [[CoreDataStackManager shareInstance].managerContenxt executeRequest:request error:nil];
        return result.finalResult;
    }
}

+ (BOOL)deleteByEntityName:(NSString *)entityName
             predicateDesc:(NSString *)predicateDesc {
    //1.创建一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    //2.创建查询谓词（查询条件）
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateDesc];
    //3.给查询请求设置谓词
    request.predicate = predicate;
    //4.查询数据
    NSArray<NSManagedObject*> *arr = [CoreDataStackManagerInstance.managerContenxt executeFetchRequest:request error:nil];
    //5.删除数据
    [CoreDataStackManagerInstance.managerContenxt deleteObject:arr.firstObject];
    //6.同步到数据库
    return [CoreDataStackManagerInstance save];
}

@end
