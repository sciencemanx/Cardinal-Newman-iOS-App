//
//  CDTheNews.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDTheNews.h"
#import "CDNews.h"
#import "CDNewsParser.h"


@interface CDTheNews ()

{
    CDNewsParser *newsParser;
}

@property NSArray *newsItems;

@end


@implementation CDTheNews


- (id)init {
    
    self = [super init];
    
    if (self) {
        
        newsParser = [[CDNewsParser alloc] init];
        self.newsItems = [[NSArray alloc] init];
        
    }
    
    return self;
    
}


- (BOOL)getNews {
    
    self.newsItems = [newsParser getNews];
    
    if (self.newsItems) {
        
        return true;
        
    }
    
    return false;
    
}


//UITableView Accessor Methods
- (NSInteger)numberOfNewsItems {
    
    return [self.newsItems count];
    
}


- (NSString *)nameOfNewsAtIndex:(NSInteger)index {
    
    CDNews *news = [self.newsItems objectAtIndex:index];
    
    return news.name;
    
}


- (BOOL)newsHasLinkAtIndex:(NSInteger)index {
    
    CDNews *news = [self.newsItems objectAtIndex:index];
    
    if (news.link) {
        
        return true;
        
    }
    
    return false;
    
}


- (NSURL *)linkOfNewsAtIndex:(NSInteger)index {
    
    CDNews *news = [self.newsItems objectAtIndex:index];
    
    return news.link;
    
}


- (BOOL)newsHasImageURLAtIndex:(NSInteger)index {
    
    CDNews *news = [self.newsItems objectAtIndex:index];
    
    if (news.imageURL) {
        
        return true;
        
    }
    
    return false;
    
}


- (NSURL *)imageURLOfNewsAtIndex:(NSInteger)index {
    
    CDNews *news = [self.newsItems objectAtIndex:index];
    
    return news.imageURL;
    
}


@end
