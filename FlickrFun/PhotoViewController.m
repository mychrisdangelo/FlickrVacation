//
//  PhotoViewController.m
//  FlickrFun
//
//  Created by Chris D'Angelo on 1/3/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "PhotoTableViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;

// photo will be set by prepareforSegue
- (void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    self.title = [[PhotoTableViewController getPhotoName:photo] objectForKey:TITLE_KEY];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // fetch the photo
    NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.imageView.image = image;
    
    // setup scrolling
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
    // setup zooming
    self.scrollView.delegate = self;
}

// thanks to http://www.i4-apps.com/assignment-4-required-tasks/#more-676
- (void)viewWillLayoutSubviews
{
    // zoom to appropriate size
    CGFloat zoomScaleX = (self.scrollView.bounds.size.width / self.imageView.image.size.width);
    CGFloat zoomScaleY = (self.scrollView.bounds.size.height / self.imageView.image.size.height);
    self.scrollView.zoomScale = MAX(zoomScaleX, zoomScaleY);
}

/*
 * Note to self: Three Requirements for implmeneting scrollview zooming
 * 1. Set the scrollView.delegate to self (done in viewDidLoad)
 * 2. Implement viewForZomingInScrollView returning the item in the scroll view to be zoomed
 * 3. set the min, max size of the zoom (which I've done in interface builder
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
