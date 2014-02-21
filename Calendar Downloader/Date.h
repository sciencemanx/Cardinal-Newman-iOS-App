//
//  Date.h
//  CNHS
//
//  Created by Adam Van Prooyen on 2/20/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Calendar, Event;

@interface Date : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * weekday;
@property (nonatomic, retain) Calendar *calendar;
@property (nonatomic, retain) NSSet *event;

@end

@interface Date (CoreDataGeneratedAccessors)

- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvent:(NSSet *)values;
- (void)removeEvent:(NSSet *)values;

@end
