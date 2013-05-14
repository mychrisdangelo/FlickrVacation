//
//  Tag+Create.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/13/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (NSSet *)tagsWithNames:(NSArray *)tagNames inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableSet *tags = nil;
    Tag *tag = nil;
    NSFetchRequest *request = nil;
    NSSortDescriptor *sortDescriptor;
    NSArray *matches;
    NSError *error = nil;
    
    for (NSString *tagName in tagNames) {
        
        // test to see if the tagName we have appears in the database
        request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [tagName capitalizedString]];
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSLog(@"Problem requesting or tag is stored more than once already");
        } else if (![matches count]) {
            tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                inManagedObjectContext:context];
            tag.name = [tagName capitalizedString];
        } else {
            tag = [matches lastObject];
        }
        
        [tags addObject:tag];
        
    }
    
    return tags;
}

@end
