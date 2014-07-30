//
//  RADTableViewDelegate.m
//  ReactiveDataSource
//
//  Created by Matthew Purland on 7/29/14.
//  Copyright (c) 2014 Matthew Purland. All rights reserved.
//

#import "RADTableViewDelegate.h"

@interface RADTableViewDelegate ()

@property (nonatomic, strong) RACSubject *didSelectRowSubject;
@property (nonatomic, strong) NSArray *sectionHeaderViews;
@property (nonatomic, strong) NSArray *sectionFooterViews;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RADTableViewDelegate

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    
    if (!self) {
        return nil;
    }

    self.tableView = tableView;
    
    return self;
}

+ (instancetype)delegateWithTableView:(UITableView *)tableView {
    return [[[self class] alloc] initWithTableView:tableView];
}

#pragma mark - Properties

- (RACSignal *)didSelectRowSignal {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.didSelectRowSubject = [RACSubject subject];
    });
    return self.didSelectRowSubject;
}

- (void)setSectionHeaderViewSourceSignal:(RACSignal *)sectionHeaderViewSourceSignal {
    if (_sectionHeaderViewSourceSignal != sectionHeaderViewSourceSignal) {
        [self willChangeValueForKey:@"sectionHeaderViewSourceSignal"];
        _sectionHeaderViewSourceSignal = sectionHeaderViewSourceSignal;
        RAC(self, sectionHeaderViews) = sectionHeaderViewSourceSignal;
        [self didChangeValueForKey:@"sectionHeaderViewSourceSignal"];
    }
}

- (void)setSectionFooterViewSourceSignal:(RACSignal *)sectionFooterViewSourceSignal {
    if (_sectionFooterViewSourceSignal != sectionFooterViewSourceSignal) {
        [self willChangeValueForKey:@"sectionFooterViewSourceSignal"];
        _sectionFooterViewSourceSignal = sectionFooterViewSourceSignal;
        RAC(self, sectionFooterViews) = _sectionFooterViewSourceSignal;
        [self didChangeValueForKey:@"sectionFooterViewSourceSignal"];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.didSelectRowSubject sendNext:RACTuplePack(cell, indexPath)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderViews[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.sectionFooterViews[section];
}

@end
