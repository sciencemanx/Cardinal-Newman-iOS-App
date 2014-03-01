//
//  CDViewController.m
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 1/28/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDCalendarViewController.h"
#import "CDCalendar.h"

@interface CDCalendarViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UINavigationBarDelegate>

{
    CDCalendar *calendar;
}

@property (weak, nonatomic) IBOutlet UITableView *calendarTable;

@end

@implementation CDCalendarViewController


- (void)viewDidLoad {
    
    NSLog(@"---------CDCalendarViewController---------");
    
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DoneWelcome"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DoneWelcome"];
        
    }
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"ScheduleType"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"A" forKey:@"ScheduleType"];
        
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DoneWelcome"]) {
        
        [self performSegueWithIdentifier:@"CalendarToWelcomeScreen" sender:nil];
        
    }
    
    calendar = [[CDCalendar alloc]init];
    [calendar getCalendar];
    
    
    
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


- (void)openPageInSafari {
    
    UIActionSheet *actionSheetForURL = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open in Safari" otherButtonTitles:nil];
    
    [actionSheetForURL showInView:[UIApplication sharedApplication].keyWindow];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSIndexPath *currentIndex = [self.calendarTable indexPathForSelectedRow];
    
    if (buttonIndex == 0) {
        
        NSURL *URL = [calendar linkOfEventAtDateIndex:currentIndex.section AndEventIndex:currentIndex.row];
        
        NSLog(@"%@", URL);
        
        [[UIApplication sharedApplication] openURL:URL];
        
        NSLog(@"button open pressed");
    
    } else {
        
        [self.calendarTable deselectRowAtIndexPath:currentIndex animated:true];
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *eventName = [calendar nameOfEventAtDateIndex:indexPath.section AndEventIndex:indexPath.row];
    NSString * cellType = [self getTypeOfEvent:eventName];
    
    if ([cellType isEqualToString:@"ScheduleCell"]) {
        
        NSLog(@"%@", eventName);
        [self setScheduleTypeForEventName:eventName];
        [self performSegueWithIdentifier:@"SegueToScheduleView" sender:self];
        
    }
    
    if ([calendar eventHasLinkAtDateIndex:indexPath.section andEventIndex:indexPath.row]) {
        
        NSURL *link = [calendar linkOfEventAtDateIndex:indexPath.section AndEventIndex:indexPath.row];
        NSLog(@"%@", link);
        [self openPageInSafari];
        
    } else {
        
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        NSLog(@"no link present");
        
    }
    
}


- (IBAction)refreshButtonPressed:(id)sender {
    
    if (![calendar getCalendar]) {
        
        UIAlertView *errorOccured = [[UIAlertView alloc] initWithTitle:@"Error refreshing calendar" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [errorOccured show];
        
    }
    
    [self.calendarTable reloadData];

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


//to be offloaded to other classes
- (void)setScheduleTypeForEventName:(NSString *)eventName {
    
    NSLog(@"executing setScheduleTypeForEventName for eventName: %@", eventName);
    
    NSRange searchForASchedule = [eventName rangeOfString:@"\"A\" SCHEDULE" options:NSCaseInsensitiveSearch];
    NSRange searchForBSchedule = [eventName rangeOfString:@"\"B\" SCHEDULE" options:NSCaseInsensitiveSearch];
    NSRange searchForCSchedule = [eventName rangeOfString:@"\"C\" SCHEDULE" options:NSCaseInsensitiveSearch];
    NSRange searchForDSchedule = [eventName rangeOfString:@"\"D\" SCHEDULE" options:NSCaseInsensitiveSearch];
    NSRange searchForESchedule = [eventName rangeOfString:@"\"E\" SCHEDULE" options:NSCaseInsensitiveSearch];
    
    if (searchForASchedule.location != NSNotFound) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"A" forKey:@"ScheduleType"];
        NSLog(@"set to A");
        
    } else if (searchForBSchedule.location != NSNotFound) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"B" forKey:@"ScheduleType"];
        NSLog(@"set to B");
        
    } else if (searchForCSchedule.location != NSNotFound) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"C" forKey:@"ScheduleType"];
        NSLog(@"set to C");
        
    } else if (searchForDSchedule.location != NSNotFound) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"D" forKey:@"ScheduleType"];
        NSLog(@"set to D");
        
    } else if (searchForESchedule.location != NSNotFound) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"E" forKey:@"ScheduleType"];
        NSLog(@"set to E");
        
    }
    
}


@end