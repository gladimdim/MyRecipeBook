//
//  IngridientsTableView.h
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/29/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "Ingridient.h"

@interface IngridientsTableView : UITableView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property Recipe *recipe;
@property (nonatomic, strong) void (^dataModelChanged) (BOOL);
@property (nonatomic, strong) void (^addIngridient) (Ingridient *);
@property (nonatomic, strong) void (^removeIngridient) (NSIndexPath *indexPath );
@end
