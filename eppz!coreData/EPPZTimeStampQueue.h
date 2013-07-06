//
//  EPPZTimeStampStore.h
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZCoreDataObjectQueue.h"
#import "EPPZTimeStamp.h"


@interface EPPZTimeStampQueue : EPPZCoreDataObjectQueue


//Casting sugar.
-(EPPZTimeStamp*)firstTimeStamp;


@end
