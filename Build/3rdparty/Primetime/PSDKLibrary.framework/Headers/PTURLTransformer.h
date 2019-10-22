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
//  PTURLTransformer.h
//  PSDKLibrary
//
//  Created by Venkat Jonnadula on 10/14/16.
//  Copyright © 2016 Adobe Systems Inc. All rights reserved.
//

#import "PTMediaPlayerItem.h"

typedef NS_ENUM(NSInteger, PTURLTransformerInputType)
{
	/** Specifies the enumeration type for transforming urls associated with Adobe Creative Repackaging Service (CRS) assets */
	PTURLTransformerInputTypeCRSCreative
};


/**
 * PTURLTransformer protocol describes the methods required to transform network urls requested by TVSDK.
 */
@protocol PTURLTransformer <NSObject>

/**
 * A function called on player initialization to configure the url transformer with the current PTMediaPlayerItem instance.
 */
- (void)configure:(PTMediaPlayerItem *)item;

/**
 * Transform the url before it is requested by TVSDK. The application must check for the input type
 * and only handle those that are relevant. If the application doesn't wish to handle the url, it must
 * either return the original url or a nil value.
 */
- (NSString *)transform:(NSString *)url forType:(PTURLTransformerInputType)type;

@end
