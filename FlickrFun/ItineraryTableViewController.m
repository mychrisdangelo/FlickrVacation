//
//  ItineraryTableViewController.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/6/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "ItineraryTableViewController.h"

@interface ItineraryTableViewController ()

@end

@implementation ItineraryTableViewController

@synthesize vacation = _vacation;

- (void)setVacation:(NSString *)vacation
{
    if(_vacation != vacation) {
        _vacation = vacation;
        self.title = self.vacation;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
