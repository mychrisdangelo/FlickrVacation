//
//  PhotoTableViewController.h
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/2/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>


#define TITLE_KEY @"PhotoTableViewController.title"
#define SUBTITLE_KEY @"PhotoTableViewController.subtitle"
#define RECENTS_KEY @"PhotoTableViewController.recents"

@interface PhotoTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *photos;
+ (NSDictionary *)getPhotoName:(NSDictionary *)photo;

@end
