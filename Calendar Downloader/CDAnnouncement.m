//
//  CDAnnouncement.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/15/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDAnnouncement.h"

@implementation CDAnnouncement


- (id)initWithText:(NSString *)text andDate:(NSString *)date andTime:(NSString *)time andImage:(UIImage *)image{
    
    self = [super init];
    
    if (self) {
        
        _text = text;
        _time = time;
        _date = date;
        _image = image;
        NSLog(@"Announcement created with text: %@ and time: %@ and date: %@", text, time, date);
        
    }
    
    return self;
    
}


+ (CDAnnouncement *)announcementWithText:(NSString *)text andDate:(NSString *)date andTime:(NSString *)time andImage:(UIImage *)image{
    
    return [[CDAnnouncement alloc] initWithText:text andDate:date andTime:time andImage:image];
    
}


@end
