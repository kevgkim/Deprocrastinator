//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Kevin on 5/18/15.
//  Copyright (c) 2015 Kevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSArray *toDoList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoList = [[NSArray alloc] initWithObjects:@"Walk the dog", @"Do the dishes", @"Kick the cat", @"Give Max a high five", nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"hello");
    return self.toDoList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.toDoList objectAtIndex:indexPath.row];
    return cell;
}


@end
