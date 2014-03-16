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
    __block CDCalendar *calendar;
}

@property (weak, nonatomic) IBOutlet __block UITableView *calendarTable;

@end

@implementation CDCalendarViewController


- (void)viewDidLoad {
    
    NSLog(@"---------CDCalendarViewController---------");
    
    [super viewDidLoad];
    
    /*if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DoneWelcome"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DoneWelcome"];
        [self performSegueWithIdentifier:@"CalendarToWelcomeScreen" sender:nil];
        
    }
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"ScheduleType"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"A" forKey:@"ScheduleType"];
        
    }*/
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.center = self.view.center;
    loading.hidesWhenStopped = YES;
    loading.color = [UIColor blackColor];
    [self.view addSubview:loading];
    [loading bringSubviewToFront:self.view];
    [loading startAnimating];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        calendar = [[CDCalendar alloc]init];
        if (![calendar getCalendar]) [self errorRefreshingCalendar];
        [self.calendarTable reloadData];
        [loading stopAnimating];
        [loading removeFromSuperview];
        
    });
    
    
    
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
    
    if (buttonIndex == 0) {
        
        NSURL *URL = [calendar linkOfEventAtDateIndex:currentIndex.section AndEventIndex:currentIndex.row];
        
        NSLog(@"%@", URL);
        
        [self.calendarTable deselectRowAtIndexPath:currentIndex animated:true];
        [[UIApplication sharedApplication] openURL:URL];
        
        NSLog(@"button open pressed");
    
    } else {
        
        [self.calendarTable deselectRowAtIndexPath:currentIndex animated:true];
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * eventName = [calendar nameOfEventAtDateIndex:indexPath.section AndEventIndex:indexPath.row];
    NSString * cellType = [self getTypeOfEvent:eventName];
    
    if ([cellType isEqualToString:@"ScheduleCell"]) {
        
        //NSLog(@"%@", eventName);
        //[self setScheduleTypeForEventName:eventName];
        //[self performSegueWithIdentifier:@"SegueToScheduleView" sender:self];
        
    }
    
    if ([calendar eventHasLinkAtDateIndex:indexPath.section andEventIndex:indexPath.row]) {
        
        [self promptForSafariOrAddEvent];
        
    } else {
        
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        NSLog(@"no link present");
        
    }
    
}


- (void)promptForAddEvent {
    
    
    
}


- (void)promptForSafariOrAddEvent {
    
    UIActionSheet *actionSheetForURL = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open in Safari" otherButtonTitles:nil];
    
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