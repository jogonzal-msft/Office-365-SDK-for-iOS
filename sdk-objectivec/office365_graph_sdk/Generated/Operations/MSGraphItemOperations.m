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
* The implementation file for type MSGraphItemOperations.
*/

@implementation MSGraphItemOperations

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent {
 
    return [super initOperationWithUrl:urlComponent parent:parent];
}

- (void)copyWithDestFolderId:(NSString *)destFolderId destFolderPath:(NSString *)destFolderPath newName:(NSString *)newName callback:(void (^)(MSGraphItem *item, MSOrcError *error))callback {
	
	NSString *destFolderIdString = [self.resolver.jsonSerializer serialize:destFolderId property:@"destFolderId"];
	NSString *destFolderPathString = [self.resolver.jsonSerializer serialize:destFolderPath property:@"destFolderPath"];
	NSString *newNameString = [self.resolver.jsonSerializer serialize:newName property:@"newName"];
	return [self copyRawWithDestFolderId:destFolderIdString destFolderPath:destFolderPathString newName:newNameString callback:^(NSString *returnValue, MSOrcError *e) {
       
	   if (e == nil) {

			MSGraphItem * result = (MSGraphItem *)[super.resolver.jsonSerializer deserialize:[returnValue dataUsingEncoding:NSUTF8StringEncoding] asClass:[MSGraphItem class]];
            callback(result, e);
        } 
		else {

            callback(nil, e);
        }
    }];
}

- (void)copyRawWithDestFolderId:(NSString *) destFolderId destFolderPath:(NSString *) destFolderPath newName:(NSString *) newName callback:(void(^)(NSString *returnValue, MSOrcError *error))callback {

	id<MSOrcRequest> request = [super.resolver createOrcRequest];
	NSArray *parameters = [[NSArray alloc] initWithObjects:
                          [[NSDictionary alloc] initWithObjectsAndKeys :destFolderId,@"destFolderId", nil],
                          [[NSDictionary alloc] initWithObjectsAndKeys :destFolderPath,@"destFolderPath", nil],
                          [[NSDictionary alloc] initWithObjectsAndKeys :newName,@"newName", nil], nil];

	NSData* payload = [[MSOrcBaseContainer generatePayloadWithParameters:parameters dependencyResolver:self.resolver] dataUsingEncoding:NSUTF8StringEncoding];

	[request setContent:payload];


	
	[request setVerb:HTTP_VERB_POST];
	 	[request.url appendPathComponent:@"Microsoft.Graph.copy"];
     
	return [super orcExecuteRequest:request callback:^(id<MSOrcResponse> response, MSOrcError *e) {
        
		if (e == nil) {
            
			callback([[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding], e);
        }
        else {

            callback([[NSString alloc] initWithFormat:@"%d", response.status], e);
        }
    }];
}
    				
- (void)contentWithCallback:(void (^)(NSStream *stream, MSOrcError *error))callback {

	id<MSOrcRequest> request = [self.resolver createOrcRequest];
	NSDictionary *params = nil;
	
	NSString *parameters = [MSOrcBaseContainer getFunctionParameters:params];

	[request.url appendPathComponent:[[NSString alloc] initWithFormat:@"content(%@)",parameters]];
	[request setVerb:HTTP_VERB_POST];

	NSURLSessionTask *task = [super orcExecuteRequest:request 
											 callback:^(id<MSOrcResponse> response, MSOrcError *e) {
       
	   if (e == nil) {

			NSStream * result = (NSStream *)[super.resolver.jsonSerializer deserialize:response.data asClass:[NSStream class]];
            callback(result, e);
        }
        else {

            callback(nil, e);
        }
    }];
    
    return task;
}
@end