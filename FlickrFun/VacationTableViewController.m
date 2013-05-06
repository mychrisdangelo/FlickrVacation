//
//  VacationTableViewController.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "VacationTableViewController.h"

@interface VacationTableViewController ()

@end

@implementation VacationTableViewController

@synthesize vacations = _vacations;

- (void) setVacations:(NSArray *)vacations
{
    if (_vacations != vacations) {
        _vacations = vacations;
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:VACATIONS_DIRECTORY];
    // url is now "<Documents Directory>/Vacations"
    self.vacations = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[url path] error:nil];
    NSLog(@"self.vacations = %@", self.vacations);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.vacations objectAtIndex:indexPath];
    
    return cell;
}

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
