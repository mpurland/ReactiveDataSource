//
//  RADTableViewDataSource.m
//  ReactiveDataSource
//
//  Created by Matthew Purland on 7/29/14.
//  Copyright (c) 2014 Matthew Purland. All rights reserved.
//

#import "RADTableViewDataSource.h"

static NSString * const RADTableViewDataSourceDefaultReuseIdentifier = @"RADTableViewDataSourceDefaultReuseIdentifier";

@implementation RADTableReuseIdentifierProvider

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.reuseIdentifier = reuseIdentifier;
    
    return self;
}

#pragma mark - RADTableReuseIdentifierProvider

- (NSString *)reuseIdentifierForIndexPath:(NSIndexPath *)indexPath {
    if (self.reuseIdentifier) {
        return self.reuseIdentifier;
    }
    return nil;
}

@end

@interface RADTableViewDataSource () {
    RACDisposable *_reloadDisposable;
}

@property (nonatomic, strong, readwrite) RADTableModel *model;
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) id<RADTableReuseIdentifierProvider> reuseIdentifierProvider;

@end

@implementation RADTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView model:(RADTableModel *)model reuseIdentifierProvider:(id<RADTableReuseIdentifierProvider>)reuseIdentifierProvider {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.tableView = tableView;
    self.model = model;
    self.shouldReloadTableWhenSourceUpdates = YES;
    
    if (!reuseIdentifierProvider) {
        reuseIdentifierProvider = [[RADTableReuseIdentifierProvider alloc] initWithReuseIdentifier:RADTableViewDataSourceDefaultReuseIdentifier];
    }
    self.reuseIdentifierProvider = reuseIdentifierProvider;
    
    tableView.dataSource = self;
    
    return self;
}

- (void)setShouldReloadTableWhenSourceUpdates:(BOOL)shouldReloadTableWhenSourceUpdates {
    [self willChangeValueForKey:@"shouldReloadTableWhenSourceUpdates"];
    
    _shouldReloadTableWhenSourceUpdates = shouldReloadTableWhenSourceUpdates;
    
    if (shouldReloadTableWhenSourceUpdates) {
        // Reload table when source signal updates with non default values
        @weakify(self);
        _reloadDisposable = [[[RACSignal combineLatest:@[[RACObserve(self, model.objects) skip:1], [RACObserve(self, model.sections) skip:1]]] takeUntil:[RACSignal merge:@[self.rac_willDeallocSignal, [RACObserve(self, shouldReloadTableWhenSourceUpdates) filter:^BOOL(id value) {
            return [value isEqualToNumber:@(NO)];
        }]]]] subscribeNext:^(id _) {
            @strongify(self);
            if (self.shouldReloadTableWhenSourceUpdates) {
                [self.tableView reloadData];
            }
        }];
    }
    else {
        [_reloadDisposable dispose];
        _reloadDisposable = nil;
    }
    
    [self didChangeValueForKey:@"shouldReloadTableWhenSourceUpdates"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.type == RADTableModelTypeList) {
        return self.model.objects.count;
    }
    else if (self.model.type == RADTableModelTypeSectioned) {
        if (section < self.model.sections.count) {
            NSArray *rowsForSection = self.model.objects[section];
            return rowsForSection.count;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model.type == RADTableModelTypeList) {
        return 1;
    }
    else if (self.model.type == RADTableModelTypeSectioned) {
        return self.model.sections.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifierForIndexPath = [self.reuseIdentifierProvider reuseIdentifierForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierForIndexPath forIndexPath:indexPath];
    
    id object = [self.model objectForRowAtIndexPath:indexPath];
    
    if ([cell conformsToProtocol:@protocol(RADTableViewCell)]) {
        [(id<RADTableViewCell>)cell prepareCellWithObject:object];
    }
    else if ([object isKindOfClass:[NSString class]]) {
        cell.textLabel.text = object;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = section < self.model.sections.count ? self.model.sections[section] : nil;
    
    if (sectionTitle && [sectionTitle isKindOfClass:[NSString class]]) {
        return sectionTitle;
    }
    
    return nil;
}

@end
