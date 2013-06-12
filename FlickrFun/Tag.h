//
//  Tag.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/14/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tagFor;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addTagForObject:(Photo *)value;
- (void)removeTagForObject:(Photo *)value;
- (void)addTagFor:(NSSet *)values;
- (void)removeTagFor:(NSSet *)values;

@end
