/*******************************************************************************
 * Copyright (c) Microsoft Open Technologies, Inc.
 * All Rights Reserved
 * See License.txt in the project root for license information.
 ******************************************************************************/

#import "UserViewController.h"
#import <office365_graph_sdk/office365_graph_sdk.h>
#import "AuthManager.h"

@interface UserViewController ()

@property (strong, nonatomic) NSDictionary *settings;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"adal_settings" ofType:@"plist"];
    _settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    [self setUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)refresh:(id)sender {
    [self setUserInfo];
}

- (void)setUserInfo {
    MSGraphServiceClient *graphClient = [[MSGraphServiceClient alloc] initWithUrl:[self.settings valueForKey:@"GraphBaseUrl"] dependencyResolver:[AuthManager instance].dependencyResolver];
 
    [[[[graphClient getusers] top:1] readWithCallback:^(NSArray<MSGraphServiceUser> *users, MSODataException *exception) {
        if (exception != nil) {
            [graphClient.resolver.logger logMessage:exception.description withLevel:LOG_LEVEL_ERROR];
        } else {
            [graphClient.resolver.logger logMessage:@"Results received" withLevel:LOG_LEVEL_INFO];
            
            MSGraphServiceUser *user = [users firstObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblDisplayName.text = user.displayName;
                self.lblAlias.text = user.userPrincipalName;
                self.lblMailNickname.text = user.mailNickname;
            });
        }
    }] resume];
}

@end
