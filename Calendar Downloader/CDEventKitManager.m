//
//  CDEventKitManager.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDEventKitManager.h"
#import "EventKit/EventKit.h"

@implementation CDEventKitManager


- (void)addCalendarEventWithEventName:(NSString *)eventName AndEventTimeString:(NSString *)eventTimeString AndDateString:(NSString *)eventDateString {
    
    NSDate *dateForNewEvent = [self dateFromTime:eventTimeString AndDate:eventDateString];
    [self addEventWithName:eventName AndDate:dateForNewEvent];
    
}


- (NSDate *)dateFromTime:(NSString *)time AndDate:(NSString *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm "];
    
    NSString* timeAndDate = [NSString stringWithFormat:@"%@ %@", time, date];
    return [formatter dateFromString:timeAndDate];
    
}


- (void)addEventWithName:(NSString *)name AndDate:(NSDate *)date {
    
    
    
}


@end
