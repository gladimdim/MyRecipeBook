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
@property BOOL iCloudAvailable;
@property NSURL *iCloudURL;
-(void) initCloudAccessWithCompletion:(void (^) (BOOL available)) completion;
@end
