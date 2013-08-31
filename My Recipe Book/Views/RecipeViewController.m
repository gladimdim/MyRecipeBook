//
//  RecipeViewController.m
//  My Recipe Book
//
//  Created by Dmytro Gladkyi on 8/14/13.
//  Copyright (c) 2013 Dmytro Gladkyi. All rights reserved.
//

#import "RecipeViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "IngridientsTableView.h"
#import "Ingridient.h"

@interface RecipeViewController ()
@property EKEventStore *eventStore;
@property EKCalendar *calendar;
@property EKEvent *event;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableViewIngridients;
@property (strong, nonatomic) IngridientsTableView *tableViewIngridientsDelegate;
@property (strong, nonatomic) IBOutlet UILabel *labelRecipeName;
@property (strong, nonatomic) IBOutlet UITextView *textViewStepsToCook;
@end

@implementation RecipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    [self checkAccessToCalendars];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableViewIngridientsDelegate = [[IngridientsTableView alloc] init];
    self.tableViewIngridientsDelegate.recipe = self.recipe;
    self.tableViewIngridients.delegate = self.tableViewIngridientsDelegate;
    self.tableViewIngridients.dataSource = self.tableViewIngridientsDelegate;
    self.labelRecipeName.text = self.recipe.name;
    self.textViewStepsToCook.text = self.recipe.stepsToCook;
    [self.tableViewIngridients reloadData];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

-(void) viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake(640, 361);
}

-(void) requestAccess {
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSLog(@"Granted: %@", granted ? @"YES" : @"NO");
        if (granted) {
            [self prepareEvent];
        }
    }];
}

-(void) checkAccessToCalendars {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityMaskEvent];
    switch (status) {
        case EKAuthorizationStatusAuthorized: {
            [self prepareEvent];
        }
            break;
        case EKAuthorizationStatusNotDetermined: {
            [self requestAccess];
        }
            break;
        case EKAuthorizationStatusDenied: {
            
        }
            break;
        case EKAuthorizationStatusRestricted: {
            
        }
    }
}

-(void) prepareEvent {
    self.event = [EKEvent eventWithEventStore:self.eventStore];
    self.event.title = @"Prepare meal";
    NSMutableString *notes = [NSMutableString string];
    for (int i = 0; i < self.recipe.arrayOfIngridients.count; i++) {
        Ingridient *ingr = [self.recipe.arrayOfIngridients objectAtIndex:i];
        [notes appendString:[NSString stringWithFormat:@"%@ %@ %@\n", ingr.nameIngridient, [ingr.amount stringValue], ingr.unitOfMeasure]];
    }
    self.event.notes = notes;
    
}

- (IBAction)recipeReminderAddPressed:(id)sender {
    EKEventEditViewController *viewController = [[EKEventEditViewController alloc] init];
    viewController.event = self.event;
    viewController.eventStore = self.eventStore;
    [self presentViewController:viewController animated:YES completion:nil];
    viewController.editViewDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(EKCalendar *) eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
    return self.eventStore.defaultCalendarForNewReminders;
}

@end
