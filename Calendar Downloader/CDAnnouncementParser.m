//
//  CDAnnouncementParser.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/15/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDAnnouncementParser.h"
#import "CDAnnouncement.h"

@interface CDAnnouncementParser ()

@property NSString *authToken;
@property NSURL *baseURL;

@end

@implementation CDAnnouncementParser


- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.baseURL = [NSURL URLWithString:@"https://api.twitter.com/"];
        [self getAuthorization];
        
    }
    
    return self;
    
}


- (void)getAuthorization {
    
    NSURL *getAuthURL = [NSURL URLWithString:@"oauth2/token" relativeToURL:self.baseURL];
    NSMutableURLRequest *getAuthRequest = [NSMutableURLRequest requestWithURL:getAuthURL];
    NSString *requestContent = @"grant_type=client_credentials";
    
    [getAuthRequest setHTTPMethod:@"POST"];
    [getAuthRequest setValue:@"Basic R1BqOUJPV0ZCUDRnREZUSU1iTm1GZzpKcXRVb3Z4b29sVFcxcjBGUnlQVHcwWWRyRzd3Rnp3OFpXNzdocw==" forHTTPHeaderField:@"Authorization"];
    [getAuthRequest setValue:@"application/x-www-form-urlencoded;charset=UTF_8" forHTTPHeaderField:@"Content-Type"];
    [getAuthRequest setHTTPBody:[requestContent dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:getAuthRequest returningResponse:&response error:&err];
    
    NSDictionary *getAuthResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    self.authToken = [getAuthResponse valueForKey:@"access_token"];
    NSLog(@"%@", self.authToken);
    
}


- (NSArray *)getAnnouncements {
    
    NSMutableArray *announcements = [[NSMutableArray alloc] init];
    
    NSArray *getTweetsResponse = [self getTweets];
    
    for (NSDictionary *tweetDictionary in getTweetsResponse) {
        CDAnnouncement *announcement = [[CDAnnouncement alloc] initWithContent:[tweetDictionary valueForKey:@"text"] andTime:[tweetDictionary valueForKey:@"created_at"]];
        [announcements addObject:announcement];
    }
    
    return announcements;
    
}


- (NSArray *)getTweets {
    
    NSURL *getTweetsURL = [NSURL URLWithString:@"1.1/statuses/user_timeline.json?count=10&exclude_replies=1&trim_user=1&screen_name=newmanasb" relativeToURL:self.baseURL];
    NSMutableURLRequest *getTweetsRequest = [NSMutableURLRequest requestWithURL:getTweetsURL];
    
    NSString *authString = [NSString stringWithFormat:@"Bearer %@", self.authToken];
    
    [getTweetsRequest setHTTPMethod:@"GET"];
    [getTweetsRequest setValue:authString forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:getTweetsRequest returningResponse:&response error:&err];
    
    return [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
}


@end
