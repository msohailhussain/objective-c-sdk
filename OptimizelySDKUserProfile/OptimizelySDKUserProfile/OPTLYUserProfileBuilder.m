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

#import <OptimizelySDKCore/OPTLYErrorHandler.h>
#import <OptimizelySDKCore/OPTLYLogger.h>
#import "OPTLYUserProfileBuilder.h"

@implementation OPTLYUserProfileBuilder

+ (nullable instancetype)builderWithBlock:(nonnull OPTLYUserProfileBuilderBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (id) init {
    return [self initWithBlock:nil];
}

- (id)initWithBlock:(OPTLYUserProfileBuilderBlock)block {
    NSParameterAssert(block);
    
    self = [super init];
    if (self != nil) {
        block(self);
    }
    
    // ---- Set default values if no submodule is provided or the submodule provided is invliad ----
    // set the default logger first!
    if (![OPTLYLoggerUtility conformsToOPTLYLoggerProtocol:[_logger class]]) {
        NSString *logMessage = _logger ? @"[USER PROFILE BUILDER] Invalid logger handler provided." : @"[USER PROFILE BUILDER] No logger handler provided.";
        _logger = [OPTLYLoggerDefault new];
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
    }
    
    if (![OPTLYErrorHandlerUtility conformsToOPTLYErrorHandlerProtocol:[_errorHandler class]]) {
        NSString *logMessage = _errorHandler ? @"[USER PROFILE BUILDER] Invalid error handler provided." : @"[USER PROFILE BUILDER] No error handler provided.";
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
        _errorHandler = [OPTLYErrorHandlerNoOp new];
    }
    
    return self;
}

@end
