//
//  CDEvent.h
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 1/30/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDEvent : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSURL *link;

- (id)initWithName:(NSString*)name AndTime:(NSString*)time;
- (id)initWithName:(NSString *)name AndTime:(NSString *)time AndLink:(NSURL *)link;

@end
