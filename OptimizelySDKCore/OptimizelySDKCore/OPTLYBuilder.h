/****************************************************************************
 * Copyright 2016, Optimizely, Inc. and contributors                        *
 *                                                                          *
 * Licensed under the Apache License, Version 2.0 (the "License");          *
 * you may not use this file except in compliance with the License.         *
 * You may obtain a copy of the License at                                  *
 *                                                                          *
 *    http://www.apache.org/licenses/LICENSE-2.0                            *
 *                                                                          *
 * Unless required by applicable law or agreed to in writing, software      *
 * distributed under the License is distributed on an "AS IS" BASIS,        *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
 * See the License for the specific language governing permissions and      *
 * limitations under the License.                                           *
 ***************************************************************************/

#import <Foundation/Foundation.h>

@class OPTLYBucketer, OPTLYEventBuilder, OPTLYEventBuilderDefault, OPTLYProjectConfig;
@protocol OPTLYDatafileManager, OPTLYErrorHandler, OPTLYEventBuilder, OPTLYEventDispatcher, OPTLYLogger, OPTLYUserProfile;

/**
 * This class contains the information on how the Optimizely instance will be built.
 */

@class OPTLYBuilder;

/// This is a block that takes the builder values.
typedef void (^OPTLYBuilderBlock)(OPTLYBuilder * _Nullable builder);

@interface OPTLYBuilder: NSObject

/// The Optimizely datafile that contains all information related to a project.
@property (nonatomic, readwrite, strong, nullable) NSData *datafile;
/// The OPTLYProjectConfig is a data structure that contains all the information from the datafile.
@property (nonatomic, readonly, strong, nullable) OPTLYProjectConfig *config;
/// The bucketer created by the builder.
@property (nonatomic, readonly, strong, nullable) OPTLYBucketer *bucketer;
/// The event builder created by the builder.
@property (nonatomic, readonly, strong, nullable) OPTLYEventBuilderDefault *eventBuilder;
/// The datafile manager manages the datafile download and caching.
/// The default datafile manager can be overridden by any object that conforms to the OPTLYDatafileManager protocol.
@property (nonatomic, readwrite, strong, nullable) id<OPTLYDatafileManager> datafileManager;
/// The error handler can handle any errors caught by the Optimizely SDK.
/// The default error handler can be overridden by any object that conforms to the OPTLYErrorHandler protocol.
@property (nonatomic, readwrite, strong, nullable) id<OPTLYErrorHandler> errorHandler;
/// The event dispatcher dispatches conversion and impression events to Optimizely backend services to be recorded as results.
/// The default event dispatcher can be overridden by any object that conforms to the OPTLYEventDispatcher protocol.
@property (nonatomic, readwrite, strong, nullable) id<OPTLYEventDispatcher> eventDispatcher;
/// The logger logs info, debug, and error data (the level of information can be set).
/// The default logger can be overridden by any object that conforms to the OPTLYLogger protocol.
@property (nonatomic, readwrite, strong, nullable) id<OPTLYLogger> logger;
/// User profile stores user-specific data, like bucketing.
/// The default logger can be overridden by any object that conforms to the OPTLYUserProfile protocol.
@property (nonatomic, readwrite, strong, nullable) id<OPTLYUserProfile> userProfile;

/// Create an Optimizely Builder object.
+ (nullable instancetype)builderWithBlock:(nonnull OPTLYBuilderBlock)block;

@end
