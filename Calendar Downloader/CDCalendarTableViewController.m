//
//  CDCalendarTableViewController.m
//  Calendar Downloader
//
//  Created by Adam Van Prooyen on 2/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDCalendarTableViewController.h"
#import "CDCalendar.h"

@interface CDCalendarTableViewController ()

{
    CDCalendar *calendar;
}

@end

@implementation CDCalendarTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    calendar = [[CDCalendar alloc]init];
}


- (void)refreshCalendarTable {
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [calendar numberOfDays];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [calendar numberOfEventsFromDayAtIndex:section];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"PrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [calendar nameOfEventAtDateIndex:indexPath.section AndEventIndex:indexPath.row];
    cell.detailTextLabel.text = [calendar timeOfEventAtDateIndex:indexPath.section AndEventIndex:indexPath.row];
    
    return cell;
    
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [calendar dateAtIndex:section];
}


@end
