//
//  CDTheNews.h
//  CNHS
//
//  Created by Adam Van Prooyen on 3/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDTheNews : NSObject

//Refreshes the news and returns true if successful
- (BOOL)getNews;

//Accessor Methods for UITableView
- (NSInteger)numberOfNewsItems;
- (NSString *)nameOfNewsAtIndex:(NSInteger)index;
- (BOOL)newsHasLinkAtIndex:(NSInteger)index;
- (NSURL *)linkOfNewsAtIndex:(NSInteger)index;
- (BOOL)newsHasImageURLAtIndex:(NSInteger)index;
- (NSURL *)imageURLOfNewsAtIndex:(NSInteger)index;
- (NSArray *)imageURLs;
- (NSArray *)imageURLsOfAmount:(NSInteger)amountOfImageURLs;

@end
