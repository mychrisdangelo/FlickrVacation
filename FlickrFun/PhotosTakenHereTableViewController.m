//
//  PhotosTakenHereTableViewController.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/6/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "PhotosTakenHereTableViewController.h"

@interface PhotosTakenHereTableViewController ()

@end

@implementation PhotosTakenHereTableViewController

@synthesize place = _place;
@synthesize vacation = _vacation;

- (void)setPlace:(Place *)place withVacation:(NSString *)vacation
{
    NSLog(@"received vacation = %@", vacation);
    NSLog(@"received place = %@", place.name);
    if (_vacation != vacation) {
        _vacation = vacation;
    }
    
    if (_place != place) {
        _place = place;
        self.title = self.place.name;
        [VacationHelper openVacation:self.vacation usingBlock:^(UIManagedDocument *vacationDocument) {
            [self setupFetchedResultsController:vacationDocument];
        }];
    }
}

// attaches an NSFetchRequest to this UITableViewController
- (void)setupFetchedResultsController:(UIManagedDocument *)vacationDocument
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"tookWhere.name = %@", self.place.name];
                                                        
    NSError *error = nil;
    NSArray *matches = [vacationDocument.managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"matches = %@", matches);
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:vacationDocument.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = photo.title;
    
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
