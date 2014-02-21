//
//  CDMenuParser.m
//  CNHS
//
//  Created by Adam Van Prooyen on 2/3/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDMenuParser.h"
#import "pdf.h"

@implementation CDMenuParser


- (void)menuToString {
    
    NSString *pathToPDF = [[NSBundle mainBundle] pathForResource:@"/ideas" ofType:@"pdf"];
    NSLog(@"%@", pathToPDF);
    //NSString *string = convertPDF(pathToPDF);
    //NSLog(@"%@", string);
    
}


@end
