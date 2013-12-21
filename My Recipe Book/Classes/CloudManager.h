//
//  CloudManager.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 12/8/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudManager : NSObject
+(CloudManager *) sharedManager;
-(NSURL *) localDocumentURL;
-(void) moveFileToiCloud:(UIDocument *) fileToMove;
-(NSURL *) ubiquitousContainerURL;
-(NSURL *) ubiquitousDocumentsDirectoryURL;
@property BOOL iCloudAvailable;
@property NSURL *iCloudURL;
-(void) initCloudAccessWithCompletion:(void (^) (BOOL available)) completion;
-(BOOL) iCloudWasSwitchedOff;
-(BOOL) iCloudWasSwitchedOn;
-(void) switchProviderForFile:(UIDocument *) doc;
@end
