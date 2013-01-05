//
//  FlickrFunPhotoCache.h
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrFunPhotoCache : NSObject <UIApplicationDelegate>

- (NSDictionary *)savePhotoToCache:(NSDictionary *)photo; // Flickr photo dictionary
- (UIImage *)getPhotoFromCache:(NSDictionary *)photo;

@end
