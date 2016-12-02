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

#import "OPTLYErrorHandler.h"
#import "OPTLYLogger.h"
#import "OPTLYUserProfile.h"
#import "OPTLYProjectConfigBuilder.h"

@implementation OPTLYProjectConfigBuilder

+ (nullable instancetype)builderWithBlock:(nonnull OPTLYProjectConfigBuilderBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (id) init {
    return [self initWithBlock:nil];
}

- (id)initWithBlock:(OPTLYProjectConfigBuilderBlock)block {
    NSParameterAssert(block);
    
    if (!block) {
        return nil;
    }
    
    self = [super init];
    if (self != nil) {
        block(self);
    }
    
    // ---- Set default values for submodules if needed ----
    // set the default logger first!
    if (![OPTLYLoggerUtility conformsToOPTLYLoggerProtocol:[_logger class]]) {
        NSString *logMessage = _logger ? @"[CONFIG BUILDER] Invalid logger handler provided." : @"[MANAGER BUILDER] No logger handler provided.";
        _logger = [OPTLYLoggerDefault new];
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
    }
    
    if (![OPTLYErrorHandlerUtility conformsToOPTLYErrorHandlerProtocol:[_errorHandler class]]) {
        NSString *logMessage = _errorHandler ? @"[CONFIG BUILDER] Invalid error handler provided." : @"[MANAGER BUILDER] No error handler provided.";
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
        _errorHandler = [OPTLYErrorHandlerNoOp new];
    }
    
    if (![OPTLYUserProfileUtility conformsToOPTLYUserProfileProtocol:[_userProfile class]]) {
        NSString *logMessage = _userProfile ? @"[CONFIG BUILDER] Invalid user profile provided." : @"[MANAGER BUILDER] No user profile provided.";
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelWarning];
        _userProfile = [OPTLYUserProfileNoOp new];
    }
    
    if (!_datafile) {
        NSError *error = [NSError errorWithDomain:OPTLYErrorHandlerMessagesDomain
                                             code:OPTLYErrorTypesDatafileInvalid
                                         userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(OPTLYErrorHandlerMessagesDataFileInvalid, nil)}];
        [_errorHandler handleError:error];
        
        NSString *logMessage = OPTLYErrorHandlerMessagesDataFileInvalid;
        [_logger logMessage:logMessage withLevel:OptimizelyLogLevelError];
        return nil;
    }
    
    return self;
}

@end
