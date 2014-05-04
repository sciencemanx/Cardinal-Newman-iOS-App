//
//  CDNewsViewController.m
//  CNHS
//
//  Created by Adam Van Prooyen on 3/1/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDNewsViewController.h"
#import "CDTheNews.h"

@interface CDNewsViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

{
    CDTheNews *theNews;
}

@property (weak, nonatomic) IBOutlet __block UIImageView *imageSlideshow;
@property (weak, nonatomic) IBOutlet __block UITableView *newsTable;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CDNewsViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshNews) forControlEvents:UIControlEventValueChanged];
    [self.newsTable addSubview:self.refreshControl];
    
    theNews = [[CDTheNews alloc] init];
    
    [self setupLoadingView];
    
    [self refreshNews];
    
}


- (void)setupLoadingView {
    
    self.loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loading.center = self.imageSlideshow.center;
    self.loading.hidesWhenStopped = YES;
    [self.view addSubview:self.loading];
    [self.loading bringSubviewToFront:self.view];
    
}


- (void)refreshNews{
    
    dispatch_async(dispatch_queue_create("get news and news images", NULL), ^{
        
        [self.loading startAnimating];
        
        if (![theNews getNews]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self errorRefreshingNews];
                
            });
            
        } else {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.newsTable reloadData];
                
            });
        
        }
        
        NSArray *imagesArray = [self imagesFromImageURLsArray:[theNews imageURLs]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageSlideshow.animationImages = imagesArray;
            self.imageSlideshow.animationDuration = 20;
            [self.imageSlideshow startAnimating];
            [self.loading stopAnimating];
            [self.refreshControl endRefreshing];
            
        });
        
    });
    
}


- (void)errorRefreshingNews {
    
    UIAlertView *errorOccured = [[UIAlertView alloc] initWithTitle:@"Error refreshing news" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [errorOccured show];
    
}


- (NSArray *)imagesFromImageURLsArray:(NSArray *)imageURLs {
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSURL *imageURL in imageURLs) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (image) [images addObject:image];
        
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self promptForSafari];
    
}


- (void)promptForSafari {
    
    NSInteger currentNewIndex = [self.newsTable indexPathForSelectedRow].row;
    NSURL *newsURL = [theNews linkOfNewsAtIndex:currentNewIndex];
    
    UIActionSheet *safariSheet = [[UIActionSheet alloc] initWithTitle:newsURL.description delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    
    [safariSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        NSInteger currentNewIndex = [self.newsTable indexPathForSelectedRow].row;
        NSURL *newsURL = [theNews linkOfNewsAtIndex:currentNewIndex];
        [[UIApplication sharedApplication] openURL:newsURL];
        
    } else {
        
    }
    
    [self.newsTable deselectRowAtIndexPath:[self.newsTable indexPathForSelectedRow] animated:YES];
    
}


@end
