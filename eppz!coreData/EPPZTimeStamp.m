//
//  EPPZTimeStamp.m
//  eppz!tools
//
//  Created by Borbás Geri on 7/7/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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

    //Pick.
    static int previouslyPickedIndex;
    int randomIndex = arc4random() % notes.count;
    
    //Return if pick is not the same as previous.
    if (randomIndex == previouslyPickedIndex) return [self randomNote];
    
    previouslyPickedIndex = randomIndex;
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
