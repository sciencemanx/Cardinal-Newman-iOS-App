//
//  CDEventKitManager.h
//  CNHS
//
//  Created by Adam Van Prooyen on 3/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDEventKitManager : NSObject

- (void)addCalendarEventWithEventName:(NSString *)eventName AndEventTimeString:(NSString *)eventTimeString AndDateString:(NSString *)eventDateString;

@end
