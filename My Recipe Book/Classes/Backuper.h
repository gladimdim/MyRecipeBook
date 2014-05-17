//
//  Backuper.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 12/11/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Backuper : NSObject
+(void) backUpFileToLocalDrive:(UIDocument *) fileToBackup;
@end
