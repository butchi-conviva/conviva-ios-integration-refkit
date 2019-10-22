/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2016 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by all applicable intellectual property
 * laws, including trade secret and copyright laws.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

//
//  PTDefaultURLTransformer.h
//  PSDKLibrary
//
//  Created by Venkat Jonnadula on 10/14/16.
//  Copyright © 2016 Adobe Systems Inc. All rights reserved.
//

#import "PTURLTransformer.h"


typedef NSString * (^PTDefaultPostURLTransformHandler)(NSString *url, PTURLTransformerInputType type);

/**
 * PTDefaultURLTransformer is the default url transformer instance created within TVSDK. Application
 * can add a post url transform handler block on this instance or create a new class implementing PTURLTransformer
 * protocol instead of using the PTDefaultURLTransformer instance.
 */
@interface PTDefaultURLTransformer : NSObject <PTURLTransformer>

/**
 * A utility method invoked after the default url transformation is completed and before the request is made.
 * The application may add a handler block to transform the url without creating a class that implements the PTURLTranformer protocol
 * and registering it on the PTNetworkConfiguration metadata instance.
 */
- (void)addPostURLTransformHandler:(PTDefaultPostURLTransformHandler)handler;

@end
