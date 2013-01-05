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

#define TEN_MB (1024*1024*10)
#define FILE_EXTENSION @".tmp_photo"

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

// returns full path of file with MaxDate
+ (NSString *)maxDate:(NSString *)filepath lhs:(NSString *)lhs rhs:(NSString *)rhs
{
    NSString *lhsFilepath = [filepath stringByAppendingPathComponent:lhs];
    NSString *rhsFilepath = [filepath stringByAppendingPathComponent:lhs];
    
    NSDictionary *lhsAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:lhsFilepath error:nil];
    NSDictionary *rhsAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:rhsFilepath error:nil];
    
    NSDate *lhsCreationDate = [lhsAttributes fileCreationDate];
    NSDate *rhsCreationDate = [rhsAttributes fileCreationDate];
    
    if ([lhsCreationDate compare:rhsCreationDate] == NSOrderedAscending)
        return lhs;
    return rhs ? rhs : lhs; // return lhs if rhs is null
}

- (NSDictionary *)savePhotoToCache:(NSDictionary *)photo
{
    id photoID = [photo objectForKey:FLICKR_PHOTO_ID];
    NSString *filepath;
    if ([photoID isKindOfClass:[NSString class]])
        filepath = [[self.dataPath stringByAppendingPathComponent:photoID] stringByAppendingString:FILE_EXTENSION];
    
    // if it already exists return
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        return photo;
    }
    
    // otherwise write to file
    NSURL *photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
    NSLog(@"calling dataWithContentsOfURL - an expensive call from savePhotoToCache");
    [self.fileManager createFileAtPath:filepath contents:imageData attributes:nil];
    
    // cleanup if over 10MB
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtPath:self.dataPath error:nil];
    double directorySize = 0;
    NSString *oldestFilePath;
    for (NSString *each in directoryContents) {
        NSString *eachPath = [self.dataPath stringByAppendingPathComponent:each];
        NSDictionary *fileAttributes = [self.fileManager attributesOfItemAtPath:eachPath error:nil];
        directorySize += [fileAttributes fileSize];
        oldestFilePath = [FlickrFunPhotoCache maxDate:self.dataPath lhs:each rhs:oldestFilePath];
    }
    if (directorySize > TEN_MB) {
        NSString *fileToDelete;
        fileToDelete = [self.dataPath stringByAppendingPathComponent:oldestFilePath];
        [self.fileManager removeItemAtPath:fileToDelete error:nil];
    }
    return nil;
}

- (UIImage *)getPhotoFromCache:(NSDictionary *)photo
{
    id photoID = [photo objectForKey:FLICKR_PHOTO_ID];
    NSString *filepath;
    if ([photoID isKindOfClass:[NSString class]])
        filepath = [[self.dataPath stringByAppendingPathComponent:photoID] stringByAppendingString:FILE_EXTENSION];
    
    NSData *imageData = [self.fileManager contentsAtPath:filepath];
    return [UIImage imageWithData:imageData];;
}

@end
