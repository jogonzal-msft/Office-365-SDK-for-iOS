/*******************************************************************************
 * Copyright (c) Microsoft Open Technologies, Inc.
 * All Rights Reserved
 * See License.txt in the project root for license information.
 ******************************************************************************/

#import <Foundation/Foundation.h>

#import "BaseTestRunner.h"
#import "TestParameters.h"
#import "Test.h"
#import "LogInController.h"
#import "BaseController.h"

@interface ListTestRunner  : BaseTestRunner

@property TestParameters *Parameters;
@property ListClient *Client;

-(id)initWithClient : (ListClient*)client;
-(NSURLSessionDataTask *)Run : (NSString *)testName completionHandler:(void (^) (Test *))result;
@end
