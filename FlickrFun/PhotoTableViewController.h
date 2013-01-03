//
//  PhotoTableViewController.h
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/2/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface PhotoTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *photos;

- (void)setPhotosWithDescription:(NSArray *)photos description:(NSString *)photoListDescription;

@end
