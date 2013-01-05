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

@interface PhotoViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
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
    if(_photo != photo) {
        _photo = photo;
        self.title = [[PhotoTableViewController getPhotoName:photo] objectForKey:TITLE_KEY];
    }
    
    /*
     * http://developer.apple.com/library/ios/#documentation/uikit/reference/UIView_Class/UIView/UIView.html#//apple_ref/occ/cl/UIView
     * http://cs193p.m2m.at/assignment-4-task-9-addendum/#more-610
     * imageView.window returns what it is embeded in. If something is returned then we are on screen
     * and we can update the photo
     */
    if (self.imageView.window)
        [self loadPhoto];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)zoomToFit
{
    CGFloat zoomScaleX = (self.scrollView.bounds.size.width / self.imageView.image.size.width);
    CGFloat zoomScaleY = (self.scrollView.bounds.size.height / self.imageView.image.size.height);
    self.scrollView.zoomScale = MAX(zoomScaleX, zoomScaleY);
    [self.scrollView flashScrollIndicators];
}

- (void)loadPhoto
{
    self.scrollView.zoomScale = 1; // reset from any last time
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setColor:[UIColor grayColor]];
    [spinner startAnimating];
    spinner.center = self.scrollView.center;
    [spinner startAnimating];
    [self.scrollView addSubview:spinner];
    
    // fetch the photo
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickrPhotoDownloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner removeFromSuperview];
            self.imageView.image = image;
        
            // setup scrolling
            self.scrollView.contentSize = self.imageView.image.size;
            self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        
            // setup zooming
            self.scrollView.delegate = self;
        
            // zoom to appropriate size
            [self zoomToFit];
        });
    });


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPhoto];
    
}

// unclear why this has to occure here instead of viewDidLoad.
// suggested by http://ipadiphoneprogramming.blogspot.com/2012/04/assignment-4-part-4-ipad-split-view.html
- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

// thanks to http://www.i4-apps.com/assignment-4-required-tasks/#more-676
- (void)viewWillLayoutSubviews
{
    [self zoomToFit];
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

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Photos";
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

// this delegate method exists by default. I've included for clarity
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

@end
