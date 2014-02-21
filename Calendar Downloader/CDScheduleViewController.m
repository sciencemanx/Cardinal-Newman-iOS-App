//
//  CDScheduleViewController.m
//  CNHS
//
//  Created by Adam Van Prooyen on 2/8/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDScheduleViewController.h"

@interface CDScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CDScheduleViewController


- (void)viewDidLoad {

    NSLog(@"---------CDScheduleViewController---------");
    
    [super viewDidLoad];
	
    NSLog(@"schedule viewdidload");

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    
    
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}


@end
