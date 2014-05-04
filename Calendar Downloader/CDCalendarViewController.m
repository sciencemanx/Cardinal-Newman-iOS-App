//
//  CDViewController.m
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 1/28/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDCalendarViewController.h"
#import "CDCalendar.h"
#import "CDEventKitManager.h"

@interface CDCalendarViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UINavigationBarDelegate>

{
    CDCalendar *calendar;
}

@property (weak, nonatomic) IBOutlet __block UITableView *calendarTable;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CDCalendarViewController


- (void)viewDidLoad {
    
    NSLog(@"---------CDCalendarViewController---------");
    
    [super viewDidLoad];
    calendar = [[CDCalendar alloc]init];
    [self setupLoadingView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshCalendar) forControlEvents:UIControlEventValueChanged];
    [self.calendarTable addSubview:self.refreshControl];
    
    [self.loading startAnimating];
    
    [self refreshCalendar];
    
}


- (void)refreshCalendar {
    
    dispatch_async(dispatch_queue_create("refresh calendar", NULL), ^{
        
        
        if (![calendar getCalendar]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self errorRefreshingCalendar];
                
            });
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.calendarTable reloadData];
            [self.loading stopAnimating];
            [self.loading removeFromSuperview];
            [self.refreshControl endRefreshing];
            
        });
        
    });
    
}


- (void)setupLoadingView {
    
    self.loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loading.center = self.view.center;
    self.loading.hidesWhenStopped = YES;
    self.loading.color = [UIColor blackColor];
    [self.view addSubview:self.loading];
    [self.loading bringSubviewToFront:self.view];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [calendar numberOfDays];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [calendar numberOfEventsFromDayAtIndex:section];
    
}


- (NSString *)getTypeOfEvent:(NSString *)eventName {
    
    NSRange searchForSchedule = [eventName rangeOfString:@"SCHEDULE" options:NSCaseInsensitiveSearch];
    
    if (searchForSchedule.location != NSNotFound) {
        
        return @"ScheduleCell";
    
    }
    
    return @"DefaultCell";
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *eventName = [calendar nameOfEventAtDateIndex:indexPath.section AndEventIndex:indexPath.row];
    NSString *eventTime = [calendar timeOfEventAtDateIndex:indexPath.section AndEventIndex:indexPath.row];
    
    NSString * cellType = [self getTypeOfEvent:eventName];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    
    cell.textLabel.text = eventName;
    cell.detailTextLabel.text = eventTime;
    
    if ([calendar eventHasLinkAtDateIndex:indexPath.section andEventIndex:indexPath.row]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return  [calendar dateAtIndex:section];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSIndexPath *currentIndex = [self.calendarTable indexPathForSelectedRow];
    
    if (actionSheetType == Event_And_Safari) {
        
        enum buttons {
            Button_Open = 1,
            Button_Cancel = 2,
            Button_Add_Event = 0
        };
        
        //if (buttonIndex == Button_Open) {
        if (buttonIndex == 0) {
            NSURL *URL = [calendar linkOfEventAtDateIndex:currentIndex.section AndEventIndex:currentIndex.row];
            
            [[UIApplication sharedApplication] openURL:URL];
            
            NSLog(@"button open pressed");
            
        } else if (buttonIndex == Button_Add_Event) {
            
            
            
        }
        
    } if (actionSheetType == Event) {
        
        enum buttons {
            Button_Cancel = 1,
            Button_Add_Event = 0
        };
        
        if (buttonIndex == Button_Add_Event) {
            
            
            
        }
        
    }
    
    
    [self.calendarTable deselectRowAtIndexPath:currentIndex animated:true];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([calendar eventHasLinkAtDateIndex:indexPath.section andEventIndex:indexPath.row]) {
        
        [self promptForSafariOrAddEvent];
        
    } else {
        
        //[self promptForAddEvent];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
}

enum actionSheetTypes {
    Event_And_Safari = 0,
    Event = 1
};

int actionSheetType = 0;

- (void)promptForAddEvent {
    
    actionSheetType = Event;
    
    UIActionSheet *actionSheetForURL = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to Calendar", nil];
    
    [actionSheetForURL showInView:[UIApplication sharedApplication].keyWindow];
    
}


- (void)promptForSafariOrAddEvent {
    
    actionSheetType = Event_And_Safari;
    
    NSIndexPath *currentIndex = [self.calendarTable indexPathForSelectedRow];
    NSURL *URL = [calendar linkOfEventAtDateIndex:currentIndex.section AndEventIndex:currentIndex.row];
    
    //UIActionSheet *actionSheetForURL = [[UIActionSheet alloc] initWithTitle:URL.description delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to Calendar", @"Open in Safari", nil];
    
    UIActionSheet *actionSheetForURL = [[UIActionSheet alloc] initWithTitle:URL.description delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    
    [actionSheetForURL showInView:[UIApplication sharedApplication].keyWindow];
    
}


- (IBAction)refreshButtonPressed:(id)sender {
    
    if (![calendar getCalendar]) {
        
        [self errorRefreshingCalendar];
        
    }
    
    [self.calendarTable reloadData];

}


- (void)errorRefreshingCalendar {
    
    UIAlertView *errorOccured = [[UIAlertView alloc] initWithTitle:@"Error refreshing calendar" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [errorOccured show];
    
}


- (IBAction)unwindToCalendarFromSchedule:(UIStoryboardSegue *)segue {
    
    NSLog(@"---------CDCalendarViewController---------");
    
}


- (IBAction)unwindToCalendarFromWelcome:(UIStoryboardSegue *)segue {
    
    NSLog(@"---------CDCalendarViewController---------");
    
}


- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"recieved segue");
    
}


@end