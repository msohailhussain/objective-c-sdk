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

#import "OPTLYManagerBuilder.h"
#import <OptimizelySDKCore/OPTLYDatafileManager.h>
#import <OptimizelySDKCore/OPTLYErrorHandler.h>
#import <OptimizelySDKCore/OPTLYEventDispatcher.h>
#import <OptimizelySDKCore/OPTLYLogger.h>
#import <OptimizelySDKCore/OPTLYUserProfile.h>

@implementation OPTLYManagerBuilder

+ (nullable instancetype)builderWithBlock:(OPTLYManagerBuilderBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (id)init {
    return [self initWithBlock:nil];
}

- (id)initWithBlock:(OPTLYManagerBuilderBlock)block {
    NSParameterAssert(block);
    
    self = [super init];
    if (self != nil) {
        block(self);
        
        // ---- Set default values if no submodule is provided or the submodule provided is invalid ----
        // set the default logger first!
        if (![OPTLYLoggerUtility conformsToOPTLYLoggerProtocol:[_logger class]]) {
            NSString *logMessage = _logger ? OPTLYLoggerMessagesBuilderInvalidLogger : OPTLYLoggerMessagesBuilderNoLogger;
            _logger = [OPTLYLoggerDefault new];
            [_logger logMessage:[NSString stringWithFormat:logMessage, OPTLYLoggerMessagesBuilderTypeManager]
                      withLevel:OptimizelyLogLevelWarning];
        }
        
        if (![OPTLYDatafileManagerUtility conformsToOPTLYDatafileManagerProtocol:[_datafileManager class]]) {
            NSString *logMessage = _datafileManager ? OPTLYLoggerMessagesBuilderInvalidDatafileManager : OPTLYLoggerMessagesBuilderNoDatafileManager;
            [_logger logMessage:[NSString stringWithFormat:logMessage, OPTLYLoggerMessagesBuilderTypeManager]
                      withLevel:OptimizelyLogLevelWarning];
            _datafileManager = [OPTLYDatafileManagerDefault new];
        }
        
        if (![OPTLYErrorHandlerUtility conformsToOPTLYErrorHandlerProtocol:[_errorHandler class]]) {
            NSString *logMessage = _errorHandler ? OPTLYLoggerMessagesBuilderInvalidErrorHandler : OPTLYLoggerMessagesBuilderNoErrorHandler;
            [_logger logMessage:[NSString stringWithFormat:logMessage, OPTLYLoggerMessagesBuilderTypeManager]
                      withLevel:OptimizelyLogLevelWarning];
            _errorHandler = [OPTLYErrorHandlerNoOp new];
        }
        
        if (![OPTLYEventDispatcherUtility conformsToOPTLYEventDispatcherProtocol:[_eventDispatcher class]]) {
            NSString *logMessage = _eventDispatcher ? OPTLYLoggerMessagesBuilderInvalidEventDispatcher : OPTLYLoggerMessagesBuilderNoEventDispatcher;
            [_logger logMessage:[NSString stringWithFormat:logMessage, OPTLYLoggerMessagesBuilderTypeManager]
                      withLevel:OptimizelyLogLevelWarning];
            _eventDispatcher = [OPTLYEventDispatcherDefault new];
        }
        
        if (![OPTLYUserProfileUtility conformsToOPTLYUserProfileProtocol:[_userProfile class]]) {
            NSString *logMessage = _userProfile ? OPTLYLoggerMessagesBuilderInvalidUserProfile : OPTLYLoggerMessagesBuilderNoUserProfile;
            [_logger logMessage:[NSString stringWithFormat:logMessage, OPTLYLoggerMessagesBuilderTypeManager]
                      withLevel:OptimizelyLogLevelWarning];
            _userProfile = [OPTLYUserProfileNoOp new];
        }
        
        if (_datafile == nil) {
            [_logger logMessage:[NSString stringWithFormat:OPTLYLoggerMessagesBuilderInvalidDatafile, OPTLYLoggerMessagesBuilderTypeManager]
                      withLevel:OptimizelyLogLevelError];
            return nil;
        }
        
        if (_projectId == nil) {
            [_logger logMessage:OPTLYLoggerMessagesManagerMustBeInitializedWithProjectId
                      withLevel:OptimizelyLogLevelError];
            NSError *error = [NSError errorWithDomain:OPTLYErrorHandlerMessagesDomain
                                                                               code:OPTLYErrorTypesErrorHandlerInvalid
                                                                           userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(OPTLYLoggerMessagesManagerMustBeInitializedWithProjectId, nil)}];
            [_errorHandler handleError:error];
            return nil;
        }
    }
    return self;
}
@end
