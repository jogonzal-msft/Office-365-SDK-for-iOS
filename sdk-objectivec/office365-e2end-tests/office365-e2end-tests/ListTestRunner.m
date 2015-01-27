/*******************************************************************************
 * Copyright (c) Microsoft Open Technologies, Inc.
 * All Rights Reserved
 * See License.txt in the project root for license information.
 ******************************************************************************/


#import <office365-lists-sdk/ListEntity.h>
#import <office365-lists-sdk/ListItem.h>
#import <office365-lists-sdk/ListField.h>
#import <office365-lists-sdk/ListClient.h>
#import "ListTestRunner.h"

@implementation ListTestRunner
-(id)initWithClient : (ListClient*)client{
    self.Client = client;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSString* mail = [userDefaults objectForKey: @"TestMail"];
    //self.TestMail = mail == nil ? @"":mail ;
    
    return self;
}

-(NSURLSessionDataTask *)Run : (NSString *)testName completionHandler:(void (^) (Test *test))result{
    
    if ([testName isEqualToString: @"TestGetLists"]) return [self TestGetListsWithCompletionHandler:result];
    if([testName isEqualToString:@"TestGetListByName"]) return [self TestGetListWithCompletionHandler:result];
    if([testName isEqualToString:@"TestNonexistentGetListByName"]) return [self TestGetNonexistentListWithCompletionHandler: result];
    if([testName isEqualToString:@"TestGetListItems"]) return [self TestGetListItemWithCompletionHandler: result];
    if ([testName isEqualToString:@"TestGetListFields"]) return  [self TestGetListFieldWithCompletionHandler :result];
    if([testName isEqualToString:@"TestCreateList"]) return  [self TestCreateListsWithCompletionHandler:result];
    if([testName isEqualToString:@"TestDeleteList"]) return [self TestDeleteListsWithCompletionHandler:result];
    
    return nil;
}

-(NSMutableArray*)getTests{
    NSMutableArray* array = [NSMutableArray array];
    
    [array addObject:[[Test alloc] initWithData:self :@"TestGetLists" :@"Get Lists" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetListByName" :@"Get List By Name" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestNonexistentGetListByName" :@"Get Nonexistent List By Name" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetListItems" :@"Get List Items" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetListFields" :@"Get List Fields" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestDeleteList" :@"Delete List" ]];
    return array;
}


-(NSURLSessionDataTask*)TestGetListsWithCompletionHandler:(void (^) (Test*))result{
    
    NSURLSessionDataTask *task = [[self Client] getLists:^(NSMutableArray *lists, NSError *error) {
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        
        NSString* message = [lists count] > 0 ? @"Ok - ": @"Not - ";
        
        if([lists count] > 0){
            
            for (ListEntity *entity in lists) {
                if(entity.Id == nil || [entity getTitle] == nil){
                    passed = false;
                    break;
                }
                passed = true;
            }
        }
        
        test.Passed = passed;
        
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionDataTask*)TestGetListWithCompletionHandler:(void (^) (Test*))result{
    
    NSURLSessionDataTask *task = [[self Client] getList:@"Documentos" callback:^(ListEntity *list, NSError *error) {
        
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        
        NSString* message = @"";
        
        if(list != nil && list.Id != nil && [list getTitle] != nil){
            passed = true;
            message= @"Ok - ";
        }
        else{
            message = @"Not - ";
            if(error != nil)
                message = [message stringByAppendingString:error.localizedDescription];
        }
        
        test.Passed = passed;
        
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionDataTask*)TestGetNonexistentListWithCompletionHandler:(void (^) (Test*))result{
    
    NSURLSessionDataTask *task = [[self Client] getList:@"Nonexistent list" callback:^(ListEntity *list, NSError *error) {
        
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        
        NSString* message = list == nil ? @"Ok - ": @"Not - ";
        
        if(list == nil){
            passed = true;
        }
        
        test.Passed = passed;
        
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionDataTask*)TestGetListItemWithCompletionHandler:(void (^) (Test*))result{
    
    NSURLSessionDataTask *task = [[self Client] getListItems:@"Documentos" callback:^(NSMutableArray *listItems, NSError *error) {
        
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        
        NSString* message = listItems != nil ? @"Ok - ": @"Not - ";
        
        if([listItems count ] > 0 ){
             passed = true;
        }
        
        test.Passed = passed;
        
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionDataTask*)TestGetListFieldWithCompletionHandler:(void (^) (Test*))result{
    
    NSURLSessionDataTask *task = [[self Client] getListFields:@"Documentos" callback:^(NSMutableArray *listFields, NSError *error) {
        
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        
        NSString* message = listFields != nil ? @"Ok - ": @"Not - ";
        
        if([listFields count ] > 0 ){
            passed = true;
        }
        
        test.Passed = passed;
        
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionDataTask*)TestCreateListsWithCompletionHandler:(void (^) (Test*))result{
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    ListEntity *newList = [[ListEntity alloc] init];
    newList.title = [@"List " stringByAppendingString:UUID];
    //newList.description =@"Description 1";
    
    NSURLSessionDataTask *task = [[self Client] createList:newList :^(ListEntity *list, NSError *error) {
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        
        NSString* message = list != nil ? @"Ok - ": @"Not - ";
        
        if([[list getTitle] isEqualToString:newList.title]){
            passed = TRUE;
        }
        
        
        test.Passed = passed;
        
        [test.ExecutionMessages addObject:message];
        
        [[self Client] deleteList:list :^(BOOL success, NSError *error) {
            if(error!= nil)
                NSLog(@"Error: %@", error);
        }];
        
        result(test);
    }];
    
    return task;
}


-(NSURLSessionDataTask*)TestDeleteListsWithCompletionHandler:(void (^) (Test*))result{
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    ListEntity *newList = [[ListEntity alloc] init];
    newList.title = [@"List " stringByAppendingString:UUID];
    //newList.description =@"Description 1";
    
    NSURLSessionDataTask *taskCreate = [[self Client] createList:newList :^(ListEntity *list, NSError *error) {
        
        NSURLSessionDataTask *taskDelete = [[self Client] deleteList:list :^(bool success, NSError *derror) {
            
            Test *test = [Test alloc];
            
            test.ExecutionMessages = [NSMutableArray array];
            
            NSString* message = success ? @"Ok - ": @"Not - ";
            
            test.Passed = success;
            
            [test.ExecutionMessages addObject:message];
            
            result(test);
            
        }];
        
        [taskDelete resume];
    }];
    
    return taskCreate;
}




-(NSURLSessionDataTask*)TestDefaultWithCompletionHandler:(void (^) (Test *))result{
    
    NSURLSessionDataTask* task = [[self Client] getLists:^(NSMutableArray *lists, NSError *error) {
        
        Test *test = [Test alloc];
        test.Passed = false;
        test.ExecutionMessages = [NSMutableArray array];
        result(test);
    }];
    
    return task;
}
@end
