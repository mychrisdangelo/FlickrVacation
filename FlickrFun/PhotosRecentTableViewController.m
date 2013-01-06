//
//  PhotosRecentTableViewController.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/3/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "PhotosRecentTableViewController.h"
#import "PhotosFromPlaceTableViewController.h"
#import "PhotoViewController.h"


@interface PhotosRecentTableViewController ()

@end

@implementation PhotosRecentTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.photos = [[NSUserDefaults standardUserDefaults] objectForKey:RECENTS_KEY];
}


@end
