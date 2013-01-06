//
//  PlacesViewController.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/2/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "PlacesViewController.h"
#import "FlickrFetcher.h"
#import "PhotosFromPlaceTableViewController.h"
#import "MapViewController.h"
#import "FlickrPlaceAnnotation.h"

@interface PlacesViewController ()
@end

@implementation PlacesViewController

@synthesize topPlaces = _topPlaces;

- (void)setTopPlaces:(NSArray *)topPlaces
{
    if (_topPlaces != topPlaces) {
        _topPlaces = topPlaces;
        [self.tableView reloadData];
    }
}

+ (NSString *)parseCityName:(NSDictionary *)place
{
    NSString *fullPlace = [place objectForKey:FLICKR_PLACE_NAME];
    NSArray *parsedPlace = [fullPlace componentsSeparatedByString:@", "];
    return [parsedPlace objectAtIndex:0];
}

+ (NSString *)parseStateAndCountryName:(NSDictionary *)place
{
    NSString *fullPlace = [place objectForKey:FLICKR_PLACE_NAME];
    NSArray *parsedPlace = [fullPlace componentsSeparatedByString:@", "];
    return [[fullPlace componentsSeparatedByString:[[parsedPlace objectAtIndex:0] stringByAppendingString:@", "]] objectAtIndex:1];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateTable
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    id tmp = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickrPlacesDownloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *myPlaces = [FlickrFetcher topPlaces];
        NSSortDescriptor *placeDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME ascending:YES];
        NSArray *sortedArray = [myPlaces sortedArrayUsingDescriptors:[NSArray arrayWithObject:placeDescriptor]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = tmp;
            self.topPlaces = sortedArray;
            [self.refreshControl endRefreshing];
        });
    });
    // dispatch_release(downloadQueue); // this received a error from the compiler. iOS 6 has reference cointing for this. remarkable.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTable];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];

    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.topPlaces count]];
    for (NSDictionary *place in self.topPlaces) {
        [annotations addObject:[FlickrPlaceAnnotation annotationForPlace:place]];
    }
    return annotations;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlacesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [PlacesViewController parseCityName:[self.topPlaces objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [PlacesViewController parseStateAndCountryName:[self.topPlaces objectAtIndex:indexPath.row]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPhotoList"]) {
        NSDictionary *place = [self.topPlaces objectAtIndex:[self.tableView indexPathForCell:sender].row];
        [segue.destinationViewController setPlace:place];
    }
    
    if ([segue.identifier isEqualToString:@"ShowMap"]) {
        id destination = segue.destinationViewController;
        if ([destination isKindOfClass:[MapViewController class]]) {
            MapViewController *mapVC = (MapViewController *)destination;
            mapVC.annotations = [self mapAnnotations];
        }
    }
}

@end
