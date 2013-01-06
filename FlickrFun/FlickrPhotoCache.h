//
//  FlickrFunPhotoCache.h
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotoCache : NSObject <UIApplicationDelegate>

// saves photo if not already in cache. returns photo passed in if it already exists in cache
- (NSDictionary *)savePhotoToCache:(NSDictionary *)photo; 
- (UIImage *)getPhotoFromCache:(NSDictionary *)photo;

@end
