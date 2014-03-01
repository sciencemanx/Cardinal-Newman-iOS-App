//
//  CDWelcomeViewController.m
//  CNHS
//
//  Created by Adam Van Prooyen on 2/8/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDWelcomeViewController.h"
#import "CDCalendarViewController.h"
#import "CDCoreDataManager.h"

@interface CDWelcomeViewController ()

{
    CDCoreDataManager *coreData;
}

@property (weak, nonatomic) IBOutlet UITextField *periodOneLabel;
@property (weak, nonatomic) IBOutlet UITextField *periodTwoLabel;
@property (weak, nonatomic) IBOutlet UITextField *periodThreeLabel;
@property (weak, nonatomic) IBOutlet UITextField *periodFourLabel;
@property (weak, nonatomic) IBOutlet UITextField *periodFiveLabel;
@property (weak, nonatomic) IBOutlet UITextField *periodSixLabel;
@property (weak, nonatomic) IBOutlet UITextField *periodSevenLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *periodLabels;
@property bool databaseLoaded;

@end

@implementation CDWelcomeViewController


- (void)viewDidLoad {
    
    NSLog(@"---------CDWelcomeViewController---------");
    
    [super viewDidLoad];
    
    self.databaseLoaded = false;
    
    coreData = [[CDCoreDataManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(databaseHasLoaded) name:@"Opened Document" object:nil];

}

- (void)databaseHasLoaded {
    
    self.databaseLoaded = true;
    
}

- (IBAction)donePressed:(id)sender {
    
    BOOL allPeriodsFilled = true;
    
    for (UITextField *periodLabel in self.periodLabels) {
        
        if (!(periodLabel.text.length > 0)) {
            
            allPeriodsFilled = false;
            
            UIColor *placeholderNotCompleteColor = [UIColor redColor];
            periodLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:periodLabel.placeholder
                                                                                attributes:@{NSForegroundColorAttributeName: placeholderNotCompleteColor}];
        }
        
    }
    
    if (allPeriodsFilled) {
        
        if (self.databaseLoaded) {
            
            NSMutableDictionary *schedule = [[NSMutableDictionary alloc] init];
            
            [schedule setObject:self.periodOneLabel.text forKey:@"class1"];
            [schedule setObject:self.periodTwoLabel.text forKey:@"class2"];
            [schedule setObject:self.periodThreeLabel.text forKey:@"class3"];
            [schedule setObject:self.periodFourLabel.text forKey:@"class4"];
            [schedule setObject:self.periodFiveLabel.text forKey:@"class5"];
            [schedule setObject:self.periodSixLabel.text forKey:@"class6"];
            [schedule setObject:self.periodSevenLabel.text forKey:@"class7"];
            
            [coreData addScheduleToDatabaseWithSchedule:schedule];
            
            [coreData closeDocument];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DoneWelcome"];
            
            [coreData printData];
            
            [self performSegueWithIdentifier:@"UnwindSegue" sender:self];
            
        } else {
            
            UIAlertView *errorSavingSchedule = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was a problem saving your schedule." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [errorSavingSchedule show];
            
        }
        
    }
    
}

@end
