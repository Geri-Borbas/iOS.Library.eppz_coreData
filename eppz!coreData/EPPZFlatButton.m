//
//  EPPZFlatButton.m
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZFlatButton.h"

@implementation EPPZFlatButton


-(void)setHighlighted:(BOOL) highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = (highlighted) ? [UIColor blackColor] : [UIColor darkGrayColor];
}


@end
