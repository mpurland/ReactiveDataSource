//
//  RADTableModel.m
//  ReactiveDataSource
//
//  Created by Matthew Purland on 3/25/15.
//  Copyright (c) 2015 Matthew Purland. All rights reserved.
//

#import "RADTableModel.h"

@interface RADTableModel ()

@property (nonatomic, strong, readwrite) NSArray *objects;
@property (nonatomic, strong, readwrite) NSArray *sections;
@property (nonatomic, assign, readwrite) RADTableModelType type;
@property (nonatomic, strong) RACCommand *internalSourceUpdated;

@end

@implementation RADTableModel

- (instancetype)initWithObjectSource:(RACSignal *)objectSource sectionSource:(RACSignal *)sectionSource sourceUpdated:(RACCommand *)sourceUpdated type:(RADTableModelType)type {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type = type;
    self.objects = nil;
    self.sections = nil;
    
    self.sourceUpdated = sourceUpdated;
    self.internalSourceUpdated = [self createInternalSourceUpdatedCommand];
    
    // Keep items updated
    @weakify(self);
    RAC(self, objects) = [objectSource flattenMap:^RACStream *(id objects) {
        @strongify(self);
        return [[self.internalSourceUpdated execute:RACTuplePack(objects, nil)] map:^id(RACTuple *tuple) {
            return tuple.first;
        }];
    }];
    
    // Keep sections updated
    RAC(self, sections) = [sectionSource flattenMap:^RACStream *(id sections) {
        @strongify(self);
        return [[self.internalSourceUpdated execute:RACTuplePack(nil, sections)] map:^id(RACTuple *tuple) {
            return tuple.second;
        }];
    }];
    
    return self;
}

- (RACCommand *)createInternalSourceUpdatedCommand {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACCommand *sourceUpdated = self.sourceUpdated;
        RACSignal *signal = sourceUpdated ? [sourceUpdated execute:input] : [RACSignal return:input];
        //        NSLog(@"signal: %@ sourceUpdatd: %@", signal, sourceUpdated);
        return signal;
    }];
    command.allowsConcurrentExecution = YES;
    return command;
}

- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == RADTableModelTypeList) {
        if (indexPath.row < self.objects.count) {
            return self.objects[indexPath.row];
        }
        else {
            return nil;
        }
    }
    else if (self.type == RADTableModelTypeSectioned) {
        NSArray *rowsForSection = self.objects[indexPath.section];
        if (indexPath.row < rowsForSection.count) {
            return rowsForSection[indexPath.row];
        }
        else {
            return nil;
        }
    }
    return nil;
}


@end
