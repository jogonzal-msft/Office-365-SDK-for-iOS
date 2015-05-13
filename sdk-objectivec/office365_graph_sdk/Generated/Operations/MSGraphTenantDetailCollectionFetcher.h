/*******************************************************************************
Copyright (c) Microsoft Open Technologies, Inc. All Rights Reserved.
Licensed under the MIT or Apache License; see LICENSE in the source repository
root for authoritative license information.﻿

**NOTE** This code was generated by a tool and will occasionally be
overwritten. We welcome comments and issues regarding this code; they will be
addressed in the generation tool. If you wish to submit pull requests, please
do so for the templates in that tool.

This code was generated by Vipr (https://github.com/microsoft/vipr) using
the T4TemplateWriter (https://github.com/msopentech/vipr-t4templatewriter).
******************************************************************************/

@class MSGraphTenantDetailFetcher;
@class MSGraphTenantDetailCollectionFetcher;

#import <orc_engine_core/orc_engine_core.h>
#import "MSGraphModels.h"

/**
* The header for type MSGraphTenantDetailCollectionFetcher.
*/

@protocol MSGraphTenantDetailCollectionFetcherProtocol<MSOrcCollectionFetcher>

@optional

- (void)readWithCallback:(void (^)(NSArray<MSGraphTenantDetail> *tenantDetails, MSOrcError *error))callback;

- (MSGraphTenantDetailCollectionFetcher *)select:(NSString *)params;
- (MSGraphTenantDetailCollectionFetcher *)filter:(NSString *)params;
- (MSGraphTenantDetailCollectionFetcher *)search:(NSString *)params;
- (MSGraphTenantDetailCollectionFetcher *)top:(int)value;
- (MSGraphTenantDetailCollectionFetcher *)skip:(int)value;
- (MSGraphTenantDetailCollectionFetcher *)expand:(NSString *)value;
- (MSGraphTenantDetailCollectionFetcher *)orderBy:(NSString *)params;
- (MSGraphTenantDetailCollectionFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSGraphTenantDetailCollectionFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;

@required

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent;
- (MSGraphTenantDetailFetcher *)getById:(NSString *)Id;
- (void)add:(MSGraphTenantDetail *)entity callback:(void (^)(MSGraphTenantDetail *tenantDetail, MSOrcError *error))callback;

@end

@interface MSGraphTenantDetailCollectionFetcher : MSOrcCollectionFetcher<MSGraphTenantDetailCollectionFetcherProtocol>

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent;

@end