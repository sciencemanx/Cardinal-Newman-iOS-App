//
//  CDScheduleViewController.m
//  CNHS
//
//  Created by Adam Van Prooyen on 2/8/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDScheduleViewController.h"
#import "CDStudentSchedule.h"

@interface CDScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

{
    CDStudentSchedule *schedule;
}

@property NSString *scheduleType;

@end

@implementation CDScheduleViewController


- (void)viewDidLoad {

    NSLog(@"---------CDScheduleViewController---------");
    
    [super viewDidLoad];
    
    self.scheduleType = [[NSUserDefaults standardUserDefaults] objectForKey:@"ScheduleType"];
    
    schedule = [[CDStudentSchedule alloc] initWithSchedule:self.scheduleType];
    
    NSLog(@"schedule viewdidload");

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *className = [schedule classNameForPeriodAtIndex:indexPath.row];
    NSString *periodString = [schedule periodStringForPeriodAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    
    cell.textLabel.text = className;
    cell.detailTextLabel.text = periodString;
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [schedule classesForSchedule];
    
}


@end
