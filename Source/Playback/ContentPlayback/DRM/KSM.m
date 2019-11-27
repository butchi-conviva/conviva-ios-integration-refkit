//
//  KSM.m
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 22/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSM.h"
#import "SKDServer.h"
@implementation KSM

+ (void) spc2ckc:(NSData*)spc assetID:(NSString*)assetID completionHandler:(void (^)(NSError* error,NSData* ckc))completionHandler {
    
    UInt8        *contentKeyCtx = NULL;
    UInt32       contentKeyCtxSize = 0;
    const char *stringAsChar = [assetID cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
//    OSStatus status = SKDServerGenCKC((UInt8*)spc.bytes,spc.length,stringAsChar,&contentKeyCtx,&contentKeyCtxSize);
}

@end
