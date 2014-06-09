//
//  ActivityTableView.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 1/18/14.
//  Copyright (c) 2014 Dmytro Gladkyi. All rights reserved.
//

#import "ActivityTableView.h"

@implementation ActivityTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"activityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *activityName = nil;
    switch (indexPath.row) {
        case 0:
            activityName = NSLocalizedString(@"Share", nil);
            break;
        case 1:
            activityName = NSLocalizedString(@"Add Reminder", nil);
            break;
        case 2:
            activityName = NSLocalizedString(@"Ask to cook", nil);
            break;
        case 3:
            activityName = NSLocalizedString(@"Ask to buy ingredients", nil);
            break;
        case 4:
            activityName = NSLocalizedString(@"Move to category", nil);
            break;
        case 5:
            activityName = NSLocalizedString(@"Rename recipe", nil);
            break;
        default:
            break;
    }
    cell.textLabel.text = activityName;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.actionDelegate showShareMenu];
            break;
        case 1:
            [self.actionDelegate showRemindMenu];
            break;
        case 2:
            [self.actionDelegate showAskToCookMenu];
            break;
        case 3:
            [self.actionDelegate showAskToBuyIngredientsMenu];
            break;
        case 4:
            [self.actionDelegate showMoveView];
        default:
            break;
    }
}

@end
