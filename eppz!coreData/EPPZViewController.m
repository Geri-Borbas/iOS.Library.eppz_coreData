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
    //Model.
    EPPZTimeStamp *object = [EPPZTimeStamp timeStamp];
    [self.timeStampQueue pushNewObject:object];
    
    //UI.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.queueTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.queueTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(IBAction)pop
{ [self.timeStampQueue popFirstObject]; }

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
    //Delightful using EPPZTableViewCell.
    //More on http://eppz.eu/blog/custom-uitableview-cell
    return [EPPZTimeStampCell cellForTableView:tableView
                                   atIndexPath:indexPath
                               withModelSource:self];
}


@end
