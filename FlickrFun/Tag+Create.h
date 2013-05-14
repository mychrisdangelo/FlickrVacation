//
//  Tag+Create.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/13/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "Tag.h"


@interface Tag (Create)

+ (NSSet *)tagsWithNames:(NSArray *)tagNames inManagedObjectContext:(NSManagedObjectContext *)context;

@end
