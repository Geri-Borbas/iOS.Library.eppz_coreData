//
//  EPPZTimeStamp.h
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EPPZTimeStamp : NSObject

    <NSCoding>

@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, strong) NSString *notes;

+(id)timeStamp;

@end
