//
//  VacationTableViewController.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "VacationHelper.h"


@interface VacationTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSArray *vacations;

@end
