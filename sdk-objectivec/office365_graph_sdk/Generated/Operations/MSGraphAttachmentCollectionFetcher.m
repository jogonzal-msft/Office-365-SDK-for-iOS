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

#import "MSGraphOrcEntities.h"

/**
* The implementation file for type MSGraphAttachmentCollectionFetcher.
*/

@implementation MSGraphAttachmentCollectionFetcher

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent {

    return [super initWithUrl:urlComponent parent:parent asClass:[MSGraphAttachment class]];
}

- (void)add:(MSGraphAttachment*)entity callback:(void (^)(MSGraphAttachment *attachment, MSOrcError *error))callback {
	
	return [super add:entity callback:^(id entityAdded, MSOrcError *e) {

        callback(entityAdded,e);
    }];
}

- (MSGraphAttachmentFetcher *)getById:(NSString *)id {

    return [[MSGraphAttachmentFetcher alloc] initWithUrl:[[NSString alloc] initWithFormat:@"('%@')" ,id] parent:self];
}

@end