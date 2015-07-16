//
//  RADCommon.h
//  ReactiveDataSource
//
//  Created by Matthew Purland on 3/30/15.
//  Copyright (c) 2015 Matthew Purland. All rights reserved.
//

// Use this for making methods unavailable
#ifndef NS_UNAVAILABLE
    #if __has_attribute(unavailable)
        #define NS_UNAVAILABLE __attribute__((unavailable("Method not available")))
    #else
        #define NS_UNAVAILABLE
    #endif
#endif

// Make init and new private using NS_UNAVAILABLE
#define RAD_PRIVATE_INIT - (instancetype)init NS_UNAVAILABLE;\
+ (instancetype)new NS_UNAVAILABLE

#if DEBUG
    #define RADLogEnabled 1
#endif

#if RADLogEnabled
    #define RADLog NSLog
#else
    #define RADLog
#endif