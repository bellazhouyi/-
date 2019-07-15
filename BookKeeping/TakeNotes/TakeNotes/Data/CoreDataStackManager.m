//
//  CoreDataStackManager.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/21.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "CoreDataStackManager.h"
@import CoreData;
@implementation CoreDataStackManager

///单例的实现
+ (CoreDataStackManager*)shareInstance {
    static CoreDataStackManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataStackManager alloc] init];
    });
    
    return instance;
}

- (BOOL)save {  ///保存数据
    return [self.managerContenxt save:nil];
}

- (NSURL*)getDocumentUrlPath {
    ///获取文件位置
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]
    ;
}

#pragma mark - getter
//懒加载managerContenxt
- (NSManagedObjectContext *)managerContenxt {
    if (_managerContenxt != nil) {
        
        return _managerContenxt;
    }
    
    _managerContenxt = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    ///设置存储调度器
    [_managerContenxt setPersistentStoreCoordinator:self.managerDinator];
    
    return _managerContenxt;
}

///懒加载模型对象
- (NSManagedObjectModel *)managerModel {
    
    if (_managerModel != nil) {
        
        return _managerModel;
    }
    
    _managerModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managerModel;
}

- (NSPersistentStoreCoordinator *)managerDinator {
    if (_managerDinator != nil) {
        
        return _managerDinator;
    }
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@YES,NSInferMappingModelAutomaticallyOption, @YES,NSMigratePersistentStoresAutomaticallyOption, nil];
    _managerDinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managerModel];
    
    //添加存储器
    /**
     * type:一般使用数据库存储方式NSSQLiteStoreType
     * configuration:配置信息 一般无需配置
     * URL:要保存的文件路径
     * options:参数信息 一般无需设置
     */
    
    //拼接url路径
    NSURL *url = [[self getDocumentUrlPath] URLByAppendingPathComponent:@"sqlit.db" isDirectory:YES];
    
    [_managerDinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:nil];
    
    return _managerDinator;
}


@end
