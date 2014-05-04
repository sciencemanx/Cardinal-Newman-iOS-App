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
@property (weak, nonatomic) IBOutlet UILabel *announcementTextLabel;

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
            
            if (self.announcements != nil) {
                
                [self.announcementTable reloadData];
                
            } else {
                
                [self errorRefreshingAnnouncements];
                
            }
            [self.loading stopAnimating];
            [self.loading removeFromSuperview];
            [self.refreshControl endRefreshing];
            
        });
    
    });
    
}


- (void)errorRefreshingAnnouncements {
    
    UIAlertView *errorOccured = [[UIAlertView alloc] initWithTitle:@"Error refreshing announcements" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [errorOccured show];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.announcements count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell" forIndexPath:indexPath];
    
    
    CDAnnouncement *announcement = [self.announcements objectAtIndex:indexPath.row];
    
    UILabel *tweetContent = (UILabel *)[cell viewWithTag:100];
    tweetContent.text = announcement.text;
    CGRect tweetContentFrame = tweetContent.frame;
    tweetContentFrame.size.height = [self getHeightForText:tweetContent.text] + 1;
    tweetContent.frame = tweetContentFrame;
    
    UILabel *tweetDate = (UILabel *)[cell viewWithTag:102];
    tweetDate.text = announcement.date;
    
    UILabel *tweetTime = (UILabel *)[cell viewWithTag:103];
    tweetTime.text = announcement.time;
    
    UIImageView *tweetImage = (UIImageView *)[cell viewWithTag:101];
    tweetImage.image = announcement.image;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CDAnnouncement *announcement = [self.announcements objectAtIndex:indexPath.row];
    
    CGFloat cellHeight = 41 + [self getHeightForText:announcement.text];
    
    NSLog(@"supposed cell height: %f", cellHeight);
    
    return cellHeight;
    
}


- (CGFloat)getHeightForText:(NSString *)text {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]};
    
    CGSize constraintSize = CGSizeMake(226, MAXFLOAT);
    CGRect labelSize = [text boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:Nil];
    
    NSLog(@"height %f", labelSize.size.height);
    
    return labelSize.size.height;
    
}


@end
