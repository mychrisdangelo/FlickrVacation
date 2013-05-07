//
//  Place.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/6/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSSet *photosHere;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosHereObject:(Photo *)value;
- (void)removePhotosHereObject:(Photo *)value;
- (void)addPhotosHere:(NSSet *)values;
- (void)removePhotosHere:(NSSet *)values;

@end
