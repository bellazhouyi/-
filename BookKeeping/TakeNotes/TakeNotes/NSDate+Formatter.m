//
//  NSDate+Formatter.m
//  TakeNotes
//
//  Created by 航汇聚 on 2019/5/22.
//  Copyright © 2019 BellaZhou. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

- (NSString *)dateToStringByFormatterString:(NSString *)formatterString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:formatterString];
    return [formatter stringFromDate:self];
}

- (NSDate *)dateToDateByFormatterString:(NSString *)formatterString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:formatterString];
    NSString *string = [formatter stringFromDate:self];
    [formatter setDateFormat:formatterString];
    return [formatter dateFromString:string];
}

- (NSString *)dateToWeekString {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}
@end
