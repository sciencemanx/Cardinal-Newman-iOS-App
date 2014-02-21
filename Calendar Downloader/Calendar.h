//
//  Calendar.h
//  CNHS
//
//  Created by Adam Van Prooyen on 2/20/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Date;

@interface Calendar : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *date;
@end

@interface Calendar (CoreDataGeneratedAccessors)

- (void)insertObject:(Date *)value inDateAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDateAtIndex:(NSUInteger)idx;
- (void)insertDate:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDateAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDateAtIndex:(NSUInteger)idx withObject:(Date *)value;
- (void)replaceDateAtIndexes:(NSIndexSet *)indexes withDate:(NSArray *)values;
- (void)addDateObject:(Date *)value;
- (void)removeDateObject:(Date *)value;
- (void)addDate:(NSOrderedSet *)values;
- (void)removeDate:(NSOrderedSet *)values;

@end
