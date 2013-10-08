//
//  IngridientsTableView.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/29/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "IngridientsTableView.h"
#import "Ingridient.h"

@interface IngridientsTableView ()
@property UITextField *textFieldIngrName;
@property UITextField *textFieldAmount;
@end

@implementation IngridientsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.recipe.arrayOfIngridients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = (self.editing && indexPath.row == 0) ? @"cellNewIngridient" : @"cellIngridient";
    NSLog(@"%@", CellIdentifier);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.editing && indexPath.row == 0) {
        if (self.textFieldIngrName == nil) {
            self.textFieldIngrName = (UITextField *) [cell viewWithTag:1];
        }
        if (self.textFieldAmount == nil) {
            self.textFieldAmount = (UITextField *) [cell viewWithTag:2];
        }
    }
    else {
        Ingridient *ingridient = [self.recipe.arrayOfIngridients objectAtIndex:indexPath.row];
        // Configure the cell...
        cell.textLabel.text = ingridient.nameIngridient;
        NSString *detailText = ingridient.amount;
        cell.detailTextLabel.text = detailText;
    }
    return cell;
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.editing && indexPath.row) == 0 ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.recipe.arrayOfIngridients removeObjectAtIndex:indexPath.row];
        //[self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.dataModelChanged(YES);
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        Ingridient *ingr = [[Ingridient alloc] init];
        ingr.nameIngridient = self.textFieldIngrName.text;
        ingr.amount = self.textFieldAmount.text;
        [self.recipe.arrayOfIngridients insertObject:ingr atIndex:self.recipe.arrayOfIngridients.count];
        self.dataModelChanged(YES);
    }
    
}


@end
