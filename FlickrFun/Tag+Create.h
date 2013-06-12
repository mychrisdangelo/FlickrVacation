//
//  Tag+Create.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/13/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "Tag.h"
#import "Photo.h"

@interface Tag (Create)

+ (NSSet *)tagsWithNames:(NSArray *)tagNames withPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
