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
#import <OptimizelySDKCore/OPTLYEventDispatcher.h>
#import <OptimizelySDKCore/OPTLYLogger.h>
#import <OptimizelySDKCore/OPTLYLoggerMessages.h>
#import <OptimizelySDKCore/OPTLYNetworkService.h>
#import "OPTLYClient.h"
#import "OPTLYDatafileManager.h"
#import "OPTLYManagerDefault.h"
#import "OPTLYManagerBuilder.h"

@interface OPTLYManagerDefault()
@property (strong, readwrite, nonatomic, nullable) OPTLYClient *optimizelyClient;
@end

@implementation OPTLYManagerDefault

+ (instancetype)init:(OPTLYManagerBuilderBlock)block {
    return [OPTLYManagerDefault initWithBuilder:[OPTLYManagerBuilder builderWithBlock:block]];
}

+ (instancetype)initWithBuilder:(OPTLYManagerBuilder *)builder {
    return [[self alloc] initWithBuilder:builder];
}

- (instancetype)init {
    return [self initWithBuilder:nil];
}

- (instancetype)initWithBuilder:(OPTLYManagerBuilder *)builder {
    self = [super init];
    if (self != nil) {
        
        // set the logger
        if (_logger) {
            if ([OPTLYLoggerUtility conformsToOPTLYLoggerProtocol:[_logger class]]) {
                return nil;
            }
        } else {
            // set the default logger if no logger is set
            _logger = [OPTLYLoggerDefault new];
        }
        
        // set the error handler
        if (_errorHandler) {
            if ([OPTLYErrorHandler conformsToOPTLYErrorHandlerProtocol:[_errorHandler class]]) {
                return nil;
            } else {
                // set the default error handler if no error handler is set
                _errorHandler = [OPTLYErrorHandlerNoOp new];
            }
        }
        
        if (!builder) {
            [_logger logMessage:OPTLYLoggerMessagesManagerBuilderNotValid
                      withLevel:OptimizelyLogLevelError];
            
            NSError *error = [NSError errorWithDomain:OPTLYErrorHandlerMessagesDomain
                                                 code:OPTLYErrorTypesBuilderInvalid
                                             userInfo:@{NSLocalizedDescriptionKey :
                                                            [NSString stringWithFormat:NSLocalizedString(OPTLYErrorHandlerMessagesManagerBuilderInvalid, nil)]}];
            [_errorHandler handleError:error];
            
            return nil;
        }
        
        if (_datafileManager) {
            if (![OPTLYDatafileManagerUtility conformsToOPTLYDatafileManagerProtocol:[_datafileManager class]]) {
                return nil;
            } else {
                _datafileManager = [OPTLYDatafileManagerBasic new];
            }
        }
        
        if (_eventDispatcher) {
            if ([OPTLYEventDispatcherUtility conformsToOPTLYEventDispatcherProtocol:[_eventDispatcher class]]) {
                return nil;
            }
        } else {
            _eventDispatcher = [OPTLYEventDispatcherBasic new];
        }
        
        if (_projectId == nil) {
            [_logger logMessage:OPTLYLoggerMessagesManagerMustBeInitializedWithProjectId
                      withLevel:OptimizelyLogLevelError];
            return nil;
        }
        
        if ([_projectId isEqualToString:@""]) {
            [_logger logMessage:OPTLYLoggerMessagesManagerProjectIdCannotBeEmptyString
                      withLevel:OptimizelyLogLevelError];
            return nil;
        }
    }
    return self;
}

// ---- Client ----

- (OPTLYClient *)initialize {
    OPTLYClient *client = [self initializeClientWithManagerSettingsAndDatafile:self.datafile];
    if (client.optimizely != nil) {
        self.optimizelyClient = client;
    }
    return client;
}

- (OPTLYClient *)initializeWithDatafile:(NSData *)datafile {
    OPTLYClient *client = [self initializeClientWithManagerSettingsAndDatafile:datafile];
    if (client.optimizely != nil) {
        self.optimizelyClient = client;
        return client;
    }
    else {
        return [self initialize];
    }
}

- (void)initializeWithCallback:(void (^)(NSError * _Nullable, OPTLYClient * _Nullable))callback {
    [self.datafileManager downloadDatafile:self.projectId completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([(NSHTTPURLResponse *)response statusCode] == 304) {
            data = [self.datafileManager getSavedDatafile];
        }
        if (!error) {
            OPTLYClient *client = [self initializeClientWithManagerSettingsAndDatafile:data];
            if (client.optimizely) {
                self.optimizelyClient = client;
            }
        } else {
            // TODO - log error
        }
        
        if (callback) {
            callback(error, self.optimizelyClient);
        }
    }];
}

- (OPTLYClient *)getOptimizely {
    return self.optimizelyClient;
}

- (OPTLYClient *)initializeClientWithManagerSettingsAndDatafile:(NSData *)datafile {
    OPTLYClient *client = [OPTLYClient init:^(OPTLYClientBuilder * _Nonnull builder) {
        builder.datafile = datafile;
        builder.errorHandler = self.errorHandler;
        builder.eventDispatcher = self.eventDispatcher;
        builder.logger = self.logger;
        builder.userProfile = self.userProfile;
        builder.clientEngine = self.clientEngine;
        builder.clientVersion = self.clientVersion;
    }];
    return client;
}

@end
