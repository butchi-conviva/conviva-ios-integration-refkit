//
//  KSM.m
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 22/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSM.h"
@implementation KSM

+ (void) spc2ckc:(NSData*)spc assetID:(NSString*)assetID completionHandler:(void (^)(NSError* error,NSData* ckc))completionHandler {
    

  /*  UInt8        *contentKeyCtx = NULL;
    UInt32       contentKeyCtxSize = 0;
    const char *stringAsChar = [assetID cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
    OSStatus status = SKDServerGenCKC((UInt8*)spc.bytes,spc.length,stringAsChar,&contentKeyCtx,&contentKeyCtxSize);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
       // do work here
        NSError *error = NULL;
        NSData *ckcData = NULL;
        if(0 == status && NULL != contentKeyCtx && 0 < contentKeyCtxSize){
            ckcData = [NSData dataWithBytes:contentKeyCtx length:contentKeyCtxSize];
        }
        else {
            error = [NSError errorWithDomain:@"Key-Gen" code:-1 userInfo:nil];
        }
        
        completionHandler(error,ckcData);
        
    });*/
}

@end
