//
//  CDNewsParser.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDNewsParser.h"
#import "TFHpple.h"
#import "CDNews.h"

@interface CDNewsParser()

{
    NSMutableArray *theNews;
    TFHpple *hppleParser;
}

@end

@implementation CDNewsParser


//this is a public method that will return the an array of news items to be set to a news object
- (NSArray *)getNews {
    
    //if the download news returns that it has failed it aborts the calendar parsing (would cause errors) and returns nil
    if (![self downloadNews]) {
        
        //returns nil so the news object can tell get news has failed
        return nil;
        
    }
    
    //returns the news
    [self populateNews];
    
    //if everything was successful then we return the array of news items created in populateNews
    return theNews;
    
}


//downloads the cardinal newman website html, assigns it to the parser, and returns true if successful
- (BOOL)downloadNews {
    
    bool downloadSuccessful = true;
    
    NSURL *calendarURL = [NSURL URLWithString:@"http://www.cardinalnewman.org/s/206/index.aspx?sid=206&gid=1&pgid=873"];
    NSError *err = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:calendarURL encoding:NSUTF8StringEncoding error:&err];
    
    if (err) {
        
        downloadSuccessful = false;
        NSLog(@"an error has occured");
        
    }
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    hppleParser = [TFHpple hppleWithHTMLData:htmlData];
    
    return downloadSuccessful;
    
}


//this shit needs to be tamed (but it makes the magic happen)
- (void)populateNews {
    
    theNews = [[NSMutableArray alloc] init];
    
    //creates an array of all "div"s within the news section of the newman website html
    NSString *queryForUpperLevelDivs = @"//div[@style='clear:both;']/div";
    NSArray *upperLevelDivs = [hppleParser searchWithXPathQuery:queryForUpperLevelDivs];
    
    //declares variables to be used in the following do loop
    unsigned long numberOfUpperLevelDivs = upperLevelDivs.count;
    int numberOfCurrentDivSelected = 0;
    
    do {
        
        //creates news item object that stuff will be added to in the following do loop
        CDNews *newNews = [[CDNews alloc] init];
    
        //grabs next section of the news html - will only be a news item
        TFHppleElement *currentDiv = upperLevelDivs[numberOfCurrentDivSelected];
        
        TFHppleElement *thumbnail = [[currentDiv firstChildWithClassName:@"thumbnail"] firstChildWithTagName:@"a"];
        
        TFHppleElement *text = [currentDiv firstChildWithClassName:@"text"];
        
        TFHppleElement *title = [[text firstChildWithClassName:@"title"] firstChildWithTagName:@"a"];
        TFHppleElement *preview = [[text firstChildWithClassName:@"preview"] firstChildWithTagName:@"a"];
        
        newNews.name = title.text;
        newNews.imageURL = [NSURL URLWithString:[thumbnail objectForKey:@"href"]];
        
        if ([preview objectForKey:@"href"]) {
            
            newNews.link = [NSURL URLWithString:[preview objectForKey:@"href"]];
            
        } else newNews.link = [NSURL URLWithString:[title objectForKey:@"href"]];
        
        [self addNewsItemToArray:newNews];
        
        numberOfCurrentDivSelected++;
        
    } while (numberOfCurrentDivSelected < numberOfUpperLevelDivs); //terminates when we have reached the end
    
}


//puts news in array to be returned by getNews method
- (void)addNewsItemToArray:(CDNews *)news {
    
    NSLog(@"added news item to news array with title: %@ link: %@ image URL: %@", news.name, news.link, news.imageURL);
    [theNews addObject:news];
    
}


@end