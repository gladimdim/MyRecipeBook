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
#import "Utilities.h"
#import "StatusLabelAnimator.h"
@import MessageUI;



@interface RecipeViewController ()
@property EKEventStore *eventStore;
@property EKCalendar *calendar;
@property EKEvent *event;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableViewIngridients;
@property (strong, nonatomic) IngridientsTableView *tableViewIngridientsDelegate;
@property (strong, nonatomic) IBOutlet UITextView *textViewStepsToCook;
@property (strong, nonatomic) IBOutlet UIButton *btnAddSReminder;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldDuration;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldPortions;
@property BOOL textViewWithStepsPressed;
@property UIView *activeElement;
@property CGRect originRectStepsToCook;
- (IBAction)btnSharedPressed:(id)sender;
@property MFMailComposeViewController *mail;
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
    self.scrollView.delegate = self;
    self.originRectStepsToCook = self.textViewStepsToCook.frame;
    self.textViewStepsToCook.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableViewIngridientsDelegate = [[IngridientsTableView alloc] init];
    self.tableViewIngridientsDelegate.recipe = self.recipe;
    self.tableViewIngridients.delegate = self.tableViewIngridientsDelegate;
    self.tableViewIngridients.dataSource = self.tableViewIngridientsDelegate;
    __weak RecipeViewController *self_weak = self;
    self.tableViewIngridientsDelegate.addIngridient = ^(Ingridient *ingr) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self_weak.recipe.arrayOfIngridients.count inSection:0];
        [self_weak.recipe.arrayOfIngridients insertObject:ingr atIndex:self_weak.recipe.arrayOfIngridients.count];
        [self_weak.tableViewIngridients insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //we need to sort array by Ingridient's colors.
        //But at first we need to remove dummy first element of array (which is used to show editable row in table).
        [self_weak.recipe.arrayOfIngridients removeObjectAtIndex:0];
        [self_weak.recipe.arrayOfIngridients sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Ingridient *ingr1 = (Ingridient *) obj1;
            Ingridient *ingr2 = (Ingridient *) obj2;
            if ([ingr1.color isEqual:ingr2.color]) {
                return NSOrderedSame;
            }
            if ([ingr1.color isEqual:[Utilities colorForCategory:0]]) {
                return NSOrderedAscending;
            }
            else {
                return NSOrderedDescending;
            }
        }];
        
        //do not forget to add dummy ingridient back
        [self_weak.recipe.arrayOfIngridients insertObject:[[Ingridient alloc] init] atIndex:0];
        
        [self_weak.tableViewIngridients reloadData];
        [self_weak dataModelChanged];
    };
    self.tableViewIngridientsDelegate.removeIngridient = ^(NSIndexPath *indexPath) {
        if (indexPath.row > 0 && indexPath.row < self_weak.recipe.arrayOfIngridients.count) {
            [self_weak.recipe.arrayOfIngridients removeObjectAtIndex:indexPath.row];
            [self_weak.tableViewIngridients deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self_weak dataModelChanged];
        }

    };

    self.txtFieldDuration.text = self.recipe.duration;
    self.txtFieldPortions.text = [self.recipe.portions stringValue];
    self.textViewStepsToCook.text = [self.recipe.stepsToCook isEqualToString:@""] || self.recipe.stepsToCook == nil? NSLocalizedString(@"Provide steps to cook.", nil) : self.recipe.stepsToCook;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self.tableViewIngridients reloadData];
    
    //register for keyboard notifications so we can resize textview
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.editing) {
        [self setEditing:NO animated:NO];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = self.recipe.name;
    if (self.recipe.arrayOfIngridients.count == 0) {
        [self setEditing:YES animated:YES];
    }
    
    NSInteger timesLaunched = [[NSUserDefaults standardUserDefaults] integerForKey:@"timesLaunched"];
    if (timesLaunched < 2) {
        StatusLabelAnimator *animatorLabel = [[StatusLabelAnimator alloc] init];
        [animatorLabel showStatus:NSLocalizedString(@"Swipe left for description", nil) inView:self.view];
        timesLaunched++;
        [[NSUserDefaults standardUserDefaults] setInteger:timesLaunched forKey:@"timesLaunched"];
    }
}

-(void) viewDidLayoutSubviews {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight= screen.size.height;
    self.scrollView.contentSize = CGSizeMake(640, screenHeight == 568 ? 354 : 266);
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableViewIngridients setEditing:editing animated:YES];
    [self.tableViewIngridientsDelegate setEditing:editing animated:animated];
    self.txtFieldPortions.enabled = editing;
    self.txtFieldDuration.enabled = editing;
    self.textViewStepsToCook.editable = editing;
    if (editing) {
        self.txtFieldDuration.borderStyle = UITextBorderStyleLine;
        self.txtFieldPortions.borderStyle = UITextBorderStyleLine;
        //add dummy ingr object to display new row in table view.
        Ingridient *ingr = [[Ingridient alloc] init];
        [self.recipe.arrayOfIngridients insertObject:ingr atIndex:0];
        [self.tableViewIngridients reloadData];
    }
    else {
        [self.recipe.arrayOfIngridients removeObjectAtIndex:0];
        [self.tableViewIngridients reloadData];
        self.txtFieldDuration.borderStyle = UITextBorderStyleNone;
        self.txtFieldPortions.borderStyle = UITextBorderStyleNone;
        
        //write down steps to cook when Done is pressed
        if (![self.textViewStepsToCook.text isEqualToString:NSLocalizedString(@"Provide steps to cook.", nil)]) {
            self.recipe.stepsToCook = self.textViewStepsToCook.text;
        }

        self.recipe.duration = self.txtFieldDuration.text;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        self.recipe.portions = self.txtFieldPortions.text ? [formatter numberFromString:self.txtFieldPortions.text] : [NSNumber numberWithInt:0];
        [self.textViewStepsToCook resignFirstResponder];
        [self dataModelChanged];
    }
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
    self.event.title = [NSString stringWithFormat:NSLocalizedString(@"Prepare %@", nil), self.recipe.name];
    NSMutableString *notes = [NSMutableString string];
    for (int i = 0; i < self.recipe.arrayOfIngridients.count; i++) {
        Ingridient *ingr = [self.recipe.arrayOfIngridients objectAtIndex:i];
        [notes appendString:[NSString stringWithFormat:@"%@ %@\n", ingr.nameIngridient, ingr.amount]];
    }
    self.event.notes = notes;
}

- (IBAction)recipeReminderAddPressed:(id)sender {
    if (self.editing) {
        [self setEditing:NO animated:NO];
    }
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    EKEventEditViewController *viewController = [[EKEventEditViewController alloc] init];
    [self prepareEvent];
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
    return self.eventStore.defaultCalendarForNewEvents;
}

-(void) dataModelChanged {
    [self.docFoodTypes saveToURL:self.docFoodTypes.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Saved file.");
        }
        else {
            NSLog(@"File was not saved.");
        }
    }];
    //[self.tableViewIngridients reloadData];
    self.textViewStepsToCook.text = [self.recipe.stepsToCook isEqualToString:@""] || self.recipe.stepsToCook == nil? NSLocalizedString(@"Provide steps to cook.", nil) : self.recipe.stepsToCook;
}

- (IBAction)btnSharedPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Whole recipe book", nil), NSLocalizedString(@"Only this recipe", nil), nil];
        [sheet showInView:self.view];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"Your device cannot send email", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.mail = [[MFMailComposeViewController alloc] init];
    [self.mail setMailComposeDelegate:self];
    
    // [self.mail setMessageBody:[Utilities composeEmailForRecipe:self.recipe withHTML:YES] isHTML:YES];
    if (buttonIndex == 0) {
        [self.mail setSubject:NSLocalizedString(@"Recipe book", nil)];
        [self.mail setMessageBody:[Utilities composeEmailForRecipeBook:self.docFoodTypes.recipeBook withHTML:YES] isHTML:YES];
    }
    else if (buttonIndex == 1) {
        [self.mail setSubject:[NSString stringWithFormat:NSLocalizedString(@"Recipe for %@", nil), self.recipe.name]];
        [self.mail setMessageBody:[Utilities composeEmailForRecipe:self.recipe withHTML:YES] isHTML:YES];
    } else {
        return;
    }
    [self.navigationController presentViewController:self.mail animated:YES completion:nil];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    //scroll to beginning of scrollArea so app does not crash with blocking constraints (autolayout).
    //It cannot calculate X Center for table view and scrollview.
    //[self.scrollView setContentOffset:CGPointMake(320, 0)];
    [self.mail dismissViewControllerAnimated:YES completion:nil];
}


-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"content offset: %@", NSStringFromCGPoint(scrollView.contentOffset));
    if (scrollView.contentOffset.x == 0 && scrollView.contentOffset.y == 0) {
        [self.textViewStepsToCook resignFirstResponder];
    }
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    if (!self.editing) {
        [self setEditing:YES animated:YES];
    }
    self.textViewWithStepsPressed = YES;
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    self.textViewWithStepsPressed = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.textViewWithStepsPressed) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect newRect = self.textViewStepsToCook.frame;
        //Down size your text view
        newRect.size.height -= endRect.size.height;
        self.textViewStepsToCook.frame = newRect;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.textViewStepsToCook.frame = self.originRectStepsToCook;
}

@end
