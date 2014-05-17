//
//  Say7InfoParser.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 2/8/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "Say7InfoParser.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "Ingridient.h"
#import "Recipe.h"
#import "Utilities.h"

@implementation Say7InfoParser
+(Say7InfoParser *) parserWithRecipePath:(NSURL *)urlRecipe {
    Say7InfoParser *parser = [[Say7InfoParser alloc] init];
    parser.sRecipePath = [urlRecipe absoluteString];
    parser.dHTML = [NSData dataWithContentsOfURL:urlRecipe];
    parser.doc = [[TFHpple alloc] initWithHTMLData:parser.dHTML];
    return parser;
}

-(NSString *) getTitle {
    NSString *title = nil;
    NSArray *aTitle = [self.doc searchWithXPathQuery:@"//a[@class='p-name']"];
    if (aTitle.count > 0) {
        TFHppleElement *element = aTitle[0];
        title = [element text];
        return title;
    }
    else {
        return nil;
    }
}

-(NSArray *) getIngredients {
    NSArray *aIngredients =  [self.doc searchWithXPathQuery:@"//li[@class='p-ingredient']"];
    if (aIngredients.count > 0) {
        NSMutableArray *ingrArray = [NSMutableArray array];
        for (TFHppleElement *el in aIngredients) {
            if (el.children.count > 0) {
                TFHppleElement *ch = el.children[0];
                Ingridient *ingr = [[Ingridient alloc] init];
                ingr.nameIngridient = [ch content];
                ingr.color = [Utilities colorForCategory:mainCategory];
                [ingrArray addObject:ingr];
            }
        }
        return ingrArray;
    }
    else {
        return nil;
    }
}

-(NSString *) getPrepTime {
    return nil;
}

-(NSString *) getStepsToCook {
    NSString *sReturn = @"";
    NSArray *arr = [self.doc searchWithXPathQuery:@"//div[@class='stepbystep e-instructions']"];
    if (arr.count > 0) {
        for (TFHppleElement *el in arr) {
            for (TFHppleElement *chEl in el.children) {
                if (chEl.children.count > 1) {
                    TFHppleElement *ch = (TFHppleElement *) chEl.children[1];
                    sReturn = [NSString stringWithFormat:@"%@\n%@", sReturn, ch.content];
                }
            }
        }
        return sReturn;
    }
    else {
        return nil;
    }
}

-(NSNumber *) getPortions {
    return  nil;
}

-(Recipe *) recipe {
    Recipe *recipe = [Recipe recipeWithName:[self getTitle]  stepsToCook:@""];
    recipe.arrayOfIngridients = [[NSMutableArray alloc] initWithArray:[self getIngredients]];
    recipe.stepsToCook = [self getStepsToCook];
    return recipe;
}
@end
