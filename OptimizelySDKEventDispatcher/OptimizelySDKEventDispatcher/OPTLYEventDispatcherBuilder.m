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

#import "OPTLYEventDispatcherBuilder.h"
#import "OPTLYEventDispatcher.h"

@implementation OPTLYEventDispatcherBuilder

+ (nullable instancetype)builderWithBlock:(nonnull OPTLYEventDispatcherBuilderBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (id) init {
    return [self initWithBlock:nil];
}

- (id)initWithBlock:(OPTLYEventDispatcherBuilderBlock)block {
    NSParameterAssert(block);
    
    self = [super init];
    if (self != nil) {
        block(self);
    }
    
    // ---- Set default values if no submodule is provided or the submodule provided is invliad ----
    // set the default logger first!
    if (![OPTLYLoggerUtility conformsToOPTLYLoggerProtocol:[_logger class]]) {
        NSString *logMessage = _logger ? @"[EVENT MANAGER BUILDER] Invalid logger handler provided." : @"[EVENT MANAGER BUILDER] No logger handler provided.";
        _logger = [OPTLYLoggerDefault new];
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
    }
    
    if (![OPTLYErrorHandlerUtility conformsToOPTLYErrorHandlerProtocol:[_errorHandler class]]) {
        NSString *logMessage = _errorHandler ? @"[EVENT MANAGER BUILDER] Invalid error handler provided." : @"[EVENT MANAGER BUILDER] No error handler provided.";
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
        _errorHandler = [OPTLYErrorHandlerNoOp new];
    }
    
    if (_eventDispatcherDispatchInterval < 0) {
        _eventDispatcherDispatchInterval = OPTLYEventDispatcherDefaultDispatchIntervalTime_ms;
        NSString *logMessage =  [NSString stringWithFormat: OPTLYLoggerMessagesEventDispatcherInvalidInterval, _eventDispatcherDispatchInterval];
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
    }
    
    if (_eventDispatcherDispatchTimeout < 0) {
        _eventDispatcherDispatchTimeout = OPTLYEventDispatcherDefaultDispatchTimeout_ms;
        [self.logger logMessage:[NSString stringWithFormat:OPTLYLoggerMessagesDatafileFetchIntervalInvalid, _eventDispatcherDispatchTimeout]
                      withLevel:OptimizelyLogLevelWarning];
    }
    
    return self;
}

@end
