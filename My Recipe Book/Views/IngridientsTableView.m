//
//  IngridientsTableView.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/29/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "IngridientsTableView.h"
#import "Ingridient.h"

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
    static NSString *CellIdentifier = @"cellIngridient";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Ingridient *ingridient = [self.recipe.arrayOfIngridients objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = ingridient.nameIngridient;
    NSString *detailText = [NSString stringWithFormat:@"%@ %@", [ingridient.amount stringValue], ingridient.unitOfMeasure];
    cell.detailTextLabel.text = detailText;
    return cell;
}


@end
