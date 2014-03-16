//
//  CDAnnouncement.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/15/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDAnnouncement.h"

@implementation CDAnnouncement


- (id)initWithContent:(NSString *)content andTime:(NSString *)time {
    
    self = [super init];
    
    if (self) {
        
        _content = content;
        _time = time;
        NSLog(@"Announcement created with content: %@ and time: %@", content, time);
        
    }
    
    return self;
    
}


@end
