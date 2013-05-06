//
//  Photo+Flickr.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "Photo.h"
#import "FlickrFetcher.h"
#import "VacationHelper.h"

@interface Photo (Flickr)

+ (Photo *)addPhotoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Photo *)removePhotoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
