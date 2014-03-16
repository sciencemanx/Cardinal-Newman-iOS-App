//
//  CDASBViewController.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/15/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDASBViewController.h"
#import "CDAnnouncementParser.h"
#import "CDAnnouncement.h"

@interface CDASBViewController () <UITableViewDataSource, UITableViewDelegate>

@property CDAnnouncementParser *announcementParser;
@property NSArray *announcements;

@end

@implementation CDASBViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.announcementParser = [[CDAnnouncementParser alloc] init];
    self.announcements = [[NSArray alloc] init];
    self.announcements = [self.announcementParser getAnnouncements];
    NSLog(@"%@", self.announcements[0]);

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.announcements count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell"];
    
    CDAnnouncement *announcement = [self.announcements objectAtIndex:indexPath.row];
    
    cell.textLabel.text = announcement.content;
    
    return cell;
    
}


@end
