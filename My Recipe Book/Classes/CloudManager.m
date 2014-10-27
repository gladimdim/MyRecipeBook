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
        self.iCloudURL = [[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents" isDirectory:YES] URLByAppendingPathComponent:@"foodTypes2"];
        [self fallBackFromiCloudInvalidEncodingErrorToValidURL:self.iCloudURL];
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

-(void) fallBackFromiCloudInvalidEncodingErrorToValidURL:(NSURL *) urlValidCloud {
    NSURL *urlDamaged = [[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents" isDirectory:YES] URLByAppendingPathComponent:@"foodTypesÂ"];
    
    BOOL isDir = NO;
    NSError *error;
    //[[NSFileManager defaultManager] removeItemAtURL:urlValidCloud error:&error];
    //[[NSFileManager defaultManager] removeItemAtURL:urlDamaged error:&error];
    BOOL damagedFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[urlDamaged path] isDirectory:&isDir];
    if (damagedFileExists) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[urlValidCloud path] isDirectory:&isDir]) {
            [[NSFileManager defaultManager] replaceItemAtURL:urlValidCloud withItemAtURL:urlDamaged backupItemName:@"backup" options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:&error];
        }
        else {
            [[NSFileManager defaultManager] moveItemAtPath:[urlDamaged path] toPath:[urlValidCloud path] error:&error];
        }
    }
}

@end
