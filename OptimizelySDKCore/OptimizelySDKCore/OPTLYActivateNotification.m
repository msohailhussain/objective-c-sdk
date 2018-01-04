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

- (void)notify:(id)firstArg, ... {
    
    va_list args;
    va_start(args, firstArg);
    
    id arg = firstArg;
    assert([arg isMemberOfClass:[OPTLYExperiment class]]);
    OPTLYExperiment *experiment = (__bridge OPTLYExperiment *)args;
    
    arg = va_arg(args, id);
    assert([arg isMemberOfClass:[NSString class]]);
    NSString *userId = (__bridge NSString *)args;
    
    arg = va_arg(args, id);
    NSDictionary<NSString *,NSString *> *strToStrMap;
    assert([arg isMemberOfClass:[strToStrMap class]]);
    NSDictionary<NSString *,NSString *> *attributes = (__bridge NSDictionary<NSString *,NSString *> *)args;
    
    arg = va_arg(args, id);
    assert([arg isMemberOfClass:[OPTLYVariation class]]);
    OPTLYVariation *variation = (__bridge OPTLYVariation *)args;
    
    arg = va_arg(args, id);
    assert([arg isMemberOfClass:[strToStrMap class]]);
    NSDictionary<NSString *,NSString *> *logEvent = (__bridge NSDictionary<NSString *,NSString *> *)args;
    
    va_end(args);
    
    [self onActivate:experiment userId:userId attributes:attributes variation:variation event:logEvent];
}

-(void)onActivate:(OPTLYExperiment *)experiment userId:(NSString *)userId attributes:(NSDictionary<NSString *,NSString *> *)attributes variation:(OPTLYVariation *)variation event:(NSDictionary<NSString *,NSString *> *)event {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
