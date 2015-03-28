//
//  CDCalendar.m
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 2/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDCalendar.h"
#include "CDCalendarParser.h"
#import "CDDate.h"
#import "CDEvent.h"


@interface CDCalendar()

{

    CDCalendarParser *calendarParser;

}

@property (nonatomic)  NSArray *dateArray;

@end

@implementation CDCalendar

@synthesize dateArray;


- (id)init {
    
    self = [super init];
    
    if (self) {
        
        dateArray = [[NSMutableArray alloc]init];
        calendarParser = [[CDCalendarParser alloc] init];
        
    
    }
    
    return self;
    
}


- (BOOL)getCalendar {
    
    NSArray *getCalendarResult = [calendarParser getCalendar];
    
    if (getCalendarResult) {
        
        dateArray = getCalendarResult;
        return true;
        
    }
    
    return false;
    
}


//Accessor Methods for UITableView's


- (NSInteger)numberOfDays {
    
    return [dateArray count];

}


- (NSInteger)numberOfEventsFromDayAtIndex:(NSInteger)index {
    
    CDDate *dateWithEvents = dateArray[index];
    
    return [dateWithEvents.events count];
    
}


- (NSString*)nameOfEventAtDateIndex:(NSInteger)dateIndex AndEventIndex:(NSInteger)eventIndex {
    
    CDDate *dateAtIndex = dateArray[dateIndex];
    CDEvent *eventAtIndex = dateAtIndex.events[eventIndex];
    
    return eventAtIndex.name;
    
}


- (NSString*)timeOfEventAtDateIndex:(NSInteger)dateIndex AndEventIndex:(NSInteger)eventIndex {
    
    CDDate *dateAtIndex = dateArray[dateIndex];
    CDEvent *eventAtIndex = dateAtIndex.events[eventIndex];
    
    return eventAtIndex.time;
    
}

- (NSString*)dateAtIndex:(NSInteger)dateIndex {
    
    CDDate *dateAtIndex = dateArray[dateIndex];
    NSString *formattedDate = [NSString stringWithFormat:@"%@, %@ %@", dateAtIndex.weekday, dateAtIndex.month, dateAtIndex.day];
    
    return formattedDate;
    
}


- (BOOL)eventHasLinkAtDateIndex:(NSInteger)dateIndex andEventIndex:(NSInteger)eventIndex {
    
    BOOL hasLink = false;
    
    CDDate *dateAtIndex = dateArray[dateIndex];
    CDEvent *eventAtIndex = dateAtIndex.events[eventIndex];
    
    if (eventAtIndex.link) {
        
        hasLink = true;
    
    }
    
    return hasLink;
    
}


- (NSURL *)linkOfEventAtDateIndex:(NSInteger)dateIndex AndEventIndex:(NSInteger)eventIndex {

    CDDate *dateAtIndex = dateArray[dateIndex];
    CDEvent *eventAtIndex = dateAtIndex.events[eventIndex];
    
    return eventAtIndex.link;
    
}


@end