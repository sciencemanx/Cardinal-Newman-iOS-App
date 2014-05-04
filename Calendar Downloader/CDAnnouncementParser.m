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
        
    }
    
    return self;
    
}


- (BOOL)getAuthorization {
    
    NSURL *getAuthURL = [NSURL URLWithString:@"oauth2/token" relativeToURL:self.baseURL];
    NSMutableURLRequest *getAuthRequest = [NSMutableURLRequest requestWithURL:getAuthURL];
    NSString *requestContent = @"grant_type=client_credentials";
    
    [getAuthRequest setHTTPMethod:@"POST"];
    [getAuthRequest setValue:@"Basic R1BqOUJPV0ZCUDRnREZUSU1iTm1GZzpKcXRVb3Z4b29sVFcxcjBGUnlQVHcwWWRyRzd3Rnp3OFpXNzdocw=="
          forHTTPHeaderField:@"Authorization"];
    [getAuthRequest setValue:@"application/x-www-form-urlencoded;charset=UTF_8"
          forHTTPHeaderField:@"Content-Type"];
    [getAuthRequest setHTTPBody:[requestContent dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:getAuthRequest returningResponse:&response error:&err];
    
    NSDictionary *getAuthResponse;
    if (responseData) getAuthResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    
    self.authToken = [getAuthResponse valueForKey:@"access_token"];
    if (self.authToken) {
        return YES;
    }
    return NO;
    
}


- (NSArray *)getAnnouncements {
    
    [self getAuthorization];
    
    NSMutableArray *announcements = [[NSMutableArray alloc] init];
    
    NSArray *getTweetsResponse = [self getTweets];
    
    for (NSDictionary *tweetDictionary in getTweetsResponse) {
        
        NSString *tweetText = [tweetDictionary valueForKey:@"text"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setAMSymbol:@"AM"];
        [formatter setPMSymbol:@"PM"];
        [formatter setDateFormat:@"E LLL dd HH:mm:ss Z yyyy"];

        NSString *dateString = [tweetDictionary valueForKey:@"created_at"];
        NSDate *date = [formatter dateFromString:dateString];
                
        NSLog(@"date string: %@", dateString);
        NSLog(@"date: %@", date);
        
        [formatter setDateFormat:@"MMM d"];
        NSString *tweetDate = [formatter stringFromDate:date];
        
        [formatter setDateFormat:@"h:mm a"];
        NSString *tweetTime = [formatter stringFromDate:date];
        
        NSDictionary *userDictionary = [tweetDictionary valueForKey:@"user"];
        
        NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[userDictionary valueForKey:@"profile_image_url"]]];
        
        NSLog(@"key: %@", [userDictionary valueForKey:@"profile_image_url"]);
        
        NSData *tweetImageData = [NSURLConnection sendSynchronousRequest:imageRequest returningResponse:Nil error:nil];
        UIImage *tweetImage = [UIImage imageWithData:tweetImageData];
        
        CDAnnouncement *announcement = [CDAnnouncement announcementWithText:tweetText andDate:tweetDate andTime:tweetTime andImage:tweetImage];
        [announcements addObject:announcement];
        
        //NSLog(@"twitter object: %@", tweetDictionary);
        
    }
    
    return (announcements.count) ? announcements : nil;
    
}


- (NSArray *)getTweets {
    
    NSURL *getTweetsURL = [NSURL URLWithString:@"1.1/statuses/user_timeline.json?count=10&exclude_replies=1&trim_user=0&screen_name=newmanasb"
                                 relativeToURL:self.baseURL];
    NSMutableURLRequest *getTweetsRequest = [NSMutableURLRequest requestWithURL:getTweetsURL];
    
    NSString *authString = [NSString stringWithFormat:@"Bearer %@", self.authToken];
    
    [getTweetsRequest setHTTPMethod:@"GET"];
    [getTweetsRequest setValue:authString forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:getTweetsRequest returningResponse:&response error:&err];
    
    NSArray *json;
    if (responseData) json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
    return json;
    
}


@end
