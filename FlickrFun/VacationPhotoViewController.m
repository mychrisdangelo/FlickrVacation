//
//  VacationPhotoViewController.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/5/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "VacationPhotoViewController.h"

@interface VacationPhotoViewController ()

@end

@implementation VacationPhotoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [VacationHelper openVacation:MY_VACATION usingBlock: ^(UIManagedDocument *vacation){
        [self checkPhotoVisited:vacation];
    }];
}

- (void)checkPhotoVisited:(UIManagedDocument *)vacation
{
    [vacation.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoID" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"photoID = %@", [self.photo objectForKey:FLICKR_PHOTO_ID]];
        
        NSError *error = nil;
        NSArray *matches = [vacation.managedObjectContext executeFetchRequest:request error:&error];
        
        NSString *visitOrUnvisit = nil;
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSLog(@"checkPhotoVisited: (!matches || ([matches count] > 1))");
        } else if ([matches count] == 0) {
            visitOrUnvisit = @"Visit";
        } else {
            visitOrUnvisit = @"Unvisit";
        }
        
        UIBarButtonItem *visitButton = [[UIBarButtonItem alloc] initWithTitle:visitOrUnvisit style:UIBarButtonItemStylePlain target:self action:@selector(pressedVisitButton:)];
        self.navigationItem.rightBarButtonItem = visitButton;
    }];
}

- (IBAction)pressedVisitButton:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"Visit"]) {
        sender.title = @"Unvisit";
        [VacationHelper openVacation:MY_VACATION usingBlock:^(UIManagedDocument *vacation) {
            [Photo addPhotoWithFlickrInfo:self.photo inManagedObjectContext:vacation.managedObjectContext];
            // should probably saveToURL:forSaveOperation:(UIDocumentSaveForOverwriting)completionHandler: here!
            // we could decide to rely on UIManagedDocument's autosaving, but explicit saving would be better
            // because if we quit the app before autosave happens, then it'll come up blank next time we run
            [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];            
        }];
    } else {
        // else user pressed "unvisit"
        sender.title = @"Visit";
        [VacationHelper openVacation:MY_VACATION usingBlock:^(UIManagedDocument *vacation) {
            [Photo removePhotoWithFlickrInfo:self.photo inManagedObjectContext:vacation.managedObjectContext];
            [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
#warning need to fix case when user is in-vacation and unvisits a photo
        }];
    }
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
