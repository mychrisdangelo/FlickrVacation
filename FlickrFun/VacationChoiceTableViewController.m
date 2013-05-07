//
//  VacationChoiceTableViewController.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/6/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "VacationChoiceTableViewController.h"

@interface VacationChoiceTableViewController ()

@end

@implementation VacationChoiceTableViewController

@synthesize vacation = _vacation;

- (void)setVacation:(NSString *)vacation
{
    if(_vacation != vacation) {
        _vacation = vacation;
        self.title = self.vacation;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ItinerarySegue"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
            [segue.destinationViewController setVacation:self.vacation];
        }
    }
    
    if ([segue.identifier isEqualToString:@"SearchTagsSegue"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
            [segue.destinationViewController setVacation:self.vacation];
        }
    }
}

@end
