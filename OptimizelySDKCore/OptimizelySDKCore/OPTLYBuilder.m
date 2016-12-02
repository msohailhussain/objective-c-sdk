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

#import "OPTLYBucketer.h"
#import "OPTLYBuilder.h"
#import "OPTLYDatafileManager.h"
#import "OPTLYErrorHandler.h"
#import "OPTLYEventBuilder.h"
#import "OPTLYEventDispatcher.h"
#import "OPTLYLogger.h"
#import "OPTLYProjectConfig.h"
#import "OPTLYUserProfile.h"

@implementation OPTLYBuilder

+ (instancetype)builderWithBlock:(OPTLYBuilderBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (id)init {
    return [self initWithBlock:nil];
}

- (id)initWithBlock:(OPTLYBuilderBlock)block {
    
    // check for nil block
    if (block == nil) {
        return nil;
    }
    
    self = [super init];
    if (self != nil) {
        block(self);
    }
    else {
        return nil;
    }
    
    // ---- Set default values if no submodule is provided or the submodule provided is invalid ----
    // set the default logger first!
    if (![OPTLYLoggerUtility conformsToOPTLYLoggerProtocol:[_logger class]]) {
        NSString *logMessage = _logger ? @"[CORE BUILDER] Invalid logger handler provided." : @"[MANAGER BUILDER] No logger handler provided.";
        _logger = [OPTLYLoggerDefault new];
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
    }
    
    if (![OPTLYDatafileManagerUtility conformsToOPTLYDatafileManagerProtocol:[_datafileManager class]]) {
        NSString *logMessage = _datafileManager ? @"[CORE BUILDER] Invalid datafile manager provided." : @"[MANAGER BUILDER] No datafile manager provided.";
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
        _datafileManager = [OPTLYDatafileManagerDefault new];
    }
    
    if (![OPTLYErrorHandlerUtility conformsToOPTLYErrorHandlerProtocol:[_errorHandler class]]) {
        NSString *logMessage = _errorHandler ? @"[CORE BUILDER] Invalid error handler provided." : @"[MANAGER BUILDER] No error handler provided.";
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
        _errorHandler = [OPTLYErrorHandlerNoOp new];
    }
    
    if (![OPTLYEventDispatcherUtility conformsToOPTLYEventDispatcherProtocol:[_eventDispatcher class]]) {
        NSString *logMessage = _eventDispatcher ? @"[CORE BUILDER] Invalid event dispatcher manager provided." : @"[MANAGER BUILDER] No event dispatcher manager provided.";
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
        _eventDispatcher = [OPTLYEventDispatcherDefault new];
    }
    
    if (![OPTLYUserProfileUtility conformsToOPTLYUserProfileProtocol:[_userProfile class]]) {
        NSString *logMessage = _userProfile ? @"[CORE BUILDER] Invalid user profile provided." : @"[MANAGER BUILDER] No user profile provided.";
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
        _userProfile = [OPTLYUserProfileNoOp new];
    }
    
    if (_datafile == nil) {
        [_logger logMessage:@"[OPTIMIZELY CORE BUILDER] Invalid datafile. Optimizely client not created." withLevel:OptimizelyLogLevelError];
        return nil;
    }
    
    _config = [OPTLYProjectConfig initWithBuilderBlock:^(OPTLYProjectConfigBuilder * _Nullable builder) {
        builder.datafile = _datafile;
        builder.errorHandler = _errorHandler;
        builder.logger = _logger;
        builder.userProfile = _userProfile;
    }];
    
    if (_config == nil) {
        NSError *error = [NSError errorWithDomain:OPTLYErrorHandlerMessagesDomain
                                             code:OPTLYErrorTypesConfigInvalid
                                         userInfo:@{NSLocalizedDescriptionKey :
                                                        NSLocalizedString(OPTLYErrorHandlerMessagesConfigInvalid, nil)}];
        [_errorHandler handleError:error];
        [_logger logMessage:OPTLYErrorHandlerMessagesConfigInvalid withLevel:OptimizelyLogLevelError];
        return nil;
    }
    
    _bucketer = [[OPTLYBucketer alloc] initWithConfig:_config];
    _eventBuilder = [[OPTLYEventBuilderDefault alloc] init];
    
    return self;
}

@end
