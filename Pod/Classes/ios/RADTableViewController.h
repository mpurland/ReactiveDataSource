//
//  RADTableViewController.h
//  ReactiveDataSource
//
//  Created by Matthew Purland on 3/25/15.
//  Copyright (c) 2015 Matthew Purland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveDataSource.h"
@class RADTableViewDataSource;
@class RADTableViewDelegate;

@interface RADTableViewController : UITableViewController

- (instancetype)initWithDataSource:(RADTableViewDataSource *)dataSource delegate:(RADTableViewDelegate *)delegate;

@end
