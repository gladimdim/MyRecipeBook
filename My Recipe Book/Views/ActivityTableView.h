//
//  ActivityTableView.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/18/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"

@interface ActivityTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property RecipeViewController *actionDelegate;
@end
