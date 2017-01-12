/****************************************************************************
 * Copyright 2017, Optimizely, Inc. and contributors                        *
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
#import <OptimizelySDKEventDispatcher/OPTLYEventDispatcher.h>
#import <OptimizelySDKDatafileManager/OPTLYDatafileManager.h>
#import <OptimizelySDKShared/OPTLYManagerBuilder.h>
#import <OptimizelySDKUserProfile/OPTLYUserProfile.h>
#import "OPTLYManager.h"

static NSString * const kClientEngine = @"objective-c-sdk-iOS";

@implementation OPTLYManager

- (instancetype)initWithBuilder:(OPTLYManagerBuilder *)builder {
    self = [super init];
    if (self != nil) {
        
        if (!builder) {
            [self.logger logMessage:OPTLYLoggerMessagesManagerBuilderNotValid
                          withLevel:OptimizelyLogLevelError];
            
            NSError *error = [NSError errorWithDomain:OPTLYErrorHandlerMessagesDomain
                                                 code:OPTLYErrorTypesBuilderInvalid
                                             userInfo:@{NSLocalizedDescriptionKey :
                                                            [NSString stringWithFormat:NSLocalizedString(OPTLYErrorHandlerMessagesManagerBuilderInvalid, nil)]}];
            [self.errorHandler handleError:error];
            
            return nil;
        }
        
        // set the datafile manager
        if (self.datafileManager) {
            if (![OPTLYDatafileManagerUtility conformsToOPTLYDatafileManagerProtocol:[self.datafileManager class]]) {
                return nil;
            } else {
                // set default datafile manager if no datafile manager is set
                self.datafileManager = [OPTLYDatafileManagerDefault init:^(OPTLYDatafileManagerBuilder * _Nullable builder) {
                    builder.projectId = self.projectId;
                    builder.errorHandler = self.errorHandler;
                    builder.logger = self.logger;
                }];
            }
        }
        
        // set event dispatcher
        if (self.eventDispatcher) {
            if ([OPTLYEventDispatcherUtility conformsToOPTLYEventDispatcherProtocol:[self.eventDispatcher class]]) {
                return nil;
            }
        } else {
            // set default event dispatcher if no event dispatcher is set
            self.eventDispatcher = [OPTLYEventDispatcherDefault initWithBuilderBlock:^(OPTLYEventDispatcherBuilder * _Nullable builder) {
                builder.logger = self.logger;
            }];
        }
        
        // set user profile
        if (self.userProfile) {
            if (![OPTLYUserProfileUtility conformsToOPTLYUserProfileProtocol:[self.userProfile class]]) {
                return nil;
            } else {
                // set default user profile if no user profile is set
                self.userProfile = [OPTLYUserProfileDefault initWithBuilderBlock:^(OPTLYUserProfileBuilder * _Nullable builder) {
                    builder.logger = self.logger;
                }];
            }
        }
        
        // set client engine and client version
        if (!self.clientEngine) {
            self.clientEngine = kClientEngine;
        }
        if (!self.clientVersion) {
            self.clientVersion = OPTIMIZELY_SDK_iOS_VERSION;
        }
    }
    return self;
}
@end
