//
//  Vacation+Create.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 5/4/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "Vacation+Create.h"

@implementation Vacation (Create)

+ (Vacation *)vacationWithName:(NSString *)name
        inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Vacation *vacation = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *vacations = [context executeFetchRequest:request error:&error];
    
    if (!vacations || ([vacations count] > 1)) {
        // TODO handle error better
        NSLog(@"There is already a vacation with that name");
    } else if (![vacations count]) {
        vacation = [NSEntityDescription insertNewObjectForEntityForName:@"Vacation"
                                                     inManagedObjectContext:context];
        vacation.name = name;
    } else {
        vacation = [vacations lastObject];
    }
    
    return vacation;
}

@end
