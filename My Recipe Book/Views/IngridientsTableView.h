//
//  IngridientsTableView.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/29/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface IngridientsTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property Recipe *recipe;
@end
