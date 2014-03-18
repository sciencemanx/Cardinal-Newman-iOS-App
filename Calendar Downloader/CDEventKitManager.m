//
//  CDEventKitManager.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDEventKitManager.h"

@interface CDEventKitManager ()



@end

@implementation CDEventKitManager


/*- (void)addCalendarEventWithEventName:(NSString *)eventName AndEventTimeString:(NSString *)eventTimeString AndDateString:(NSString *)eventDateString {
    
    NSDate *dateForNewEvent = [self dateFromTime:eventTimeString AndDate:eventDateString];
    [self addEventWithName:eventName AndDate:dateForNewEvent];
    
}


- (NSDate *)dateFromTime:(NSString *)time AndDate:(NSString *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:m a EEEE, LLL dd yyyy"];
    
    NSString* timeAndDate = [NSString stringWithFormat:@"%@ %@ 2014", time, date];
    NSLog(@"%@", [formatter dateFromString:timeAndDate]);
    NSDate *dateCompontents = [formatter dateFromString:timeAndDate];
    
    
    return [formatter dateFromString:timeAndDate];
    
}


- (void)addEventWithName:(NSString *)name AndDate:(NSDate *)date {
    
    
    
}


- (void)addCalendarEvent {
    
    EKEventStore *eventStore= [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
       
        if (granted) {
            
            EKEvent *event = [EKEvent eventWithEventStore:eventStore];
            event.calendar = [eventStore defaultCalendarForNewEvents];
            event.title = @"new event";
            event.startDate = [NSDate date];
            event.endDate = [NSDate dateWithTimeInterval:3600 sinceDate:event.startDate];
            
        } else {
            
            
            
        }
        
    }];
    
}

- (EKEventViewController *)eventViewControllerForTime:(NSString *)time andName:(NSString *)name {
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
       
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.calendar = [eventStore defaultCalendarForNewEvents];
        
        return 0;
        
    }];
    
    return [[EKEventViewController alloc] init];
    
}*/


@end
