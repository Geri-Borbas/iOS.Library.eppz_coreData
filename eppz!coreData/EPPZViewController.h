//
//  EPPZViewController.h
//  eppz!coreData
//
//  Created by Gardrobe on 7/6/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPPZTimeStampQueue.h"
#import "EPPZTimeStampCell.h"


@interface EPPZViewController : UIViewController

    <UITableViewDelegate,
     UITableViewDataSource,
     EPPZTableViewCellModelSource>

@property (nonatomic, weak) IBOutlet UITableView *queueTableView;

-(IBAction)push;
-(IBAction)pop;
-(IBAction)save;


@end
