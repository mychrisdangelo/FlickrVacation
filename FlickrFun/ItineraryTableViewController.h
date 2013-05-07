//
//  ItineraryTableViewController.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/6/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "VacationHelper.h"
#import "Place.h"

@interface ItineraryTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSString *vacation;

@end
