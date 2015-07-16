//
//  RADTableViewDelegate.h
//  ReactiveDataSource
//
//  Created by Matthew Purland on 7/29/14.
//  Copyright (c) 2014 Matthew Purland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveDataSource.h"

@class RADTableViewDataSource;

static CGFloat const RADTableViewDelegateDefaultEstimatedRowHeight = 40.0f;

@interface RADTableViewDelegate : NSObject<UITableViewDelegate>

@property (nonatomic, strong) NSString *headerReuseIdentifier;
@property (nonatomic, strong) NSString *footerReuseIdentifier;

/// Command to execute when a new row is selected. The command input will be a tuple with cell, indexPath, and the object.
@property (nonatomic, strong) RACCommand *didSelectRow;

/// Signal source for section header views
@property (nonatomic, strong) RACSignal *sectionHeaderViewSourceSignal;

/// Signal source for section footer views
@property (nonatomic, strong) RACSignal *sectionFooterViewSourceSignal;

RAD_PRIVATE_INIT;
- (instancetype)initWithTableView:(UITableView *)tableView dataSource:(RADTableViewDataSource *)dataSource;
+ (instancetype)delegateWithTableView:(UITableView *)tableView dataSource:(RADTableViewDataSource *)dataSource;

@end
