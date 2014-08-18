//
//  RADTableViewDataSource.m
//  ReactiveDataSource
//
//  Created by Matthew Purland on 7/29/14.
//  Copyright (c) 2014 Matthew Purland. All rights reserved.
//

#import "RADTableViewDataSource.h"

@interface RADTableViewDataSource ()

@property (nonatomic, copy, readwrite) NSString *reuseIdentifier;
@property (nonatomic, strong, readwrite) NSArray *items;
@property (nonatomic, strong, readwrite) NSArray *sections;
@property (nonatomic, assign, readwrite) RADTableViewDataSourceType type;

@end

@implementation RADTableViewDataSource

- (instancetype)initWithItemSource:(RACSignal *)itemSource sectionSource:(RACSignal *)sectionSource type:(RADTableViewDataSourceType)type tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type = type;
    self.items = @[];
    self.sections = nil;
    self.reuseIdentifier = reuseIdentifier;
    self.shouldReloadTableWhenSourceUpdates = YES;
    
    // Items
    @weakify(self);
    RAC(self, items) = [[itemSource ignore: nil] doNext:^(id _) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (self.shouldReloadTableWhenSourceUpdates) {
                [tableView reloadData];
            }
        });
    }];
    
    // Sections
    RAC(self, sections) = [[sectionSource ignore: nil] doNext:^(id _) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (self.shouldReloadTableWhenSourceUpdates) {
                [tableView reloadData];
            }
        });
    }];
    
    tableView.dataSource = self;
    
    return self;
}

+ (instancetype)dataSourceWithItemSource:(RACSignal *)itemSource sectionSource:(RACSignal *)sectionSource type:(RADTableViewDataSourceType)type tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    return [[[self class] alloc] initWithItemSource:itemSource sectionSource:sectionSource type:type tableView:tableView reuseIdentifier:reuseIdentifier];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == RADTableViewDataSourceTypeList) {
        if (indexPath.row < self.items.count) {
            return self.items[indexPath.row];
        }
        else {
            return nil;
        }
    }
    else if (self.type == RADTableViewDataSourceTypeSectioned) {
        NSArray *rowsForSection = self.items[indexPath.section];
        if (indexPath.row < rowsForSection.count) {
            return rowsForSection[indexPath.row];
        }
        else {
            return nil;
        }
    }
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == RADTableViewDataSourceTypeList) {
        return self.items.count;
    }
    else if (self.type == RADTableViewDataSourceTypeSectioned) {
        if (section < self.items.count) {
            NSArray *rowsForSection = self.items[section];
            return rowsForSection.count;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == RADTableViewDataSourceTypeList) {
        return 1;
    }
    else if (self.type == RADTableViewDataSourceTypeSectioned) {
        return self.sections.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    id data = [self dataForRowAtIndexPath:indexPath];
    
    if ([cell conformsToProtocol:@protocol(RADTableViewCell)]) {
        [(id<RADTableViewCell>)cell prepareToAppear:data];
    }
    else if ([data isKindOfClass:[NSString class]]) {
        cell.textLabel.text = data;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = section < self.sections.count ? self.sections[section] : nil;
    
    if (sectionTitle && [sectionTitle isKindOfClass:[NSString class]]) {
        return sectionTitle;
    }
    
    return nil;
}

@end
