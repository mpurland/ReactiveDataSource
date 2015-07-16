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
@property (nonatomic, strong) RADTableViewDataSource *dataSource;
@property (nonatomic, strong) RADTableViewDelegate *delegate;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *sections;

@end

@implementation RADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sections = @[@"Morning", @"Afternoon", @"Evening"];
    self.items = @[@[@"Good morning"], @[@"Good afternoon"], @[@"Good evening"]];

    // [self.items.rac_sequence.signal collect]
    // [self.sections.rac_sequence.signal collect]
    self.dataSource = [[RADTableViewDataSource alloc] initWithTableView:self.tableView model:[[RADTableModel alloc] initWithObjectSource:RACObserve(self, items) sectionSource:RACObserve(self, sections) sourceUpdated:nil type:RADTableModelTypeSectioned] reuseIdentifierProvider:[[RADTableReuseIdentifierProvider alloc] initWithReuseIdentifier:@"textCell"]];
    self.tableView.dataSource = self.dataSource;
    
    self.delegate = [[RADTableViewDelegate alloc] initWithTableView:self.tableView dataSource:self.dataSource];
    self.delegate.didSelectRow = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        NSLog(@"Selected index path: %@", tuple);
        return [RACSignal empty];
    }];
    self.tableView.delegate = self.delegate;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sections = @[@"Test1", @"Test2", @"Test3"];
    });
}

@end
