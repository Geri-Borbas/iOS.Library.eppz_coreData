//
//  EPPZCoreData.h
//  eppz!tools
//
//  Created by Borbás Geri on 7/7/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


#define CORE_DATA_STORE_LOGGING YES
#define CDLog if (CORE_DATA_STORE_LOGGING) NSLog
#define LOG_METHOD CDLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd))


@interface EPPZCoreDataObjectQueue : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *queue;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger lastIndex;

-(void)pushNewObject:(NSObject<NSCoding>*) object;
-(NSObject<NSCoding>*)firstObject;
-(void)popFirstObject;
-(void)popObject:(NSObject<NSCoding>*) object;
-(NSObject<NSCoding>*)objectAtIndex:(NSUInteger) index;

-(void)load;
-(void)save;

@end
