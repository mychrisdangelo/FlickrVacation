//
//  PhotosFromPlaceTableViewController.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/3/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "PhotosFromPlaceTableViewController.h"
#import "PlacesViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

@interface PhotosFromPlaceTableViewController ()

@end

@implementation PhotosFromPlaceTableViewController

@synthesize place = _place;

#define MAX_RESULTS 50
- (void) setPlace:(NSDictionary *)place
{
    _place = place;
    self.title = [PlacesViewController parseCityName:place];
    self.photos = [FlickrFetcher photosInPlace:place maxResults:MAX_RESULTS];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        NSDictionary *photo = [self.photos objectAtIndex:[self.tableView indexPathForCell:sender].row];
        [segue.destinationViewController setPhoto:photo];
    }
    
}

// using inherited method
// - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

@end
