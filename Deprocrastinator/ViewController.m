//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Kevin on 5/18/15.
//  Copyright (c) 2015 Kevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addTaskTextField;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property NSMutableArray *toDoList;
@property NSIndexPath *indexToDelete;
@property BOOL inEditMode;
@property NSMutableArray *selectedButtons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoList = [[NSMutableArray alloc] initWithObjects:@"Walk the dog", @"Do the dishes", @"Kick the cat", @"Give Max a high five", @"fart", @"eat", @"drink", @"be merry", @"watch football", @"eat", @"sleep", @"code", @"drive fast", @"fly jets", nil];
    self.taskTableView.allowsMultipleSelectionDuringEditing = NO;
    self.inEditMode = NO;
        // set up array to hold the state of buttons so they hold after dequeing
    self.selectedButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.toDoList.count; i++) {
        self.selectedButtons[i] = @0;
    }
}

#pragma mark MaintaingTable Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
    if ([self.selectedButtons[indexPath.row] isEqualToNumber:@0]) {
        self.selectedButtons[indexPath.row] = @1;
    } else {
        self.selectedButtons[indexPath.row] = @0;
    }
}

#pragma mark EditTable Methods

- (IBAction)onUserSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint swipePoint = [sender locationInView:self.taskTableView];
        NSIndexPath *swipedIndexPath = [self.taskTableView indexPathForRowAtPoint:swipePoint];
        UITableViewCell *swipedCell = [self.taskTableView cellForRowAtIndexPath:swipedIndexPath];
        if (swipedCell.textLabel.textColor == [UIColor blackColor]) {
            swipedCell.textLabel.textColor = [UIColor redColor];
        } else if (swipedCell.textLabel.textColor == [UIColor redColor]) {
            swipedCell.textLabel.textColor = [UIColor yellowColor];
        } else if (swipedCell.textLabel.textColor == [UIColor yellowColor]) {
            swipedCell.textLabel.textColor = [UIColor greenColor];
        } else {
            swipedCell.textLabel.textColor = [UIColor blackColor];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
        // move object inside the array
    NSString *task = [self.toDoList objectAtIndex:sourceIndexPath.row];
    [self.toDoList removeObject:task];
    [self.toDoList insertObject:task atIndex:destinationIndexPath.row];

        // move state of object inside its array
    NSNumber *state = [self.selectedButtons objectAtIndex:sourceIndexPath.row];
    [self.selectedButtons[sourceIndexPath.row] removeObject:state];
    [self.selectedButtons[destinationIndexPath.row] addObject:state];

    [self.taskTableView reloadData];
}



-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (IBAction)onEditButtonPressed:(UIButton *)sender {
    if (!self.inEditMode) {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self.taskTableView setEditing:YES animated:YES];
        self.inEditMode = YES;
    } else {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self.taskTableView setEditing:NO animated:YES];
        self.inEditMode = NO;
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"Do you want to slack off" message:@"you should probably do this!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        deleteAlertView.delegate = self;
        [deleteAlertView show];
        self.indexToDelete = indexPath;
        [self.taskTableView reloadData];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.toDoList removeObjectAtIndex:self.indexToDelete.row];
        [self.taskTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexToDelete] withRowAnimation:UITableViewRowAnimationLeft];
        [self.selectedButtons removeObjectAtIndex:self.indexToDelete.row];
    }
}

#pragma mark StandardTableViewMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toDoList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.toDoList objectAtIndex:indexPath.row];
    if ([self.selectedButtons[indexPath.row] isEqualToNumber:@1]) {
         cell.textLabel.textColor = [UIColor greenColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }

    return cell;
}


- (IBAction)onAddButtonPressed:(id)sender {
    if ([self.addTaskTextField.text  isEqual: @""]) {
        return;
    }
    NSString *taskToAddString = self.addTaskTextField.text;
    [self.toDoList addObject:taskToAddString];
    [self.selectedButtons addObject:@0];
    [self.addTaskTextField resignFirstResponder];
    self.addTaskTextField.text = @"";
    [self.taskTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
