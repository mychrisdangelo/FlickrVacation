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

@interface PhotoTableViewController ()

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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#define MAX_RECENTS 20
+ (void)addToRecents:(NSDictionary *)photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults objectForKey:RECENTS_KEY] mutableCopy];
    if (!recents) recents = [NSMutableArray array];
    NSDictionary *each;
    for (int i = 0; i < [recents count]; i++) {
        each = [recents objectAtIndex:i];
        if ([[each objectForKey:FLICKR_PHOTO_ID] isEqualToString:[photo objectForKey:FLICKR_PHOTO_ID]]) {
            [recents removeObjectAtIndex:i];
            break;
        }
    }
    if ([recents count] >= MAX_RECENTS) [recents removeLastObject];
    [recents insertObject:photo atIndex:0];
    [defaults setObject:recents forKey:RECENTS_KEY];
    [defaults synchronize];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // add photo chosen to recent phots
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    [PhotoTableViewController addToRecents:photo];
    
    id nc = [self.splitViewController.viewControllers lastObject];
    id pvc = [nc topViewController];
    if ([pvc isKindOfClass:[PhotoViewController class]])
        [pvc setPhoto:[self.photos objectAtIndex:indexPath.row]];
    
}

@end
