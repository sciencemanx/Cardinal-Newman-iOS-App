//
//  CDStudentSchedule.m
//  CNHS
//
//  Created by Adam Van Prooyen on 2/8/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDStudentSchedule.h"
#import "CDCoreDataManager.h"

@interface CDStudentSchedule ()

{
    CDCoreDataManager *dataManager;
}

@property NSArray *classNames;
@property NSArray *periodStrings;
@property NSArray *allClassNames;
@property NSString *schedule;

@end

@implementation CDStudentSchedule

- (id)init {
    
    return nil;
    
}

- (id)initWithSchedule:(NSString *)scheduleType {
    
    self = [super init];
    
    if (self) {
        
        NSLog(@"executing custom init");
        
        dataManager = [[CDCoreDataManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchClassNames) name:@"Opened Document" object:nil];
    
    }
    
    return self;
    
}

- (void)fetchClassNames {
    
    NSLog(@"executing fetchClassNames");
    
    self.allClassNames = [dataManager getClasses];
    self.classNames = [self getClassNamesForScheduleType:self.schedule];
    self.periodStrings = [self getPeriodStringsForScheduleType:self.schedule];
    
}


- (NSArray *)getClassNamesForScheduleType:(NSString *)scheduleType {
    
    NSLog(@"executing getClassNamesForScheduleType");
    
    NSString *classOne = [self.allClassNames objectAtIndex:0];
    NSString *classTwo = [self.allClassNames objectAtIndex:1];
    NSString *classThree = [self.allClassNames objectAtIndex:2];
    NSString *classFour = [self.allClassNames objectAtIndex:3];
    NSString *classFive = [self.allClassNames objectAtIndex:4];
    NSString *classSix = [self.allClassNames objectAtIndex:5];
    NSString *classSeven = [self.allClassNames objectAtIndex:6];
    
    if ([scheduleType isEqualToString:@"A"]) {
        
        return @[classOne,
                 classTwo,
                 classThree,
                 classFour,
                 classFive,
                 classSix,
                 classSeven];
        
    }
    
    if ([scheduleType isEqualToString:@"B"]) {
        
        return @[classOne,
                 classThree,
                 classFive,
                 classSeven];
        
    }
    
    if ([scheduleType isEqualToString:@"C"]) {
        
        return @[classTwo,
                 classFour,
                 classSix];
        
    }
    
    if ([scheduleType isEqualToString:@"D"]) {
        
        return @[classSeven,
                 classFive,
                 classThree,
                 classOne];
        
    }
    
    if ([scheduleType isEqualToString:@"E"]) {
        
        return @[classSix,
                 classFour,
                 classTwo];
        
    }
    
    return @[];
    
}


- (NSArray *)getPeriodStringsForScheduleType:(NSString *)scheduleType {
    
    NSLog(@"exectuting getPeriodStringsForScheduleType");
    
    if ([scheduleType isEqualToString:@"A"]) {
        
        return @[@"Period 1",
                 @"Period 2",
                 @"Period 3",
                 @"Period 4",
                 @"Period 5",
                 @"Period 6",
                 @"Period 7"];
        
    }
    
    if ([scheduleType isEqualToString:@"B"]) {
        
        return @[@"Period 1",
                 @"Period 3",
                 @"Period 5",
                 @"Period 7"];
        
    }
    
    if ([scheduleType isEqualToString:@"C"]) {
        
        return @[@"Period 2",
                 @"Period 4",
                 @"Period 6",];
        
    }
    
    if ([scheduleType isEqualToString:@"D"]) {
        
        return @[@"Period 7",
                 @"Period 5",
                 @"Period 3",
                 @"Period 1"];
        
    }
    
    if ([scheduleType isEqualToString:@"E"]) {
        
        return @[@"Period 6",
                 @"Period 4",
                 @"Period 2"];
        
    }
    
    return @[];
    
}


- (NSString *)classNameForPeriodAtIndex:(NSInteger)index {
    
    return [self.classNames objectAtIndex:index];
    
}


- (NSString *)periodStringForPeriodAtIndex:(NSInteger)index {
    
    return [self.periodStrings objectAtIndex:index];
    
}


- (NSInteger)classesForSchedule {
    
    return [self.periodStrings count];
    
}


@end
