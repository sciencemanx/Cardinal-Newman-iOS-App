//
//  CDWebsiteForOfflineTesting.m
//  CNHS
//
//  Created by Adam Van Prooyen on 2/3/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDWebsiteForOfflineTesting.h"

@implementation CDWebsiteForOfflineTesting

- (id)init {
    
    self = [super init];
    
    if (self) {
        NSError *err = nil;
        NSString *htmlStringPath = [[NSBundle mainBundle] pathForResource:@"/html" ofType:@"txt"];
        NSString *htmlString = [NSString stringWithContentsOfFile:htmlStringPath encoding:NSUTF8StringEncoding error:&err];
        self.htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"%@", htmlString);
    }
    
    return self;
    
}

@end
