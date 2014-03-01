//
//  CDCoreDataManager.h
//  CNHS
//
//  Created by Adam Van Prooyen on 2/13/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDCoreDataManager : NSObject

//used to begin and end CDCoreDatManager lifecycle
- (void)openDocument;
- (void)closeDocument;

//print data for debuggin purposes
- (void)printData;

//add student schedule at welcome screen
- (void)addScheduleToDatabaseWithSchedule:(NSDictionary *)schedule;

- (NSArray *)getClasses;

@end
