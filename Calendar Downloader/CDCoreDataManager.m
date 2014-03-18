//
//  CDCoreDataManager.m
//  CNHS
//
//  Created by Adam Van Prooyen on 2/13/14.
//  Copyright (c) 2014 Adam Van Prooyen. All rights reserved.
//

#import "CDCoreDataManager.h"


@interface CDCoreDataManager ()

@property NSManagedObjectContext *context;
@property UIManagedDocument *document;

@end


@implementation CDCoreDataManager

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        [self openDocument];
        
    }
    
    return self;
    
}

- (void)openDocument {
    
    NSLog(@"executing createDatabaseConnection");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    
    NSString *documentName = @"StudentDataModel.xml";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    bool fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    
    if (fileExists) {
        
        [self.document openWithCompletionHandler:^(BOOL success) {
            
            NSLog(@"completion handler for open");
            
            if (success) {
                
                NSLog(@"document is ready");
                [self createContext];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Opened Document" object:self];
                
            }
            
            if (!success) {
                
                NSLog(@"couldnt open document at url: %@", [url path]);
                
            }
        
        }];
        
    } else {
        
        [self.document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              
              NSLog(@"completion handler for save");
              
              if (success) {
                  
                  NSLog(@"document was created successfully");
                  [self createContext];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Opened Document" object:self];
                  
              }
              if (!success) {
                  
                  NSLog(@"couldnt create document at url: %@", [url path]);
                  
              }
          
          }];
    
    }
    
}


- (void)createContext {
    
    NSLog(@"creating context");
    self.context = self.document.managedObjectContext;
    
}


/*- (void)printData {
    
    NSLog(@"executing printData");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (Schedule *schedule in fetchedObjects) {
        NSLog(@"class 1: %@", schedule.class1);
        NSLog(@"class 2: %@", schedule.class2);
        NSLog(@"class 3: %@", schedule.class3);
        NSLog(@"class 4: %@", schedule.class4);
        NSLog(@"class 5: %@", schedule.class5);
        NSLog(@"class 6: %@", schedule.class6);
        NSLog(@"class 7: %@", schedule.class7);
    }
    
    if ([fetchedObjects count] == 0) {
        NSLog(@"no schedule data present");
    }
    
}


- (void)addScheduleToDatabaseWithSchedule:(NSDictionary *)schedule {
    
    NSLog(@"executing addSchedule");
    
    Schedule *scheduleForDatabase = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.context];
    
    scheduleForDatabase.class1 = [schedule objectForKey:@"class1"];
    scheduleForDatabase.class2 = [schedule objectForKey:@"class2"];
    scheduleForDatabase.class3 = [schedule objectForKey:@"class3"];
    scheduleForDatabase.class4 = [schedule objectForKey:@"class4"];
    scheduleForDatabase.class5 = [schedule objectForKey:@"class5"];
    scheduleForDatabase.class6 = [schedule objectForKey:@"class6"];
    scheduleForDatabase.class7 = [schedule objectForKey:@"class7"];
    
    NSError *error = nil;
    
    [self.context save:&error];
    
    if (error != nil) {
        NSLog(@"an error occured while saving to database");
    } else NSLog(@"an error didnt occur while saving data");
    
}*/


- (void)closeDocument {
    
    [self.document closeWithCompletionHandler:^(BOOL success) {
        
        if (success) {
            NSLog(@"closed successfully");
        } else {
            NSLog(@"did not close successfully");
        }
        
    }];
    
}


/*- (NSArray *)getClasses {
    
    NSLog(@"executing getClasses");
    
    NSEntityDescription *classesEntityDescription = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:self.context];
    NSFetchRequest *classFetchRequest = [[NSFetchRequest alloc] init];
    [classFetchRequest setEntity:classesEntityDescription];
    
    NSError *err;
    
    NSArray *classes = [self.context executeFetchRequest:classFetchRequest error:&err];
    
    NSLog(@"%lu", (unsigned long)[classes count]);
    
    Schedule *schedule = [classes objectAtIndex:0];
    
    return @[schedule.class1,
             schedule.class2,
             schedule.class3,
             schedule.class4,
             schedule.class5,
             schedule.class6,
             schedule.class7];
    
}*/


@end
