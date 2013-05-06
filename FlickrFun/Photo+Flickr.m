//
//  Photo+Flickr.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "Photo+Flickr.h"

@implementation Photo (Flickr)

+ (Photo *)addPhotoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"photoID = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"photoID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"addPhotoWithFlickrInfo: (!matches || ([matches count] > 1))");
    } else if ([matches count] == 0) {
        NSLog(@"adding for the first time");
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.photoID = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
#warning need to create place attached to photo here
    } else {
        NSLog(@"already added this before");
        photo = [matches lastObject];
    }
    
    return photo;
}


+ (Photo *)removePhotoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"photoID = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"photoID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"removePhotoWithFlickrInfo: (!matches || ([matches count] > 1))");
    } else if ([matches count] == 0) {
        NSLog(@"nothing to remove");
    } else {
        NSLog(@"removing photo");
        photo = [matches lastObject];
        [context deleteObject:photo];
#warning need to place link?
    }
    
    return photo;
}

@end
