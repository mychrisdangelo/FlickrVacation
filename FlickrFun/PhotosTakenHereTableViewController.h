//
//  PhotosTakenHereTableViewController.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/6/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "VacationHelper.h"
#import "Place.h"
#import "Photo.h"
#import "ItineraryTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

@interface PhotosTakenHereTableViewController : CoreDataTableViewController

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) NSString *vacation;

- (void)setPlace:(Place *)place withVacation:(NSString *)vacation;

@end
