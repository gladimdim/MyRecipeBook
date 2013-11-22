//
//  StatusLabelAnimator.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 10/28/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "StatusLabelAnimator.h"

@interface StatusLabelAnimator()
@property (strong) UILabel *statusLabel;
@property CGSize winSize;
@end

@implementation StatusLabelAnimator
-(void) showStatus:(NSString *)status inView:(UIView *)view {
    self.winSize = view.bounds.size;
    self.statusLabel = (UILabel*) [view viewWithTag:5553];
    if (self.statusLabel) {
        [self.statusLabel removeFromSuperview];
    }
    
    CGRect labelRect = CGRectMake(-300, self.winSize.height-22, 300, 22);
    self.statusLabel = [[UILabel alloc] initWithFrame:labelRect];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.backgroundColor = [UIColor blackColor];
    self.statusLabel.text = status;
    self.statusLabel.textColor = [UIColor whiteColor];
    
    self.statusLabel.tag = 5553;
    self.statusLabel.alpha = 2;
    [view addSubview:self.statusLabel];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(disposeLabelFromScreen:finished:context:)];
    [UIView setAnimationDuration:0.3];
    self.statusLabel.frame = CGRectMake(10, self.winSize.height - 22, 300, 22);
    [UIView commitAnimations];
}


-(void) disposeLabelFromScreen:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:1.2];
    self.statusLabel.frame = CGRectMake(-300, self.winSize.height - 22, 300, 22);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeLabel:finished:context:)];
    [UIView commitAnimations];
}

-(void) removeLabel:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
    [self.statusLabel removeFromSuperview];
}
@end
