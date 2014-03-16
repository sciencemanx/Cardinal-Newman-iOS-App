//
//  CDAnnouncement.h
//  CNHS
//
//  Created by Adam Van Prooyen on 3/15/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDAnnouncement : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;

- (id)initWithContent:(NSString *)content andTime:(NSString *)time;

@end
