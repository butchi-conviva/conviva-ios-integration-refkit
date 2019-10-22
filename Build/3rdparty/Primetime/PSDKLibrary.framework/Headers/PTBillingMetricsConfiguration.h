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
//  PTBillingMetricsConfiguration.h
//  PSDKLibrary
//

#import "PTTrackingMetadata.h"

/**
 * The name of the key associated with this PTBillingMetricsConfiguration instance.
 */
extern NSString *const PTBillingMetricsConfigurationMetadataKey;


/**
 * PTBillingMetricsConfiguration class contains property metadata specific to Billing functionality within TVSDK.
 */
@interface PTBillingMetricsConfiguration : PTTrackingMetadata

/** @name Properties */
/**
 * Enable/Disable sending billing metrics to Adobe Analytics.
 * Default value is NO.
 */
@property (nonatomic) BOOL enabled;

/** @name Properties */
/**
 * Standard VOD Billable Duration. Used when monitoring playback of VOD content without mid-roll ads.
 * Time is in minutes. Default is 30 minutes.
 */
@property (nonatomic) double stdVODBillableDurationMinutes;

/** @name Properties */
/**
 * Pro VOD Billable Duration. Used when monitoring playback of VOD content with mid-roll ads.
 * Time is in minutes. Default is 30 minutes.
 */
@property (nonatomic) double proVODBillableDurationMinutes;

/** @name Properties */
/**
 * Live Billable Duration. Used when monitoring playback of Live content.
 * Time is in minutes. Default is 30 mintues.
 */
@property (nonatomic) double liveBillableDurationMinutes;

/** @name Properties */
/**
 * The Adobe Analytics tracking server where the billing metrics are sent.
 * The tracking server is set automatically by TVSDK and does not need to be manually set.
 */
@property (nonatomic, retain) NSString *trackingServer;

/** @name Properties */
/**
 * Publisher ID identifies the application using the TVSDK. This may be a fully qualified application name
 * or the domain where the application is hosted.
 * The publisher ID is generated automatically by TVSDK and does not need to be manually set.
 */
@property (nonatomic, retain) NSString *publisherId;

/** @name Properties */
/**
 * The report suite in Adobe Analytics where the billing metrics are stored.
 * The report suite ID is set automatically by TVSDK and does not need to be manually set.
 */
@property (nonatomic, retain) NSString *reportSuiteId;

/** @name Properties */
/**
 * A visitor ID for the current user session.
 * The visitor ID is generated automatically by TVSDK and does not need to be manually set.
 */
@property (nonatomic, retain) NSString *visitorId;

@end
