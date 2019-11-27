//
//  KSM.m
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 22/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSM : NSObject

+ (void) spc2ckc:(NSData*)spc completionHandler:(void (^)(NSError* error,NSData* ckc))completionHandler;

@end
