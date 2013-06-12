//
//  SearchTagsTableViewcontroller.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/6/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "SearchTagsTableViewcontroller.h"
#import "VacationHelper.h"
#import "Tag.h"

@interface SearchTagsTableViewcontroller ()

@end

@implementation SearchTagsTableViewcontroller

@synthesize vacation = _vacation;

- (void)setVacation:(NSString *)vacation
{
    if(_vacation != vacation) {
        _vacation = vacation;
        self.title = self.vacation;
        [VacationHelper openVacation:self.vacation usingBlock:^(UIManagedDocument *vacationDocument) {
            [self setupFetchedResultsController:vacationDocument];
        }];
    }
}

// attaches an NSFetchRequest to this UITableViewController
- (void)setupFetchedResultsController:(UIManagedDocument *)vacationDocument
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Tags
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:vacationDocument.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchTagCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = tag.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photo%@", [tag.tagFor count], [tag.tagFor count] == 1 ? @"" : @"s"];
    
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
