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
    return 4;
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
        default:
            break;
    }
    cell.textLabel.text = activityName;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselectRowAtIndexPath:indexPath animated:NO];
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
        default:
            break;
    }
}

@end
