//
//  CDDate.m
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 1/30/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDDate.h"
#import "CDEvent.h"

@implementation CDDate

@synthesize events;


- (id)initWithMonth:(NSString *)month Day:(NSString *)day Weekday:(NSString *)weekday {

    self = [super init];
    
    if (self) {
        self.month = month;
        self.day = day;
        self.weekday = weekday;
        events = [[NSMutableArray alloc]init];
    }
    
    return self;

}


- (void)addEventWithName:(NSString *)name AndTime:(NSString *)time {
    CDEvent *event = [[CDEvent alloc]initWithName:name AndTime:time];
    [events addObject:event];
}


- (void)addEventWithName:(NSString *)name AndTime:(NSString *)time AndLink:(NSURL *)link {
    CDEvent *event = [[CDEvent alloc] initWithName:name AndTime:time AndLink:link];
    [events addObject:event];
}


@end
