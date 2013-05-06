//
//  VacationHelper.h
//  FlickrVacation
//
//  Created by Chris D'Angelo on 5/4/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define VACATIONS_DIRECTORY @"Vacations"

// declaring a type called completion_block_t
// which is a block that takes a single argument UIManagedDocument
// and returns nothing (void)
// objective-c blocks are functional programming
typedef void (^completion_block_t)(UIManagedDocument *vacation);

@interface VacationHelper : NSObject

+ (void)openVacation:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock;

@end
