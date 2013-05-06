//
//  VacationHelper.m
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/4/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "VacationHelper.h"

@interface VacationHelper()

@end

@implementation VacationHelper

+ (void)openVacation:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:VACATIONS_DIRECTORY];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    url = [url URLByAppendingPathComponent:vacationName];
    
    // document is automatically kept on the heap because it will be used
    // in the completion_block_t below. It essentially has a strong pointer until
    // it is sure that the block no longer needs it
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]]) {
        // does not exist on disk, so create it
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            completionBlock(document);
        }];
    } else if (document.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [document openWithCompletionHandler:^(BOOL success) {
            completionBlock(document);
        }];
    } else if (document.documentState == UIDocumentStateNormal) {
        // already open and ready to use; can't really happen
        completionBlock(document); 
    }
}

@end
