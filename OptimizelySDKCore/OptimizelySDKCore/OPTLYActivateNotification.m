/****************************************************************************
 * Copyright 2018, Optimizely, Inc. and contributors                        *
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

#import "OPTLYActivateNotification.h"
#import "OPTLYExperiment.h"
#import "OPTLYVariation.h"

@implementation OPTLYActivateNotification

- (void)notify:(id)firstArg otherArgs:(va_list)args {
    
    OPTLYExperiment *experiment = (OPTLYExperiment *)firstArg;
    assert(experiment);
    assert([experiment isKindOfClass:[OPTLYExperiment class]]);
    
    NSString *userId = va_arg(args, NSString *);
    assert(userId);
    assert([userId isKindOfClass:[NSString class]]);
    
    NSDictionary *attributes = va_arg(args, NSDictionary *);
    assert(attributes);
    assert([attributes isKindOfClass:[NSDictionary class]]);
    
    OPTLYVariation *variation = va_arg(args, OPTLYVariation *);
    assert(variation);
    assert([variation isKindOfClass:[OPTLYVariation class]]);
    
    NSDictionary *logEvent = va_arg(args, NSDictionary *);
    assert(logEvent);
    assert([logEvent isKindOfClass:[NSDictionary class]]);
    
    va_end(args);
    
    [self onActivate:experiment userId:userId attributes:attributes variation:variation event:logEvent];
}

-(void)onActivate:(OPTLYExperiment *)experiment userId:(NSString *)userId attributes:(NSDictionary<NSString *,NSString *> *)attributes variation:(OPTLYVariation *)variation event:(NSDictionary<NSString *,NSString *> *)event {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
