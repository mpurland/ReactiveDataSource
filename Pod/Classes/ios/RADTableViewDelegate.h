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

/// Signal will send a NSIndexPath when a row is selected.
@property (nonatomic, strong, readonly) RACSignal *didSelectRowSignal;

/// Signal source for section header views
@property (nonatomic, strong) RACSignal *sectionHeaderViewSourceSignal;

/// Signal source for section footer views
@property (nonatomic, strong) RACSignal *sectionFooterViewSourceSignal;

- (instancetype)initWithTableView:(UITableView *)tableView dataSource:(RADTableViewDataSource *)dataSource;
+ (instancetype)delegateWithTableView:(UITableView *)tableView dataSource:(RADTableViewDataSource *)dataSource;

@end
