//
//  PhotoViewController.h
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/3/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"
#import "PhotoTableViewController.h"
#import "FlickrPhotoCache.h"

@interface PhotoViewController : UIViewController
@property (strong, nonatomic) NSDictionary *photo;

@end
