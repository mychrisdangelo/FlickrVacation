//
//  Photo.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/6/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * photoID;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *taggedWith;
@property (nonatomic, retain) Place *tookWhere;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTaggedWithObject:(Tag *)value;
- (void)removeTaggedWithObject:(Tag *)value;
- (void)addTaggedWith:(NSSet *)values;
- (void)removeTaggedWith:(NSSet *)values;

@end
