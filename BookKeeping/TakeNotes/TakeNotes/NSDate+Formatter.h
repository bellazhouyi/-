//
//  NSDate+Formatter.h
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/22.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Formatter)

- (NSString *)dateToStringByFormatterString:(NSString *)formatterString;

- (NSDate *)dateToDateByFormatterString:(NSString *)formatterString;

- (NSString *)dateToWeekString;
@end

NS_ASSUME_NONNULL_END
