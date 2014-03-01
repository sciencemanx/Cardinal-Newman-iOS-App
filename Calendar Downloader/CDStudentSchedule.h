//
//  CDStudentSchedule.h
//  CNHS
//
//  Created by Adam Van Prooyen on 2/8/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDStudentSchedule : NSObject

@property (strong, nonatomic) NSString *scheduleType;

//required init method
- (id)initWithSchedule:(NSString *)scheduleType;

//Accessor methods for UITableView in CDSchduleViewController
- (NSString *)periodStringForPeriodAtIndex:(NSInteger)index;
- (NSString *)classNameForPeriodAtIndex:(NSInteger)index;
- (NSInteger)classesForSchedule;

@end
