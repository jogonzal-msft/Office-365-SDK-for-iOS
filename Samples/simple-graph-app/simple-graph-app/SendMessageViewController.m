//
//  SendMessageViewController.m
//  simple-exchange-app
//
//  Created by Gustavo on 10/9/14.
//  Copyright (c) 2014 Lagash. All rights reserved.
//

#import "SendMessageViewController.h"
#import "BaseController.h"
#import <office365_exchange_sdk/office365_exchange_sdk.h>

@interface SendMessageViewController ()

@property MSOutlookServicesClient* client;

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaseController getClient:^(MSOutlookServicesClient *client) {
        self.client = client;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)SendMail:(id)sender{
    
    MSOutlookServicesMessage *message = [MSOutlookServicesMessage alloc];
    
    message.Subject = self.txtSubject.text;
    message.ToRecipients = [self getRecipients:self.txtTo.text];
    message.Body = [[MSOutlookServicesItemBody alloc] init];
    message.Body.Content = self.txtBody.text;
    
    NSURLSessionTask *task = [[self.client getMe].operations sendMailWithMessage:message saveToSentItems:true callback:^(int returnValue, MSODataException *error) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Message sent!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }];
    
    [task resume];
}

-(NSMutableArray<MSOutlookServicesRecipient>*)getRecipients :(NSString*)text {
    
    NSMutableArray<MSOutlookServicesRecipient>* result = (NSMutableArray<MSOutlookServicesRecipient> *)[NSMutableArray array];
    
    NSArray* recipients = [text componentsSeparatedByString:@","];
    
    for (NSString* r in recipients) {
        
        MSOutlookServicesRecipient* recipient = [[MSOutlookServicesRecipient alloc] init];
        recipient.EmailAddress = [MSOutlookServicesEmailAddress alloc];
        recipient.EmailAddress.Address = [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [result addObject: recipient];
    }
    return result;
}
@end
