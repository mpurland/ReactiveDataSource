//
//  RADTableViewDataSource.h
//  ReactiveDataSource
//
//  Created by Matthew Purland on 7/29/14.
//  Copyright (c) 2014 Matthew Purland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ReactiveDataSource.h"

@protocol RADTableViewCell <NSObject>
@required

- (void)prepareToAppear:(id)data;

@end

typedef NS_ENUM(NSInteger, RADTableViewDataSourceType) {
    RADTableViewDataSourceTypeList,
    RADTableViewDataSourceTypeSectioned
};

@interface RADTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, strong, readonly) NSArray *sections;
@property (nonatomic, assign, readonly) RADTableViewDataSourceType type;

/// Reload table data when source signal sends new data
@property (nonatomic, assign) BOOL shouldReloadTableWhenSourceUpdates;

- (instancetype)initWithItemSource:(RACSignal *)itemSource sectionSource:(RACSignal *)sectionSource type:(RADTableViewDataSourceType)type tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

+ (instancetype)dataSourceWithItemSource:(RACSignal *)itemSource sectionSource:(RACSignal *)sectionSource type:(RADTableViewDataSourceType)type tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
