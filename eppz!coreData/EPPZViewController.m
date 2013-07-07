//
//  EPPZViewController.m
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import "EPPZViewController.h"


@interface EPPZViewController ()
@property (nonatomic, strong) EPPZTimeStampQueue *timeStampQueue;
@end


@implementation EPPZViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.timeStampQueue = [EPPZTimeStampQueue new];
}

-(IBAction)push
{
    //Manipulate model, update UI.
    [self.timeStampQueue pushNewObject:[EPPZTimeStamp timeStamp]];
    [self addRow];
}

-(IBAction)pop
{
    if (self.timeStampQueue.count > 0)
    {
        //Manipulate model, update UI.
        [self.timeStampQueue popFirstObject];
        [self removeTopRow];
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

-(void)addRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.timeStampQueue.lastIndex inSection:0];
    [self.queueTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.queueTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)removeTopRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.queueTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    if (self.timeStampQueue.count > 0)
        [self.queueTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



@end
