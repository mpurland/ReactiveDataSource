//
//  RADTableViewController.m
//  ReactiveDataSource
//
//  Created by Matthew Purland on 3/25/15.
//  Copyright (c) 2015 Matthew Purland. All rights reserved.
//

#import "RADTableViewController.h"

@interface RADTableViewController ()

@end

@implementation RADTableViewController

- (instancetype)initWithDataSource:(RADTableViewDataSource *)dataSource delegate:(RADTableViewDelegate *)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.tableView.dataSource = dataSource;
    self.tableView.delegate = delegate;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
