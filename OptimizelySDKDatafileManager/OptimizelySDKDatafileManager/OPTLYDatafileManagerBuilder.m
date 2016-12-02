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
#import "OPTLYDatafileManager.h"

@implementation OPTLYDatafileManagerBuilder

+ (instancetype)builderWithBlock:(OPTLYDatafileManagerBuilderBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (id) init {
    return [self initWithBlock:nil];
}

- (id)initWithBlock:(OPTLYDatafileManagerBuilderBlock)block {
    NSParameterAssert(block);
    self = [super init];
    if (self != nil) {
        block(self);
        
        // ---- Set default values if no submodule is provided or the submodule provided is invalid ----
        // set the default logger first!
        if (![OPTLYLoggerUtility conformsToOPTLYLoggerProtocol:[_logger class]]) {
            NSString *logMessage = _logger ? OPTLYLoggerMessagesBuilderInvalidLogger : OPTLYLoggerMessagesBuilderNoLogger;
            
            _logger = [OPTLYLoggerDefault new];
            
            [_logger logMessage:[NSString stringWithFormat:logMessage, OPTLYLoggerMessagesBuilderTypeDatafileManager]
                      withLevel:OptimizelyLogLevelWarning];
        }
        
        if (![OPTLYErrorHandlerUtility conformsToOPTLYErrorHandlerProtocol:[_errorHandler class]]) {
            NSString *logMessage = _errorHandler ? OPTLYLoggerMessagesBuilderInvalidErrorHandler : OPTLYLoggerMessagesBuilderNoErrorHandler;
            [_logger logMessage:[NSString stringWithFormat:logMessage, OPTLYLoggerMessagesBuilderTypeDatafileManager]
                      withLevel:OptimizelyLogLevelWarning];
            _errorHandler = [OPTLYErrorHandlerNoOp new];
        }
        
        if (_projectId == nil) {
            [_logger logMessage:OPTLYDatafileManagerInitializedWithoutProjectIdMessage
                      withLevel:OptimizelyLogLevelError];
            NSError *error = [NSError errorWithDomain:OPTLYErrorHandlerMessagesDomain
                                                 code:OPTLYErrorTypesErrorHandlerInvalid
                                             userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(OPTLYLoggerMessagesManagerMustBeInitializedWithProjectId, nil)}];
            [_errorHandler handleError:error];
            return nil;
        }
        
        if (_datafileFetchInterval < 0) {
            _datafileFetchInterval = OPTLYDatafileManagerDatafileFetchIntervalDefault_s;
            [self.logger logMessage:[NSString stringWithFormat:OPTLYLoggerMessagesDatafileFetchIntervalInvalid, _datafileFetchInterval]
                          withLevel:OptimizelyLogLevelWarning];
        }
    }
    return self;
}

@end
