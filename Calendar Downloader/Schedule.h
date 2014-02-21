//
//  Schedule.h
//  CNHS
//
//  Created by Adam Van Prooyen on 2/20/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSString * class1;
@property (nonatomic, retain) NSString * class2;
@property (nonatomic, retain) NSString * class3;
@property (nonatomic, retain) NSString * class4;
@property (nonatomic, retain) NSString * class5;
@property (nonatomic, retain) NSString * class6;
@property (nonatomic, retain) NSString * class7;
@property (nonatomic, retain) Student *student;

@end
