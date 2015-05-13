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

@class MSGraphDirectoryObjectFetcher;
@class MSGraphDirectoryObjectCollectionFetcher;
@class MSGraphDeviceOperations;
@class MSGraphDeviceFetcher;

#import <orc_engine_core/orc_engine_core.h>
#import "MSGraphModels.h"

/**
* The header for type MSGraphDeviceFetcher.
*/

@protocol MSGraphDeviceFetcherProtocol<MSOrcEntityFetcher>

@optional

- (void) readWithCallback:(void (^)(MSGraphDevice *device, MSOrcError *error))callback;
- (MSGraphDeviceFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSGraphDeviceFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (MSGraphDeviceFetcher *)select:(NSString *)params;
- (MSGraphDeviceFetcher *)expand:(NSString *)value;

@required

@property (copy, nonatomic, readonly) MSGraphDeviceOperations *operations;

@end

@interface MSGraphDeviceFetcher : MSOrcEntityFetcher<MSGraphDeviceFetcherProtocol>

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSOrcExecutable>)parent;
- (void)update:(MSGraphDevice *)device callback:(void(^)(MSGraphDevice *device, MSOrcError *error))callback;
- (void)delete:(void(^)(int status, MSOrcError *error))callback;

@property (retain, nonatomic, readonly, getter=registeredOwners) MSGraphDirectoryObjectCollectionFetcher *registeredOwners;

- (MSGraphDirectoryObjectFetcher *)getRegisteredOwnersById:(NSString*)id;

@property (retain, nonatomic, readonly, getter=registeredUsers) MSGraphDirectoryObjectCollectionFetcher *registeredUsers;

- (MSGraphDirectoryObjectFetcher *)getRegisteredUsersById:(NSString*)id;


@end