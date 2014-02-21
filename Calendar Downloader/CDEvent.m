//
//  CDEvent.m
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 1/30/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDEvent.h"

@implementation CDEvent

- (id)initWithName:(NSString *)name AndTime:(NSString *)time {
    
    self = [super init];
    
    if (self) {
        
        self.name = name;
        self.time = time;
    
    }
    
    return self;
    
}


- (id)initWithName:(NSString *)name AndTime:(NSString *)time AndLink:(NSURL *)link {
    
    self = [super init];
    
    if (self) {
        
        self.name = name;
        self.time = time;
        self.link = link;
    
    }
    
    return self;
    
}


@end
