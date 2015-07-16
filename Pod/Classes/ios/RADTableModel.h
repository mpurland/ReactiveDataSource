//
//  RADTableModel.h
//  ReactiveDataSource
//
//  Created by Matthew Purland on 3/25/15.
//  Copyright (c) 2015 Matthew Purland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveDataSource.h"

/// An object wrapper to wrap an original result object
@protocol RADObjectWrapper <NSObject>

+ (id)wrapperWithObject:(id)object;

- (id)boxedObject;
- (id)unboxedObject;

@end

@interface RADObjectWrapper : NSObject<RADObjectWrapper>

@end

typedef NS_ENUM(NSInteger, RADTableModelType) {
    RADTableModelTypeList,
    RADTableModelTypeSectioned
};

@interface RADTableModel : NSObject

@property (nonatomic, strong, readonly) NSArray *objects;
@property (nonatomic, strong, readonly) NSArray *sections;
@property (nonatomic, assign, readonly) RADTableModelType type;
@property (nonatomic, strong, readonly) UITableView *tableView;

/// Command to execute when source signal sends new data
@property (nonatomic, strong) RACCommand *sourceUpdated;

RAD_PRIVATE_INIT;
- (instancetype)initWithObjectSource:(RACSignal *)objectSource sectionSource:(RACSignal *)sectionSource sourceUpdated:(RACCommand *)sourceUpdated type:(RADTableModelType)type;

- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
