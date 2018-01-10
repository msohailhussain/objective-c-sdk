//
//  OPTLYActivateNotification.m
//  OptimizelySDKCore
//
//  Created by Abdur Rafay on 03/01/2018.
//  Copyright © 2018 Optimizely. All rights reserved.
//

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
