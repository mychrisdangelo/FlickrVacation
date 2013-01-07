//
//  MapViewController.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/2/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "MapViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "FlickrPhotoAnnotation.h"
#import "FlickrPlaceAnnotation.h"
#import "PhotosFromPlaceTableViewController.h"

@interface MapViewController() <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

#pragma mark - Synchronize Model and View

/*
 * Note to self: This confused me for a while.
 * there is a member variable "annotations" that we are storing for our own use.
 * Our outlet to mapView contains a member variable also named "annotations"
 * This NSArray of id <MKAnnotation> (which I believe means id conforming to the <MKAnnotation> protocol
 * contains an array of annotations necessary to create little popups over each pin and in fact
 * is what is used to populate the pins.  the pins are not populated until the appropriate
 * part of the map is showing (similar to a table view).  mapView:viewForAnnotation: usese the mapView.annotations
 * NSArray to pull the annotations data it needs on the fly
 */
- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        if ([annotation isKindOfClass:[FlickrPhotoAnnotation class]])
            aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }

    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}
 

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickrThumbnailDownloader", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
        });
    });
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[FlickrPhotoAnnotation class]]) {
        if (!self.splitViewController) {
            PhotoViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoView"];
            pvc.photo = [(FlickrPhotoAnnotation *)view.annotation photo];
            [self.navigationController pushViewController:pvc animated:YES];
        } else {
            id nc = [self.splitViewController.viewControllers lastObject];
            id pvc = [nc topViewController];
            if ([pvc isKindOfClass:[PhotoViewController class]])
                [pvc setPhoto:[(FlickrPhotoAnnotation *)view.annotation photo]];
        }
    }
    
    if ([view.annotation isKindOfClass:[FlickrPlaceAnnotation class]]) {
        PhotosFromPlaceTableViewController *pfptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Photos From Place"];
        pfptvc.place = [(FlickrPlaceAnnotation *)view.annotation place];
        [self.navigationController pushViewController:pfptvc animated:YES];
    }
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    // self.mapView.annotations may have been set in prepare for segue
    // but the view has not loaded therefore mapView:viewForAnnotation: has not run
    // therefore I am running updateMapView here
    [self updateMapView];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

// code for region positioning in this method taken from: http://ipadiphoneprogramming.blogspot.com/2012/04/assignment-5-part-2-map-pin-callout.html
// Position the map so that all overlays and annotations are visible on screen.
- (MKMapRect) mapRectForAnnotations:(NSArray*)annotations
{
    MKMapRect mapRect = MKMapRectNull;
    // annotations is an array with all the annotations I want to display on the map
    for (id<MKAnnotation> annotation in annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        
        if (MKMapRectIsNull(mapRect)) {
            mapRect = pointRect;
        } else {
            mapRect = MKMapRectUnion(mapRect, pointRect);
        }
    }
    return mapRect;
}

#define PADDING 50.0
- (void)viewWillAppear:(BOOL)animated
{
    MKMapRect regionToDisplay = [self mapRectForAnnotations:self.annotations];
    //if (!MKMapRectIsNull(regionToDisplay)) self.mapView.visibleMapRect = regionToDisplay;
    if (!MKMapRectIsNull(regionToDisplay)) self.mapView.visibleMapRect = [self.mapView mapRectThatFits:regionToDisplay edgePadding:UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING)];
}

@end
