//
//  CDAnnouncement.h
//  CNHS
//
//  Created by Adam Van Prooyen on 3/15/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDAnnouncement : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) UIImage *image;

- (id)initWithText:(NSString *)text andDate:(NSString *)date andTime:(NSString *)time andImage:(UIImage *)image;

+ (CDAnnouncement *)announcementWithText:(NSString *)text andDate:(NSString *)date andTime:(NSString *)time andImage:(UIImage *)image;

@end
