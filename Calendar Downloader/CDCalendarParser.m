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

@interface CDCalendarParser()

{
    NSMutableArray *datesWithEvents;
    TFHpple *hppleParser;
}

//@property (nonatomic, strong) TFHppleElement *calendar;

@end

@implementation CDCalendarParser


//this is a public method that will return the an array of dates to be set to a calendar object
- (NSArray *)getCalendar {
    
    //if the download calendar returns that it has failed it aborts the calendar parsing (would cause errors) and returns nil
    if (![self downloadCalendar]) {
        
        //returns nil so the calendar object can tell get calendar has failed
        return nil;
        
    }
    
    //returns the calendar
    [self populateCalendar];
    
    //if everything was successful then we return the array of dates created in populateCalendar
    return datesWithEvents;
    
}


//downloads the cardinal newman website html, assigns it to the parser, and returns true if successful
- (BOOL)downloadCalendar {
    
    bool downloadSuccessful = true;
    
    BOOL isOffline = [[NSUserDefaults standardUserDefaults] boolForKey:@"offline_mode"];
    
    if (isOffline) {
        
        CDWebsiteForOfflineTesting* offline = [[CDWebsiteForOfflineTesting alloc] init];
        
        NSData *htmlData = offline.htmlData;
        hppleParser = [TFHpple hppleWithHTMLData:htmlData];
        
        NSLog(@"%d", isOffline);
        
        return true;
        
    }
    
    NSURL *calendarURL = [NSURL URLWithString:@"http://www.cardinalnewman.org/s/206/index_noHeader.aspx?sid=206&gid=1&pgid=936"];
    NSError *err = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:calendarURL encoding:NSUTF8StringEncoding error:&err];
        
    if (err) {
            
        downloadSuccessful = false;
        NSLog(@"an error has occured");
            
    }
            
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    hppleParser = [TFHpple hppleWithHTMLData:htmlData];
    
    return downloadSuccessful;
    
}

//this shit needs to be tamed (but it makes the magic happen)
- (void)populateCalendar {
    
    datesWithEvents = [[NSMutableArray alloc] init];
    
    //creates an array of all "div"s within the calendar section of the newman website html
    NSString *queryForUpperLevelDivs = @"//div[@style='clear:both;']/div";
    NSArray *upperLevelDivs = [hppleParser searchWithXPathQuery:queryForUpperLevelDivs];
    
    //declares variables to be used in the following do loop
    unsigned long numberOfUpperLevelDivs = upperLevelDivs.count;
    int numberOfCurrentDivSelected = 1;
    
    do {
        
        //creates date object that stuff will be added to in the following do loop
        //this will be "pinched" off after the following do loop is done and another will be created
        CDDate *newDate;
        
        //do loop for constucting new date and adding stuff to it
        do {
            
            //grabs next section of the calendar html — could be a separtor, kind of event, or a new date
            TFHppleElement *currentDiv = upperLevelDivs[numberOfCurrentDivSelected];
            
            //checks if current section is a date
            if ([self isDateDivForElement:currentDiv]) {
                
                //if so sets current date object's day/month data from the content in the element
                newDate = [self dateWithDataFromElement:currentDiv];
                
                //moves on to next section
                numberOfCurrentDivSelected++;
                
            }
            
            //checks if current section is an event
            if ([self isEventDivForElement:currentDiv]) {
                
                //my crappy stucture that returns a new date object from current date object and event
                newDate = [self addEventToDateWithElement:currentDiv AndCurrentDate:newDate];
                
                //moves on to next section
                numberOfCurrentDivSelected++;
                
                //if the current div is the last there will be no separator to tell us to add date
                //to array so we need to do it manually here
                if (numberOfCurrentDivSelected == numberOfUpperLevelDivs) {
                    
                    [self addDateToArray:newDate];
                    break;
                    
                }
                
            }
            
            //checks if current section is a separator
            if ([self isSeparatorDivForElement:currentDiv]) {
                
                //if it is a separator we know the date is done being created
                [self addDateToArray:newDate];
                numberOfCurrentDivSelected++;
                break;
                
            }
            
        } while (numberOfCurrentDivSelected < numberOfUpperLevelDivs); //terminates when we have reached the end
        
        
    } while (numberOfCurrentDivSelected < numberOfUpperLevelDivs); //terminates when we have reached the end
    
}


//used to create the new date object with initial config (date month etc)
- (CDDate*)dateWithDataFromElement:(TFHppleElement*)element {
    
    NSLog(@"performing actions on dateCal");
    
    //grabs subelements from date element
    TFHppleElement *monthElement = [element firstChildWithClassName:@"month"];
    TFHppleElement *dayElement = [element firstChildWithClassName:@"day"];
    TFHppleElement *weekdayElement = [element firstChildWithClassName:@"weekday"];
    
    //grabs strings from elements
    NSString *monthString = monthElement.text;
    NSString *dayString = dayElement.text;
    NSString *weekdayString = weekdayElement.text;
    
    //returns a date object created from data grabbed earlier
    return [[CDDate alloc] initWithMonth:monthString Day:dayString Weekday:weekdayString];
    
}


//puts date in array to be returned by getCalendar method
- (void)addDateToArray:(CDDate *)date {
    
    NSLog(@"added new item to date array with month: %@ date: %@ day: %@", date.month, date.day, date.weekday);
    [datesWithEvents addObject:date];

}


//takes current date object and appends a new event to it (also determines what kind of event it is)
- (CDDate *)addEventToDateWithElement:(TFHppleElement *)element AndCurrentDate:(CDDate *)currentDate {
    
    NSString *eventName;
    NSString *eventTime;
    NSURL *eventLink;
    
    NSString *eventClass = [self classForElement:element];
    
    //if its this kind of event it usually doesnt have a link
    if ([eventClass isEqualToString:@"eventItem"]) {
        
        TFHppleElement *text = [element firstChildWithClassName:@"text"];
        
        //tests if div with class text was there (if so we know it has no link)
        //all this stuff just kind of drills down you have to look at the website html w/
        //javascript turned off for this to make sense
        if (text) {
            
            TFHppleElement *title = [text firstChildWithClassName:@"title"];
            TFHppleElement *name = [title firstChild];
            
            TFHppleElement *time = [element firstChildWithClassName:@"time"];
            
            eventName = name.text;
            eventTime = time.text;
            
            [currentDate addEventWithName:eventName AndTime:eventTime];
            
        } else { //we know all other eventItems have links and are (probably) this format
            
            TFHppleElement *title = [element firstChildWithClassName:@"title"];
            TFHppleElement *aTag = [title firstChildWithTagName:@"a"];
            
            if (aTag) {
                
                NSURL *link = [NSURL URLWithString:[aTag objectForKey:@"href"]];
                
                eventName = aTag.text;
                eventLink = link;
                
                [currentDate addEventWithName:eventName AndTime:nil AndLink:eventLink];
                
            } else {
                
                TFHppleElement *titleSpan = [title firstChild];
                eventName = titleSpan.text;
                TFHppleElement *time = [element firstChildWithClassName:@"preview"];
                eventTime = time.text;
                
                [currentDate addEventWithName:eventName AndTime:eventTime];
                
            }
            
            
        }
        
    }
    
    //this kind of event has a link and needs to get that extracted
    if ([eventClass isEqualToString:@"eventItem scheduleItem"]) {
        
        
        TFHppleElement *title = [element firstChildWithClassName:@"title"];
        TFHppleElement *linkedTitle = [title firstChildWithTagName:@"a"];
        
        TFHppleElement *time = [element firstChildWithClassName:@"time"];
        
        eventTime = time.text;
        
        if (linkedTitle) {
            
            NSString *titleText = title.text;
            NSString *linkedTitleText = linkedTitle.text;
            NSString *link = [linkedTitle objectForKey:@"href"];
            
            eventLink = [NSURL URLWithString:link];
            
            eventName = [NSString stringWithFormat:@"%@%@", linkedTitleText, titleText];
            
            [currentDate addEventWithName:eventName AndTime:eventTime AndLink:eventLink];
            
        } else {
            
            eventName = title.text;
            
            [currentDate addEventWithName:eventName AndTime:eventTime];
            
        }
        
    }
    
    NSLog(@"added event to date with name: %@ and time: %@", eventName, eventTime);
    
    return currentDate;
    
}


//everything below here is to make the code look pretty - not commented because (I'm pretty sure) it can't break
- (BOOL)isDateDivForElement:(TFHppleElement *)element {
    
    NSString *elementClass = [self classForElement:element];
    
    if ([elementClass isEqualToString:@"dateCal"]) {
        
        return true;
        
    }
    
    return false;
    
}


- (BOOL)isEventDivForElement:(TFHppleElement *)element {
    
    NSString *elementClass = [self classForElement:element];
    
    if ([elementClass isEqualToString:@"eventItem"] || [elementClass isEqualToString:@"eventItem scheduleItem"]) {
        
        return true;
        
    }
    
    return false;
    
}


- (BOOL)isSeparatorDivForElement:(TFHppleElement *)element {
    
    NSString *elementClass = [self classForElement:element];
    
    if ([elementClass isEqualToString:@"clearBoth"]) {
        
        return true;
        
    }
    
    return false;
    
}


- (NSString *)classForElement:(TFHppleElement *)element {
    
    //creates dictionary of attributes of the current section of the calendar html and identifies what type it is.
    NSDictionary *elementAttributes = element.attributes;
    NSString *elementClass = elementAttributes[@"class"];
    
    return elementClass;
    
}


@end