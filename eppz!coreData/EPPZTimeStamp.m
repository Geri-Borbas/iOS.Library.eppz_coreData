//
//  EPPZTimeStamp.m
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZTimeStamp.h"


@implementation EPPZTimeStamp


#pragma mark - Creation

+(id)timeStamp
{ return [self new]; }

-(id)init
{
    if (self = [super init])
    {
        self.timeStamp = [NSDate date];
        self.notes = [self randomNote];
    }
    return self;
}

-(NSString*)randomNote
{
    NSArray *notes = @[
                       @"Awesome data entry",
                       @"Spectacular piece of data",
                       @"Beautiful chunk",
                       @"Marvelous model",
                       @"Breathtaking bits",
                       @"Shocking information",
                       ];
    
    int randomIndex = arc4random() % notes.count;
    return notes[randomIndex];
}


#pragma mark - Implement <NSCoding>

-(id)initWithCoder:(NSCoder*) decoder
{
    if (self = [super init])
    {
        self.timeStamp = [decoder decodeObjectForKey:@"timeStamp"];
        self.notes = [decoder decodeObjectForKey:@"notes"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*) encoder
{
    [encoder encodeObject:self.timeStamp forKey:@"timeStamp"];
    [encoder encodeObject:self.notes forKey:@"notes"];
}


#pragma mark - Debug

-(NSString*)description
{ return [NSString stringWithFormat:@"%@ <%@> <%@>", NSStringFromClass(self.class), self.timeStamp, self.notes]; }


@end
