//
//  CDDate.h
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 1/30/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDDate : NSObject

@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *weekday;
@property (nonatomic, strong) NSMutableArray *events;

+ (id)dateWithMonth:(NSString*)month Day:(NSString*)day Weekday:(NSString*)weekday;
- (id)initWithMonth:(NSString*)month Day:(NSString*)day Weekday:(NSString*)weekday;
- (void)addEventWithName:(NSString*)name AndTime:(NSString*)time;
- (void)addEventWithName:(NSString *)name AndTime:(NSString *)time AndLink:(NSURL *)link;

@end
