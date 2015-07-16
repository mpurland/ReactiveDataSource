//
//  RADTableViewDataSource.h
//  ReactiveDataSource
//
//  Created by Matthew Purland on 7/29/14.
//  Copyright (c) 2014 Matthew Purland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RADCommon.h"
#import "RADTableModel.h"

//@protocol RADMapping <NSObject>
//
//- (NSString *)reuseIdentifier;
//
//@end

@protocol RADTableReuseIdentifierProvider <NSObject>

- (NSString *)reuseIdentifierForIndexPath:(NSIndexPath *)indexPath;

@end

@interface RADTableReuseIdentifierProvider : NSObject<RADTableReuseIdentifierProvider>

@property (nonatomic, strong) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

@protocol RADTableViewCell <NSObject>
@required

- (void)prepareCellWithObject:(id)object;

@end

@protocol RADTableViewHeaderFooter <NSObject>
@required

- (void)prepareToAppearWithTitle:(NSString *)title;

@end

@interface RADTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong, readonly) RADTableModel *model;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) id<RADTableReuseIdentifierProvider> reuseIdentifierProvider;

/// Reload table data when model is updated
@property (nonatomic, assign) BOOL shouldReloadTableWhenSourceUpdates;

RAD_PRIVATE_INIT;
- (instancetype)initWithTableView:(UITableView *)tableView model:(RADTableModel *)model reuseIdentifierProvider:(id<RADTableReuseIdentifierProvider>)reuseIdentifierProvider;

@end
