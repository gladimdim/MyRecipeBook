//
//  IngridientsTableView.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/29/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "IngridientsTableView.h"
#import "Ingridient.h"
#import "Utilities.h"

@interface IngridientsTableView ()
@property UITextField *textFieldIngrName;
@property UITextField *textFieldAmount;
@property INGR_COLOR ingrColor;
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

#pragma mark - Table view data source

/*-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Ingridient *ingridient = [self.recipe.arrayOfIngridients objectAtIndex:indexPath.row];
    //if row is for adding new ingredient or has no ingredient name.
    if ((self.editing && indexPath.row == 0) || ingridient.nameIngridient == nil ) {
        return 44;
    }
    // Configure the cell...
    NSString *text = ingridient.nameIngridient;
    //if there is amount value - decrease width for label
    float fWidth = ingridient.amount ? 160 : 232;
    CGSize constrains = CGSizeMake(fWidth, MAXFLOAT);
    CGSize size = [text sizeWithFont:[Utilities fontForIngredientCell] constrainedToSize:constrains lineBreakMode:NSLineBreakByWordWrapping];
    //NSLog(@"return size: %f", size.height + 30);
    return size.height + 15;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.recipe.arrayOfIngridients.count;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Ingridient *ingridient = (self.recipe.arrayOfIngridients)[indexPath.row];
    [cell setBackgroundColor:ingridient.color];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = (self.editing && indexPath.row == 0) ? @"cellNewIngridient" : @"cellIngridient";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.editing && indexPath.row == 0) {
        cell.showsReorderControl = NO;
        if (self.textFieldIngrName == nil) {
            self.textFieldIngrName = (UITextField *) [cell viewWithTag:1];
            self.textFieldIngrName.delegate = self;
        }
        if (self.textFieldAmount == nil) {
            self.textFieldAmount = (UITextField *) [cell viewWithTag:2];
            self.textFieldAmount.delegate = self;
        }
    }
    else {
        Ingridient *ingridient = (self.recipe.arrayOfIngridients)[indexPath.row];
        // Configure the cell...
        UILabel *labelName = (UILabel *) [cell viewWithTag:1];
        UILabel *labelAmount = (UILabel *) [cell viewWithTag:2];
        /* labelName.font = [Utilities fontForIngredientCell];
        labelName.lineBreakMode = NSLineBreakByWordWrapping;
        labelName.textAlignment = NSTextAlignmentLeft;
        labelName.numberOfLines = 0;
        labelName.adjustsFontSizeToFitWidth = IOS7_VERSION ? YES : NO;*/
        labelName.text = ingridient.nameIngridient;
        NSString *detailText = ingridient.amount;
        if (ingridient.amount) {
            labelAmount.text = detailText;
        }
       /* else {
            [labelAmount removeFromSuperview];
        }*/
    }

    UIButton *button = (UIButton *) [cell viewWithTag:3];
    [button addTarget:self action:@selector(btnIngrColorPressed:) forControlEvents:UIControlEventTouchDown];
    return cell;
}

-(void) btnIngrColorPressed:(id) sender {
    if (self.ingrColor == mainCategory) {
        self.ingrColor = secondaryCategory;
    }
    else {
        self.ingrColor = mainCategory;
    }
    UIButton *button = (UIButton *) sender;
    [button setBackgroundColor:[Utilities colorForCategory:self.ingrColor]];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.editing && indexPath.row) == 0 ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.removeIngridient(indexPath);
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self addNewIngridient];
    }
}

-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    self.rearrangeIngridient(sourceIndexPath, destinationIndexPath);
}

-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != 0;
}

#pragma mark - UITextField delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldIngrName) {
        [textField resignFirstResponder];
        [self.textFieldAmount becomeFirstResponder];
    }
    else if (textField == self.textFieldAmount) {
        [self.textFieldAmount resignFirstResponder];
        [self.textFieldIngrName becomeFirstResponder];
        [self addNewIngridient];
    }
    return YES;
}

-(void) addNewIngridient {
    if ((![self.textFieldAmount.text isEqualToString:@""] || ![self.textFieldIngrName.text isEqualToString:@""]) && (self.textFieldIngrName.text != nil || self.textFieldAmount.text != nil)) {
        Ingridient *ingr = [[Ingridient alloc] init];
        ingr.nameIngridient = self.textFieldIngrName.text;
        ingr.amount = self.textFieldAmount.text;
        ingr.color = [Utilities colorForCategory:self.ingrColor];
        //    [self.recipe.arrayOfIngridients insertObject:ingr atIndex:self.recipe.arrayOfIngridients.count];
        //self.dataModelChanged(YES);
        self.addIngridient(ingr);
        self.textFieldAmount.text = @"";
        self.textFieldIngrName.text = @"";
    }
}
@end
