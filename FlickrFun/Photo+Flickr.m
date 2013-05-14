//
//  Photo+Flickr.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "Photo+Flickr.h"
#import "Tag+Create.h"

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
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.photoID = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];

        // add tags for photograh
        NSArray *tags = [[flickrInfo objectForKey:FLICKR_TAGS] componentsSeparatedByString: @" "];
        photo.taggedWith = [Tag tagsWithNames:tags inManagedObjectContext:context];
                         
        // add place for photograph
        photo.tookWhere = [Place placeWithName:[flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:context];
    } else {
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
        // nothing to remove
    } else {
        photo = [matches lastObject];
        
        // first check if there are other photos that use this location
        request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"tookWhere.name = %@", photo.tookWhere.name];
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"photoID" ascending:YES];
        error = nil;
        matches = [context executeFetchRequest:request error:&error];
        
        if ([matches count] == 1) {
            // if only one photo uses this location then remove the location before removing the photo
            request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
            request.predicate = [NSPredicate predicateWithFormat:@"name = %@", photo.tookWhere.name];
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            error = nil;
            matches = [context executeFetchRequest:request error:&error];
            
            Place *place = [matches lastObject];
            [context deleteObject:place];
        }
        
        [context deleteObject:photo];
    }
    
    return photo;
}

@end
