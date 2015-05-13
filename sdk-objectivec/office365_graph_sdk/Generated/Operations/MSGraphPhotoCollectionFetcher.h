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

@class MSGraphPhotoFetcher;
@class MSGraphPhotoCollectionFetcher;

#import <orc_engine_core/orc_engine_core.h>
#import "MSGraphModels.h"

/**
* The header for type MSGraphPhotoCollectionFetcher.
*/

@protocol MSGraphPhotoCollectionFetcherProtocol<MSOrcCollectionFetcher>

@optional

- (void)readWithCallback:(void (^)(NSArray<MSGraphPhoto> *photos, MSOrcError *error))callback;

- (MSGraphPhotoCollectionFetcher *)select:(NSString *)params;
- (MSGraphPhotoCollectionFetcher *)filter:(NSString *)params;
- (MSGraphPhotoCollectionFetcher *)search:(NSString *)params;
- (MSGraphPhotoCollectionFetcher *)top:(int)value;
- (MSGraphPhotoCollectionFetcher *)skip:(int)value;
- (MSGraphPhotoCollectionFetcher *)expand:(NSString *)value;
- (MSGraphPhotoCollectionFetcher *)orderBy:(NSString *)params;
- (MSGraphPhotoCollectionFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSGraphPhotoCollectionFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;

@required

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent;
- (MSGraphPhotoFetcher *)getById:(NSString *)Id;
- (void)add:(MSGraphPhoto *)entity callback:(void (^)(MSGraphPhoto *photo, MSOrcError *error))callback;

@end

@interface MSGraphPhotoCollectionFetcher : MSOrcCollectionFetcher<MSGraphPhotoCollectionFetcherProtocol>

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent;

@end