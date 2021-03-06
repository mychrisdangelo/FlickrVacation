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
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    id tmpButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickrDownloadPhotosFromPlace", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher photosInPlace:place maxResults:MAX_RESULTS];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = tmpButton;
            self.photos = photos;
        });
    });
}

@end
