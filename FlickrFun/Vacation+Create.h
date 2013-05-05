//
//  Vacation+Create.h
//  FlickrFun
//
//  Created by Chris D'Angelo on 5/4/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "Vacation.h"

@interface Vacation (Create)

+ (Vacation *)vacationWithName:(NSString *)name
        inManagedObjectContext:(NSManagedObjectContext *)context;
@end
