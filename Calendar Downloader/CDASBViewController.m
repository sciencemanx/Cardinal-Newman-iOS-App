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
@property (weak, nonatomic) IBOutlet UITableView *announcementTable;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CDASBViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.announcementParser = [[CDAnnouncementParser alloc] init];
    self.announcements = [[NSArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAnnouncements) forControlEvents:UIControlEventValueChanged];
    [self.announcementTable addSubview:self.refreshControl];
    
    [self setupActivityView];
    
    [self.loading startAnimating];
    
    [self refreshAnnouncements];

}


- (void)setupActivityView {
    
    self.loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loading.center = self.view.center;
    self.loading.hidesWhenStopped = YES;
    self.loading.color = [UIColor blackColor];
    [self.view addSubview:self.loading];
    [self.loading bringSubviewToFront:self.view];

}


- (void)refreshAnnouncements {
    
    dispatch_async(dispatch_queue_create("refresh announcements", NULL), ^{
        
        self.announcements = [self.announcementParser getAnnouncements];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.announcementTable reloadData];
            [self.loading stopAnimating];
            [self.loading removeFromSuperview];
            [self.refreshControl endRefreshing];
            
        });
    
    });
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.announcements count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell"];
    
    CDAnnouncement *announcement = [self.announcements objectAtIndex:indexPath.row];
    
    cell.textLabel.text = announcement.content;
    CGRect frame = cell.frame;
    cell.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44.0f);
    CGRect bounds = cell.bounds;
    cell.bounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 44.0f);
    
    
    return cell;
    
}


@end
