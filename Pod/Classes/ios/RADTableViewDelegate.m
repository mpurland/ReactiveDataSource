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
@property (nonatomic, strong) RADTableViewDataSource *dataSource;
@property (nonatomic, strong) UITableViewCell<RADTableViewCell> *sizingCell;
@property (nonatomic, strong) UITableViewHeaderFooterView<RADTableViewHeaderFooter> *sizingSectionHeader;

@end

@implementation RADTableViewDelegate

- (instancetype)initWithTableView:(UITableView *)tableView dataSource:(RADTableViewDataSource *)dataSource {
    self = [super init];
    
    if (!self) {
        return nil;
    }

    self.tableView = tableView;
    self.dataSource = dataSource;
    
    return self;
}

+ (instancetype)delegateWithTableView:(UITableView *)tableView dataSource:(RADTableViewDataSource *)dataSource {
    return [[[self class] alloc] initWithTableView:tableView dataSource:dataSource];
}

#pragma mark - Properties

- (RACSignal *)didSelectRowSignal {
    if (!_didSelectRowSubject) {
        _didSelectRowSubject = [RACSubject subject];
    }
    
    return _didSelectRowSubject;
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

- (NSString *)reuseIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource.reuseIdentifier;
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell<RADTableViewCell> *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    if (!_sizingCell) {
        _sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierForIndexPath:indexPath]];
    }
    
    id dataForCell = [self.dataSource dataForRowAtIndexPath:indexPath];
    [_sizingCell prepareToAppear:dataForCell];
    return [self calculateHeightForConfiguredSizingCell:_sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingHeader:(UITableViewHeaderFooterView<RADTableViewHeaderFooter> *)sizingSectionHeader {
    [_sizingSectionHeader setNeedsLayout];
    [_sizingSectionHeader layoutIfNeeded];
    CGSize size = [_sizingSectionHeader.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    
    return size.height + 4.0f;
}

- (CGFloat)heightForSection:(NSInteger)section {
    if (!_sizingSectionHeader) {
        _sizingSectionHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:self.headerReuseIdentifier];
    }
    
    NSString *titleForSection = [self.dataSource tableView:self.tableView titleForHeaderInSection:section];
    [_sizingSectionHeader prepareToAppearWithTitle:titleForSection];
    return [self calculateHeightForConfiguredSizingHeader:_sizingSectionHeader];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id data = [self.dataSource dataForRowAtIndexPath:indexPath];
    [self.didSelectRowSubject sendNext:RACTuplePack(cell, indexPath, data)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.headerReuseIdentifier];
    
    if ([headerView conformsToProtocol:@protocol(RADTableViewHeaderFooter)]) {
        NSString *title = [self.dataSource tableView:tableView titleForHeaderInSection:section];
        [(id<RADTableViewHeaderFooter>)headerView prepareToAppearWithTitle:title];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForSection:section];
}

//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.footerReuseIdentifier];
//    return footerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)[self tableView:tableView viewForFooterInSection:section];
//    
//    [footerView setNeedsLayout];
//    [footerView layoutIfNeeded];
//    
//    CGSize size = [footerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RADTableViewDelegateDefaultEstimatedRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForCellAtIndexPath:indexPath];
}

@end
