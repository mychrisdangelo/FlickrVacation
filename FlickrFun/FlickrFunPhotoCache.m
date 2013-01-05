//
//  FlickrFunPhotoCache.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "FlickrFunPhotoCache.h"
#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface FlickrFunPhotoCache()
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *dataPath;
@end

@implementation FlickrFunPhotoCache

@synthesize fileManager = _fileManager;
@synthesize dataPath = _dataPath;


- (void) initCache
{
    self.fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    self.dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"PhotoCache"];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.dataPath])
		return;
    
	if (![[NSFileManager defaultManager] createDirectoryAtPath:self.dataPath withIntermediateDirectories:NO attributes:nil error:nil])
        NSLog(@"Error writing photo directory to cache");
}

- (FlickrFunPhotoCache *)init
{
    [self initCache];
    return self;
}

- (NSDictionary *)savePhotoToCache:(NSDictionary *)photo
{
    id photoID = [photo objectForKey:FLICKR_PHOTO_ID];
    NSLog(@"photo: %@", photo);
    NSLog(@"photoID: %@", photoID);
    
    NSString *filepath;
    if ([photoID isKindOfClass:[NSString class]])
        filepath = [self.dataPath stringByAppendingString:photoID];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        return photo;
    }
    
    NSURL *photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
    [self.fileManager createFileAtPath:filepath contents:imageData attributes:nil];
    return nil;
}

- (UIImage *)getPhotoFromCache:(NSDictionary *)photo
{
    id photoID = [photo objectForKey:FLICKR_PHOTO_ID];
    NSString *filepath;
    if ([photoID isKindOfClass:[NSString class]])
        filepath = [self.dataPath stringByAppendingString:photoID];
    
    NSData *imageData = [self.fileManager contentsAtPath:filepath];
    return [UIImage imageWithData:imageData];;
}

@end
