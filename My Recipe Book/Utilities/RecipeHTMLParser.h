//
//  RecipeHTMLParser.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/25/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeWrapperProtocol.h"

@interface RecipeHTMLParser : NSObject <RecipeWrapperProtocol>
+(RecipeHTMLParser *) parserWithRecipePath:(NSString *) sRecipePath;
@end
