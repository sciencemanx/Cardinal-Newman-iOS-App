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
    __block CDTheNews *theNews;
}

@property (weak, nonatomic) IBOutlet __block UIImageView *imageSlideshow;
@property (weak, nonatomic) IBOutlet __block UITableView *newsTable;

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
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.center = self.imageSlideshow.center;
    loading.hidesWhenStopped = YES;
    [self.view addSubview:loading];
    [loading bringSubviewToFront:self.view];
    [loading startAnimating];
    
    
    
    dispatch_async(dispatch_queue_create("nam", NULL), ^{
        
        theNews = [[CDTheNews alloc] init];
        [theNews getNews];
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
        
        self.imageSlideshow.animationImages = [self imagesFromImageURLsArray:[theNews imageURLs]];
        self.imageSlideshow.animationDuration = 10;
        [loading stopAnimating];
        [self performSelectorOnMainThread:@selector(startSlideshow) withObject:Nil waitUntilDone:YES];
        
    });
    
}


- (void)refreshTable{
    [self.newsTable reloadData];
}


- (void)startSlideshow {
    [self.imageSlideshow startAnimating];
}


- (NSArray *)imagesFromImageURLsArray:(NSArray *)imageURLs {
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSURL *imageURL in imageURLs) {
        
        //NSLog(@"image url = ")
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        [images addObject:image];
        
    }
    
    return images;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [theNews numberOfNewsItems];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger newsItemIndex = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    
    cell.textLabel.text = [theNews nameOfNewsAtIndex:newsItemIndex];
    //NSData *image = [NSData dataWithContentsOfURL:[theNews imageURLOfNewsAtIndex:newsItemIndex]];
    
    return cell;
    
}


@end
