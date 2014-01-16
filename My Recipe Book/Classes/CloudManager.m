//
//  CloudManager.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 12/8/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "CloudManager.h"

@implementation CloudManager
+(CloudManager *) sharedManager {
    static CloudManager *sharedManager;
    if (sharedManager == nil) {
        sharedManager = [[CloudManager alloc] init];
    }
    return sharedManager;
}

-(NSURL *) localDocumentURL {
    NSURL *baseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *docURL = [NSURL URLWithString:[[baseURL absoluteString]  stringByAppendingString:@"foodTypes"]];
    return docURL;
}

-(void) initCloudAccessWithCompletion:(void (^) (BOOL available)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.iCloudURL = [[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents" isDirectory:YES] URLByAppendingPathComponent:@"foodTypesÂ"];
        self.iCloudAvailable = !(self.iCloudURL == nil);
        if (self.iCloudURL != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"iCloud available at %@", self.iCloudURL);
                if (completion) {
                    completion(YES);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"iCloud is off.");
                if (completion) {
                    completion(FALSE);
                }
            });
        }
    });
}

-(BOOL) iCloudWasSwitchedOff {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudWasOn"] && !self.iCloudAvailable;
}

-(BOOL) iCloudWasSwitchedOn {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudWasOn"] && self.iCloudAvailable;
}

@end
