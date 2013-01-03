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

@interface PlacesViewController ()
@end

@implementation PlacesViewController

@synthesize topPlaces = _topPlaces;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *myPlaces = [FlickrFetcher topPlaces];
    NSSortDescriptor *placeDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME ascending:YES];
    NSArray *sortedArray = [myPlaces sortedArrayUsingDescriptors:[NSArray arrayWithObject:placeDescriptor]];
    self.topPlaces = sortedArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// if not implemented will return 1
// - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPhotoList"]) {
        NSDictionary *place = [self.topPlaces objectAtIndex:[self.tableView indexPathForCell:sender].row];
        [segue.destinationViewController setPlace:place];
    }
}

@end
