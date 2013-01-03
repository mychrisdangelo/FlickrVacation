//
//  PlacesViewController.h
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/2/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface PlacesViewController : UITableViewController
@property (nonatomic, strong) NSArray *topPlaces; // NSArray of NSDictionary objects

+ (NSString *)parseCityName:(NSDictionary *)place;
+ (NSString *)parseStateAndCountryName:(NSDictionary *)place;

@end
