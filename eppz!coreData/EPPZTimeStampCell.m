//
//  BRSessionVariantCelCell.m
//  eppz!tools
//
//  Created by Borbás Geri on 6/28/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZTimeStampCell.h"


@implementation EPPZTimeStampCell

-(void)configureWithModel:(id) model
{
    EPPZTimeStamp *timeStamp = (EPPZTimeStamp*)model;
    
    //Date.
    NSDateFormatter *dateFormatter = [NSDateFormatter new]; //Format.
    dateFormatter.dateFormat = @"mm:ss";
    NSString *timeDisplayString = [dateFormatter stringFromDate:timeStamp.timeStamp];
    self.timeStampLabel.text = timeDisplayString; //Display.
    
    //Notes.
    self.notesLabel.text = timeStamp.notes;
    
    //Date.
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    NSString *dateDisplayString = [dateFormatter stringFromDate:timeStamp.timeStamp];
    self.dateStampLabel.text = dateDisplayString; //Display.
}

@end
