//
//  EPPZCoreData.h
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


#define CORE_DATA_STORE_LOGGING YES
#define CDLog if (CORE_DATA_STORE_LOGGING) NSLog
#define LOG_METHOD CDLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))


@interface EPPZCoreDataObjectQueue : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *queue;
@property (nonatomic, readonly) NSUInteger count;

-(void)pushNewObject:(id<NSCoding>) object;
-(void)popFirstObject;
-(void)popObject:(id<NSCoding>) object;
-(id<NSCoding>)objectAtIndex:(NSUInteger) index;

-(void)applicationWillTerminate:(UIApplication*) application;
-(void)save;

@end
