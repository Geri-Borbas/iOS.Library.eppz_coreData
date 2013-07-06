//
//  One.h
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


static NSString *const EPPZQueuedObjectSortingKey = @"creationDate";


@interface EPPZQueuedObject : NSManagedObject


@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSData *archivedObject;


@end
