//
//  CoreDataStackManager.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/21.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NSManagedObjectContext, NSManagedObjectModel, NSPersistentStoreCoordinator;

#define CoreDataStackManagerInstance [CoreDataStackManager shareInstance]

@interface CoreDataStackManager : NSObject
///单例
+ (CoreDataStackManager*)shareInstance;

///管理对象上下文
@property(strong,nonatomic) NSManagedObjectContext *managerContenxt;

///模型对象
@property(strong,nonatomic) NSManagedObjectModel *managerModel;

///存储调度器
@property(strong,nonatomic) NSPersistentStoreCoordinator *managerDinator;

//保存数据的方法
- (BOOL)save;

@end

NS_ASSUME_NONNULL_END
