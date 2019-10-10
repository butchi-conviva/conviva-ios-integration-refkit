/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2012 Adobe Systems Incorporated
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

#import <Foundation/Foundation.h>

/**
 * The PTNetworkAdInfo instance represents the extension info of the network ads.
 */
@interface PTNetworkAdInfo : NSObject

/** @name Properties */
/**
 * Returns the id of the network ad.
 */
@property (nonatomic, retain) NSString *adId;

/** @name Properties */
/**
 * Returns the ad system info of the network ad.
 */
@property (nonatomic, retain) NSString *adSystem;

/** @name Properties */
/**
 * Returns the extensions of the network ad.
 */
@property (nonatomic, retain) NSMutableArray<NSString *> *extensions;

/** @name Properties */
/**
 * Returns the child PTNetworkAdInfo object of the network ad.
 */
@property (nonatomic, retain) PTNetworkAdInfo *child;

/** @name Properties */
/**
 * Returns the raw vast XML associated with this network request.
 */
@property (nonatomic, retain) NSString *vastXML;

/** @name Init */
/**
 * Initializes a new instance from an Ad id.
 */
- (PTNetworkAdInfo *)initWithAdId:(NSString *)adId;

@end
