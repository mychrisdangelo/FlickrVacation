//
//  VacationsTableViewController.h
//  FlickrFun
//
//  Created by Chris D'Angelo on 5/4/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Vacation+Create.h"

@interface VacationsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *vacationsDatabase; // Model is a Core Data database of vacations

@end
