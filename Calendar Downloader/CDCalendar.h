//
//  CDCalendar.h
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 2/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CDCalendar : NSObject

//Refreshes the calendar and returns true if successful
- (BOOL)getCalendar;

//Accessor Methods for UITableView

- (NSInteger)numberOfDays;
- (NSInteger)numberOfEventsFromDayAtIndex:(NSInteger)index;
- (NSString *)nameOfEventAtDateIndex:(NSInteger)dateIndex AndEventIndex:(NSInteger)eventIndex;
- (NSString *)timeOfEventAtDateIndex:(NSInteger)dateIndex AndEventIndex:(NSInteger)eventIndex;
- (NSString *)dateAtIndex:(NSInteger)dateIndex;
- (BOOL)eventHasLinkAtDateIndex:(NSInteger)dateIndex andEventIndex:(NSInteger)eventIndex;
- (NSURL *)linkOfEventAtDateIndex:(NSInteger)dateIndex AndEventIndex:(NSInteger)eventIndex;


@end
