//
//  EPPZViewController.m
//  eppz!tools
//
//  Created by Borbás Geri on 7/7/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EPPZViewController.h"


@interface EPPZViewController ()
@property (nonatomic, strong) EPPZTimeStampQueue *timeStampQueue;
@end


@implementation EPPZViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create queue (loads the stored timeStamps on creation).
    self.timeStampQueue = [EPPZTimeStampQueue new];
}

-(IBAction)push
{
    //Push a brand new timeStamp, update UI.
    [self.timeStampQueue pushNewObject:[EPPZTimeStamp timeStamp]];
    [self addTableRow];
}

-(IBAction)pop
{
    if (self.timeStampQueue.count > 0)
    {
        //Manipulate model, update UI.
        [self.timeStampQueue popFirstObject];
        [self removeTopTableRow];
    }
}

-(IBAction)save
{ [self.timeStampQueue save]; }


#pragma mark - Populate table

-(NSInteger)tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{ return self.timeStampQueue.count; }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{ return [EPPZTimeStampCell heightForTableView:tableView atIndexPath:(NSIndexPath*) indexPath]; }

-(id)modelForIndexPath:(NSIndexPath*) indexPath
{ return [self.timeStampQueue objectAtIndex:indexPath.row]; }

-(UITableViewCell*)tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    //Delightful using of EPPZTableViewCell http://eppz.eu/blog/custom-uitableview-cell
    return [EPPZTimeStampCell cellForTableView:tableView
                                   atIndexPath:indexPath
                               withModelSource:self];
}


#pragma mark - Table manipulation

-(void)addTableRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.timeStampQueue.lastIndex inSection:0];
    [self.queueTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.queueTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)removeTopTableRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.queueTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    if (self.timeStampQueue.count > 0)
        [self.queueTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



@end
