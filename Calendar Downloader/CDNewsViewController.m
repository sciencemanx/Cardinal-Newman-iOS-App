//
//  CDNewsViewController.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDNewsViewController.h"
#import "CDTheNews.h"

@interface CDNewsViewController () <UITableViewDataSource, UITableViewDelegate>

{
    CDTheNews *theNews;
}

@end

@implementation CDNewsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        
        
    }
    
    return self;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    theNews = [[CDTheNews alloc] init];
    [theNews getNews];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [theNews numberOfNewsItems];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger newsItemIndex = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    
    cell.textLabel.text = [theNews nameOfNewsAtIndex:newsItemIndex];
    NSData *image = [NSData dataWithContentsOfURL:[theNews imageURLOfNewsAtIndex:newsItemIndex]];
    cell.imageView.image = [UIImage imageWithData:image];
    
    return cell;
    
}


@end
