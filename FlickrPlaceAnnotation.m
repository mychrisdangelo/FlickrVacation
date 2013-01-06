//
//  FlickrPlaceAnnotation.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/2/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "FlickrPlaceAnnotation.h"
#import "FlickrFetcher.h"
#import "PhotoTableViewController.h"
#import "PlacesViewController.h"

@implementation FlickrPlaceAnnotation

@synthesize place = _place;

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)Place
{
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
    annotation.Place = Place;
    return annotation;
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    return [PlacesViewController parseCityName:self.place];
}

- (NSString *)subtitle
{
    return [PlacesViewController parseStateAndCountryName:self.place];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
