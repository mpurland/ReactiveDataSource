//
//  RADViewController.m
//  ReactiveDataSource
//
//  Created by Matthew Purland on 07/29/2014.
//  Copyright (c) 2014 Matthew Purland. All rights reserved.
//

#import "RADViewController.h"

@interface RADViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) RADTableViewDataSource *dataSource;
@property (nonatomic, strong) RADTableViewDelegate *delegate;

@end

@implementation RADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *sections = @[@"Morning", @"Afternoon", @"Evening"];
    NSArray *items = @[@[@"Good morning"], @[@"Good afternoon"], @[@"Good evening"]];
    self.tableView.dataSource = [RADTableViewDataSource dataSourceWithItemSource:[items.rac_sequence.signal collect] sectionSource:[sections.rac_sequence.signal collect] type:RADTableViewDataSourceTypeSectioned tableView:self.tableView reuseIdentifier:@"textCell"];
    
    self.delegate = [[RADTableViewDelegate alloc] init];
    [self.delegate.didSelectRowSignal subscribeNext:^(RACTuple *tuple) {
        NSLog(@"Selected index path: %@", tuple);
    }];
    self.tableView.delegate = self.delegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
