//
//  CDCalendarParser.m
//  CNHS
//
//  Created by Adam Van Prooyen on 2/3/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDCalendarParser.h"
#import "CDDate.h"
#import "CDEvent.h"
#import "TFHpple.h"
#import "CDWebsiteForOfflineTesting.h"
#define OFFLINE false

@interface CDCalendarParser()

{
    NSMutableArray *datesWithEvents;
    TFHpple *calendarParser;
}

@property (nonatomic, strong) TFHppleElement *calendar;

@end

@implementation CDCalendarParser


- (BOOL)downloadCalendar {
    
    bool errorOccured = false;
    
    if (!OFFLINE) {
        
        NSURL *calendarURL = [NSURL URLWithString:@"http://www.cardinalnewman.org/s/206/index_noHeader.aspx?sid=206&gid=1&pgid=936"];
        NSError *err = nil;
        NSString *htmlString = [NSString stringWithContentsOfURL:calendarURL encoding:NSUTF8StringEncoding error:&err];
        
        if (err) {
            
            errorOccured = true;
            NSLog(@"an error has occured");
            
        }
            
            NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
            calendarParser = [TFHpple hppleWithHTMLData:htmlData];
        
    } else {
        
        CDWebsiteForOfflineTesting *offlineWebsite = [[CDWebsiteForOfflineTesting alloc]init];
        calendarParser = [TFHpple hppleWithHTMLData:offlineWebsite.htmlData];
    
    }
    
    return !errorOccured;
    
}


- (NSArray *)getCalendar {
    
    [self findCalendar];
    [self populateCalendar];
    
    return datesWithEvents;
    
}


- (void)findCalendar {
    
    NSString *queryForCalendar = @"//div[@style='clear:both;']";
    self.calendar = [calendarParser peekAtSearchWithXPathQuery:queryForCalendar];
    
}


- (void)populateCalendar {
    
    datesWithEvents = [[NSMutableArray alloc] init];
    
    NSString *queryForUpperLevelDivs = @"//div[@style='clear:both;']/div";
    NSArray *upperLevelDivs = [calendarParser searchWithXPathQuery:queryForUpperLevelDivs];
    
    unsigned long numberOfUpperLevelDivs = upperLevelDivs.count;
    int numberOfCurrentDivSelected = 1;
    BOOL newDateObjectCreated = false;
    
    do {
        
        CDDate *newDateForDateArray = [CDDate alloc];
        
        do {
            
            TFHppleElement *currentDiv = upperLevelDivs[numberOfCurrentDivSelected];
            NSDictionary *currentDivAttributes = currentDiv.attributes;
            NSString *currentDivClass = currentDivAttributes[@"class"];
            
            if ([currentDivClass isEqualToString:@"dateCal"]) {
                
                newDateForDateArray = [self addDateDataToNewDateFromElement:currentDiv];
                
                numberOfCurrentDivSelected++;
                
            } else if ([currentDivClass isEqualToString:@"eventItem"] || [currentDivClass isEqualToString:@"eventItem scheduleItem"]) {
                
                newDateForDateArray = [self addEventToDateWithElement:currentDiv AndCurrentDate:newDateForDateArray AndClass:currentDivClass];
                
                numberOfCurrentDivSelected++;
                
                if (numberOfCurrentDivSelected == numberOfUpperLevelDivs) {
                    [self addDateToArray:newDateForDateArray];
                    newDateObjectCreated = true;
                }
                
            } else if ([currentDivClass isEqualToString:@"clearBoth"]) {
                
                [self addDateToArray:newDateForDateArray];
                numberOfCurrentDivSelected++;
                newDateObjectCreated = true;
                
            }
            
        } while ((!newDateObjectCreated) && (numberOfCurrentDivSelected < numberOfUpperLevelDivs));
        
        newDateObjectCreated = false;
        
    } while (numberOfCurrentDivSelected < numberOfUpperLevelDivs);
    
}


- (CDDate*)addDateDataToNewDateFromElement:(TFHppleElement*)element {
    
    NSLog(@"performing actions on dateCal");
    
    TFHppleElement *monthElement = [element firstChildWithClassName:@"month"];
    TFHppleElement *dayElement = [element firstChildWithClassName:@"day"];
    TFHppleElement *weekdayElement = [element firstChildWithClassName:@"weekday"];
    
    CDDate* newDateForDateArray = [self addDateDataToDatewithMonth:monthElement.text Day:dayElement.text Weekday:weekdayElement.text];
    
    return newDateForDateArray;
    
}


- (CDDate*)addDateDataToDatewithMonth:(NSString*)month Day:(NSString*)day Weekday:(NSString*)weekday {

    CDDate *newDateForDateArray = [[CDDate alloc] initWithMonth:month Day:day Weekday:weekday];
    return newDateForDateArray;

}


- (void)addDateToArray:(CDDate*)date {
    
    NSLog(@"added new item to date array with month: %@ date: %@ day: %@", date.month, date.day, date.weekday);
    [datesWithEvents addObject:date];

}


- (CDDate*)addEventToDateWithElement:(TFHppleElement*)eventElement AndCurrentDate:(CDDate*)currentDate AndClass:(NSString*)class {
    
    NSString *eventName;
    NSString *eventTime;
    
    if ([class isEqualToString:@"eventItem"]) {
        
        TFHppleElement *text = [eventElement firstChildWithClassName:@"text"];
        TFHppleElement *title = [text firstChildWithClassName:@"title"];
        TFHppleElement *name = [title firstChild];
        
        TFHppleElement *time = [eventElement firstChildWithClassName:@"time"];
        
        eventName = name.text;
        eventTime = time.text;
        
        [currentDate addEventWithName:eventName AndTime:eventTime];
        
    } else {
        
        
        TFHppleElement *title = [eventElement firstChildWithClassName:@"title"];
        TFHppleElement *linkedTitle = [title firstChildWithTagName:@"a"];
        
        TFHppleElement *time = [eventElement firstChildWithClassName:@"time"];
        
        eventTime = time.text;
        
        if (linkedTitle) {
            
            NSString *titleText = title.text;
            NSString *linkedTitleText = linkedTitle.text;
            NSString *link = [linkedTitle objectForKey:@"href"];
            
            NSURL *eventLink = [NSURL URLWithString:link];
            
            NSString *text = [NSString stringWithFormat:@"%@%@", linkedTitleText, titleText];
            
            eventName = text;
            
            [currentDate addEventWithName:eventName AndTime:eventTime AndLink:eventLink];
            
        } else {
            
            eventName = title.text;
            
            [currentDate addEventWithName:eventName AndTime:eventTime];
            
        }
        
    }
    
    NSLog(@"added event to date with name: %@ and time: %@", eventName, eventTime);
    
    return currentDate;
    
}


@end