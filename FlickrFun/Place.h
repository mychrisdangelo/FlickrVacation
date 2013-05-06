//
//  Place.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *photosTakenHere;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosTakenHereObject:(Photo *)value;
- (void)removePhotosTakenHereObject:(Photo *)value;
- (void)addPhotosTakenHere:(NSSet *)values;
- (void)removePhotosTakenHere:(NSSet *)values;

@end
