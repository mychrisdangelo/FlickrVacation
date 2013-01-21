//
//  PhotoTableViewController.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/2/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface PhotoTableViewController () <MapViewControllerDelegate>

@end

@implementation PhotoTableViewController

@synthesize photos = _photos;

- (void)setPhotos:(NSArray *)photos
{
    if (_photos != photos) {
        _photos = photos;
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (NSDictionary *)getPhotoName:(NSDictionary *)photo
{
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([title isEqualToString:@""]) {
        if (![subtitle isEqualToString:@""]) {
            title = subtitle;
            subtitle = @"";
        } else {
            title = @"Unknown";
            subtitle = @"";
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:title, TITLE_KEY, subtitle, SUBTITLE_KEY, nil];
}


- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        NSDictionary *photo = [self.photos objectAtIndex:[self.tableView indexPathForCell:sender].row];
        [segue.destinationViewController setPhoto:photo];
    }
    
    if ([segue.identifier isEqualToString:@"ShowMap"]) {
        id destination = segue.destinationViewController;
        if ([destination isKindOfClass:[MapViewController class]]) {
            MapViewController *mapVC = (MapViewController *)destination;
            mapVC.delegate = self;
            mapVC.annotations = [self mapAnnotations];
        }
    }
}

#pragma mark - Table view data source
// automatically implemented as return 1
// - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *photo = [PhotoTableViewController getPhotoName:[self.photos objectAtIndex:indexPath.row]];
    cell.textLabel.text = [photo objectForKey:TITLE_KEY];
    cell.detailTextLabel.text = [photo objectForKey:SUBTITLE_KEY];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id nc = [self.splitViewController.viewControllers lastObject];
    id pvc = [nc topViewController];
    if ([pvc isKindOfClass:[PhotoViewController class]])
        [pvc setPhoto:[self.photos objectAtIndex:indexPath.row]];
    
}

#pragma mark - MapViewControllerDelegate

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"PhotosFromPlace: calling dataWithContentsOfURL");
    return data ? [UIImage imageWithData:data] : nil;
}

@end
