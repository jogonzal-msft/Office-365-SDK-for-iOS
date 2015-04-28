/*******************************************************************************
 * Copyright (c) Microsoft Open Technologies, Inc.
 * All Rights Reserved
 * See License.txt in the project root for license information.
 ******************************************************************************/

#import "OneNoteTestRunner.h"

@implementation OneNoteTestRunner
-(id)initWithClient : (MSOneNoteApiClient*)client{
    self.Client = client;
    return self;
}

-(NSURLSessionTask *)Run : (NSString *)testName completionHandler:(void (^) (id test))result{
    
    if([testName isEqualToString: @"TestGetNotebooks"]) return [self TestGetNotebooks:result];
    if([testName isEqualToString: @"TestGetNotebooksExpand"]) return [self TestGetNotebooksExpand:result];
    if([testName isEqualToString: @"TestGetNotebooksById"]) return [self TestGetNotebooksById:result];
    if([testName isEqualToString: @"TestCreateNotebooks"]) return [self TestCreateNotebooks:result];
    if([testName isEqualToString: @"TestGetSections"]) return [self TestGetSections:result];
    if([testName isEqualToString: @"TestCreateSections"]) return [self TestCreateSections:result];
    if([testName isEqualToString: @"TestGetSectionsById"]) return [self TestGetSectionsById:result];
    if([testName isEqualToString: @"TestGetSectionGroups"]) return [self TestGetSectionGroups:result];
    if([testName isEqualToString: @"TestGetPages"]) return [self TestGetPages:result];
    if([testName isEqualToString: @"TestGetPagesSearch"]) return [self TestGetPagesSearch:result];
    if([testName isEqualToString: @"TestGetPagesFromSection"]) return [self TestGetPagesFromSection:result];
    if([testName isEqualToString: @"TestGetPageContent"]) return [self TestGetPageContent:result];
    if([testName isEqualToString: @"TestCreateSimplePage"]) return [self TestCreateSimplePage:result];
    if([testName isEqualToString: @"TestCreatePageInSection"]) return [self TestCreatePageInSection:result];
    if([testName isEqualToString: @"TestCreatePageWithEmbeddedWebImage"]) return [self TestCreatePageWithEmbeddedWebImage:result];
    if([testName isEqualToString: @"TestCreatePageWithImage"]) return [self TestCreatePageWithImage:result];
    if([testName isEqualToString: @"TestCreatePageWithNoteTags"]) return [self TestCreatePageWithNoteTags:result];
    if([testName isEqualToString: @"TestCreatePageWithAttachment"]) return [self TestCreatePageWithAttachment:result];
    if([testName isEqualToString: @"TestPageCount"]) return [self TestPageCount:result];
    if([testName isEqualToString: @"TestPatchPage"]) return [self TestPatchPage:result];
    
    return nil;
}

-(NSMutableArray*)getTests{
    NSMutableArray* array = [NSMutableArray array];
    
    [array addObject:[[Test alloc] initWithData:self :@"TestGetNotebooks" :@"Get notebooks" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetNotebooksExpand" :@"Get notebooks with expand" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetNotebooksById" :@"Get notebooks by id" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestCreateNotebooks" :@"Create notebooks" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetSections" :@"Get sections" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestCreateSections" :@"Create sections" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetSectionsById" :@"Get sections by id" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetSectionGroups" :@"Get sections groups" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetPages" :@"Get pages" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetPagesSearch" :@"Get pages search" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetPagesFromSection" :@"Get pages from section" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestGetPageContent" :@"Get page content" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestCreateSimplePage" :@"Create simple page" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestCreatePageInSection" :@"Create page in section" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestCreatePageWithEmbeddedWebImage" :@"Create page with embedded web img" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestCreatePageWithImage" :@"Create page with image" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestCreatePageWithNoteTags" :@"Create page with note tags" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestCreatePageWithAttachment" :@"Create page with attachment" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestPageCount" :@"Page Count" ]];
    [array addObject:[[Test alloc] initWithData:self :@"TestPatchPage" :@"Page patch" ]];
    
    return array;
}

#pragma mark TestNoteBooks

-(NSURLSessionTask*)TestCreateNotebooks:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[[self.Client getnotebooks] filter:@"name eq 'Test notebook iOS'" ] readWithCallback:^(NSArray<MSOneNoteApiNotebook> *notebooks, MSODataException *error) {
        MSOneNoteApiNotebook *newNotebook = [[MSOneNoteApiNotebook alloc] init];
        newNotebook.name = @"Test notebook iOS";
        
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        if([notebooks count] == 0){
            [[[self.Client getnotebooks] add:newNotebook callback:^(MSOneNoteApiNotebook *notebook, MSODataException *e) {
                BOOL passed = false;
                NSString* message = @"";
                
                if(error == nil && notebook != nil)
                {
                    passed = true;
                    message = @"Ok - ";
                }else{
                    message = @"Not - ";
                    if(error!= nil)
                        message = [message stringByAppendingString: [error localizedDescription]];
                }
                
                test.Passed = passed;
                [test.ExecutionMessages addObject:message];
                result(test);
            }] resume];
        }else{
            test.Passed = true;
            [test.ExecutionMessages addObject:@"Ok - Notebook already exists"];
            result(test);
        }
    }];
    
    return task;
}

-(NSURLSessionTask*)TestGetNotebooksExpand:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[[[self.Client getnotebooks] expand:@"sections,sectionGroups"] filter:@"isDefault eq true"] readWithCallback:^(NSArray<MSOneNoteApiNotebook> *notebooks, MSODataException *exception) {
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        
        if (exception == nil && [notebooks count] > 0 &&
            [[[notebooks objectAtIndex:0] sections] count] > 0) {
            
            passed = true;
            message = @"Ok - ";
        }
        else {
            
            message = @"Not - ";
            if (exception != nil)
                message = [message stringByAppendingString: [exception localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestGetNotebooks:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[self.Client getnotebooks] readWithCallback:^(NSArray<MSOneNoteApiNotebook> *notebooks, MSODataException *exception) {
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        
        if (exception == nil && notebooks != nil) {
            
            passed = true;
            message = @"Ok - ";
        }
        else {
            
            message = @"Not - ";
            if (exception != nil)
                message = [message stringByAppendingString: [exception localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestGetNotebooksById:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[self.Client getnotebooks] readWithCallback:^(NSArray<MSOneNoteApiNotebook> *notebooks, MSODataException *error) {
        
        Test *test = [Test alloc];
        test.ExecutionMessages = [NSMutableArray array];
        
        if (error == nil && notebooks != nil && [notebooks count] > 0) {
            MSOneNoteApiNotebook *singleNotebook = [notebooks objectAtIndex:0];
            
            [[[[self.Client getnotebooks] getById:singleNotebook.id] readWithCallback:^(MSOneNoteApiNotebook *notebook, MSODataException *error2) {
                BOOL passed = false;
                NSString* message = @"";
                if(error2 == nil && notebook != nil)
                {
                    passed = true;
                    message = @"Ok - ";
                }else{
                    message = @"Not - ";
                    if(error!= nil)
                        message = [message stringByAppendingString: [error localizedDescription]];
                }
                
                test.Passed = passed;
                [test.ExecutionMessages addObject:message];
                result(test);
                
            }] resume];
        }else{
            NSString *message = @"Not - Error getting notebooks";
            
            if(error!= nil){
                message = [message stringByAppendingString: [error localizedDescription]];
            }
            
            test.Passed = false;
            [test.ExecutionMessages addObject:message];
            result(test);
        }
    }];
    
    return task;
}

#pragma mark TestSections

-(NSURLSessionTask*)TestGetSections:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[self.Client getsections] readWithCallback:^(NSArray<MSOneNoteApiSection> *sections, MSODataException *error) {
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        
        if (error == nil && sections != nil) {
            
            passed = true;
            message = @"Ok - ";
        }
        else {
            
            message = @"Not - ";
            
            if (error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestCreateSections:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[[[self.Client getnotebooks] filter:@"name eq 'Test notebook iOS'"] top:1] readWithCallback:^(NSArray<MSOneNoteApiNotebook> *notebooks, MSODataException *error) {
        Test *test = [Test alloc];
        test.ExecutionMessages = [NSMutableArray array];
        
        if (notebooks > 0) {
            
            MSOneNoteApiSection *newSection = [[MSOneNoteApiSection alloc]init];
            newSection.name = [@"Section-" stringByAppendingString:[[NSUUID UUID] UUIDString]];
            
            [[[[[self.Client getnotebooks]
                getById:[[notebooks objectAtIndex:0] id]] getsections]
              add:newSection callback:^(MSOneNoteApiSection *addedSection, MSODataException *e) {
                  
                  BOOL passed = false;
                  NSString* message = @"";
                  
                  if (error == nil && addedSection != nil) {
                      
                      passed = true;
                      message = @"Ok - ";
                  }
                  else {
                      
                      message = @"Not - ";
                      
                      if (error!= nil)
                          message = [message stringByAppendingString: [error localizedDescription]];
                  }
                  
                  test.Passed = passed;
                  [test.ExecutionMessages addObject:message];
                  
                  result(test);
              }] resume];
        }
        else {
            
            test.Passed = false;
            [test.ExecutionMessages addObject:@"Not - Notebook does not exist"];
            result(test);
        }
    }];
    
    return task;
}

-(NSURLSessionTask*)TestCreatePageInSection:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[[self.Client getsections] top:1] readWithCallback:^(NSArray<MSOneNoteApiSection> *sections, MSODataException *error) {
        Test *test = [Test alloc];
        test.ExecutionMessages = [NSMutableArray array];
        
        if (sections > 0) {
            
            NSString *simpleHtml = [NSString stringWithFormat: @"<html><head><title>A simple page created from basic HTML-formatted text</title><meta name=\"created\" content=\"%@\" /></head><body><p>This is a page that just contains some simple <i>formatted</i> <b>text</b></p><p>Here is a <a href=\"http://www.microsoft.com\">link</a></p></body></html>", @"2013-06-11T12:45:00.000-8:00"];
            
            NSMutableArray<MSODataMultiPartElement> *multiparElements = [[NSMutableArray alloc] init];
            MSODataMultiPartElement *m1 = [[MSODataMultiPartElement alloc] initWithName:@"Presentation" andContentString:simpleHtml];
            [multiparElements addObject:m1];
            
            // NOTE: This is throwing an exception
            [[[[[self.Client getsections] getById:[[sections objectAtIndex:0] id]] getpages] addParts:multiparElements withCallback:^(id<MSODataResponse> response, MSODataException *error2) {
                
                BOOL passed = false;
                NSString* message = @"";
                
                if (error2 == nil) {
                    
                    passed = true;
                    message = @"Ok - ";
                }
                else {
                    
                    message = @"Not - ";
                    
                    if (error!= nil)
                        message = [message stringByAppendingString: [error localizedDescription]];
                }
                
                test.Passed = passed;
                [test.ExecutionMessages addObject:message];
                
                result(test);
            }] resume];
        }
        else {
            
            test.Passed = false;
            [test.ExecutionMessages addObject:@"Not - Notebook does not exist"];
            result(test);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)TestGetSectionsById:(void(^)(Test *))result {
    
    NSURLSessionTask *task = [[self.Client getsections] readWithCallback:^(NSArray<MSOneNoteApiSection> *sections, MSODataException *error) {
        
        Test *test = [Test alloc];
        test.ExecutionMessages = [NSMutableArray array];
        
        if ([sections count] > 0) {
            
            MSOneNoteApiSection *s =[sections objectAtIndex:0];
            
            [[[[self.Client getsections] getById: s.id] readWithCallback:^(MSOneNoteApiSection *section, MSODataException *error) {
                
                BOOL passed = false;
                NSString* message = @"";
                
                if (error == nil && section != nil) {
                    
                    passed = true;
                    message = @"Ok - ";
                }
                else {
                    
                    message = @"Not - ";
                    
                    if (error!= nil)
                        message = [message stringByAppendingString: [error localizedDescription]];
                }
                
                test.Passed = passed;
                [test.ExecutionMessages addObject:message];
                result(test);
            }] resume];
        }
        else {
            
            test.Passed = false;
            [test.ExecutionMessages addObject:@"Not - No existing sections"];
            result(test);
        }
    }];
    
    return task;
}

- (NSURLSessionTask *)TestGetSectionGroups:(void(^)(Test *))result {
    
    NSURLSessionTask *task = [[self.Client getsectionGroups] readWithCallback:^(NSArray<MSOneNoteApiSectionGroup> *sectionGroups, MSODataException *error) {
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        
        if (error == nil && sectionGroups != nil) {
            
            passed = true;
            message = @"Ok - ";
        }
        else {
            
            message = @"Not - ";
            
            if (error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

#pragma mark TestPages

-(NSURLSessionTask*)TestGetPages:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[self.Client getpages] readWithCallback:^(NSArray<MSOneNoteApiPage> *pages, MSODataException *error) {
        
        BOOL passed = false;
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString *message = @"";
        
        if (error == nil && pages != nil) {
            
            passed = true;
            message = @"Ok - ";
        }
        else {
            
            message = @"Not - ";
            
            if (error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestGetPagesFromSection:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[[self.Client getsections] top:1] readWithCallback:^(NSArray<MSOneNoteApiSection> *sections, MSODataException *error) {
        Test *test = [Test alloc];
        test.ExecutionMessages = [NSMutableArray array];
        
        if (error == nil && [sections count] > 0) {
            
            [[[[[self.Client getsections]
                getById:[[sections objectAtIndex:0] id]] getpages]
              readWithCallback:^(NSArray<MSOneNoteApiPage> *pages, MSODataException *error2) {
                  
                  BOOL passed = false;
                  NSString* message = @"";
                  
                  if (error2 == nil && [pages count] > 0) {
                      
                      passed = true;
                      message = @"Ok - ";
                  }
                  else {
                      
                      message = @"Not - ";
                      
                      if (error!= nil)
                          message = [message stringByAppendingString: [error localizedDescription]];
                  }
                  
                  test.Passed = passed;
                  [test.ExecutionMessages addObject:message];
                  
                  result(test);
              }] resume];
        }
        else {
            
            test.Passed = false;
            [test.ExecutionMessages addObject:@"Not - Notebook does not exist"];
            result(test);
        }
    }];
    
    return task;
}

-(NSURLSessionTask*)TestGetPageContent:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[[self.Client getpages] top:1] readWithCallback:^(NSArray<MSOneNoteApiPage> *pages, MSODataException *error) {
        MSOneNoteApiPage *page = [pages objectAtIndex:0];
        [[[[self.Client getpages] getById:page.id] getContentWithCallback:^(NSData *content, MSODataException *error) {
            BOOL passed = false;
            
            Test *test = [Test alloc];
            
            test.ExecutionMessages = [NSMutableArray array];
            NSString* message = @"";
            if(error == nil && content != nil && content.length > 0)
            {
                passed = true;
                message = @"Ok - ";
            }else{
                message = @"Not - ";
                if(error!= nil)
                    message = [message stringByAppendingString: [error localizedDescription]];
            }
            
            test.Passed = passed;
            [test.ExecutionMessages addObject:message];
            
            result(test);
        }] resume];
    }];
    
    return task;
}

-(NSURLSessionTask*)TestCreateSimplePage:(void (^) (Test*))result{
    
    NSString *simpleHtml = [NSString stringWithFormat: @"<html><head><title>A simple page created from basic HTML-formatted text</title><meta name=\"created\" content=\"%@\" /></head><body><p>This is a page that just contains some simple <i>formatted</i> <b>text</b></p><p>Here is a <a href=\"http://www.microsoft.com\">link</a></p></body></html>", @"2013-06-11T12:45:00.000-8:00"];
    
    NSMutableArray<MSODataMultiPartElement> *multiparElements = [[NSMutableArray alloc] init];
    MSODataMultiPartElement *m1 = [[MSODataMultiPartElement alloc] initWithName:@"Presentation" andContentString:simpleHtml];
    [multiparElements addObject:m1];
    
    
    NSURLSessionTask *task = [[self.Client getpages] addParts:multiparElements withCallback:^(id<MSODataResponse> response, MSODataException *error) {
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        if(error == nil)
        {
            passed = true;
            message = @"Ok - ";
        }else{
            message = @"Not - ";
            if(error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestCreatePageWithEmbeddedWebImage:(void (^) (Test*))result{
    
    NSString *embeddedPartName = @"embedded1";
    NSString *embeddedWebPage = @"<html><head><title>An embedded webpage</title></head><body><h1>This is a screen grab of a web page</h1>\
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vehicula magna quis mauris accumsan, nec imperdiet nisi tempus. Suspendisse potenti. \
    Duis vel nulla sit amet turpis venenatis elementum. Cras laoreet quis nisi et sagittis. Donec euismod at tortor ut porta. Duis libero urna, viverra id\
    aliquam in, ornare sed orci. Pellentesque condimentum gravida felis, sed pulvinar erat suscipit sit amet. Nulla id felis quis sem blandit dapibus. Ut \
    viverra auctor nisi ac egestas. Quisque ac neque nec velit fringilla sagittis porttitor sit amet quam.</p>\
    </body></html>";
    
    NSString *simpleHtml = [NSString stringWithFormat: @"<html><head><title>A page created with an image of an html page on it</title>\
                            <meta name=\"created\" content=\"%@\" />\
                            </head><body><h1>This is a page with an image of an html page on it.</h1>\
                            <img data-render-src=\"name:%@\" alt=\"A website screen grab\" /></body></html>",[self getSerializedCurrentDate], embeddedPartName ];
    
    NSMutableArray<MSODataMultiPartElement> *multiparElements = [[NSMutableArray alloc] init];
    MSODataMultiPartElement *m1 = [[MSODataMultiPartElement alloc] initWithName:@"Presentation" andContentString:simpleHtml];
    MSODataMultiPartElement *m2 = [[MSODataMultiPartElement alloc] initWithName:embeddedPartName andContentString:embeddedWebPage];
    [multiparElements addObject:m1];
    [multiparElements addObject:m2];
    
    
    NSURLSessionTask *task = [[self.Client getpages] addParts:multiparElements withCallback:^(id<MSODataResponse> response, MSODataException *error) {
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        if(error == nil)
        {
            passed = true;
            message = @"Ok - ";
        }else{
            message = @"Not - ";
            if(error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestCreatePageWithImage:(void (^) (Test*))result{
    
    NSString *imagePartName = @"sampleImage1";
    NSString *simpleHtml = [NSString stringWithFormat: @"<html><head><title>A simple page created with an image on it</title>\
                            <meta name=\"created\" content=\"%@\" />\
                            </head><body><h1>This is a page with an image on it</h1><img src=\"name:%@\" alt=\"A beautiful logo\"/></body></html>", [self getSerializedCurrentDate],imagePartName];
    
    UIImage * someImage = [UIImage imageNamed: @"office365"];
    NSData *contentBytes = UIImagePNGRepresentation(someImage);
    
    NSMutableArray<MSODataMultiPartElement> *multiparElements = [[NSMutableArray alloc] init];
    MSODataMultiPartElement *m1 = [[MSODataMultiPartElement alloc] initWithName:@"Presentation" andContentString:simpleHtml];
    MSODataMultiPartElement *m2 = [[MSODataMultiPartElement alloc] initWithName:imagePartName andContentType:@"image/png" andContent:contentBytes];
    [multiparElements addObject:m1];
    [multiparElements addObject:m2];
    
    NSURLSessionTask *task = [[self.Client getpages] addParts:multiparElements withCallback:^(id<MSODataResponse> response, MSODataException *error) {
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        if(error == nil)
        {
            passed = true;
            message = @"Ok - ";
        }else{
            message = @"Not - ";
            if(error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestCreatePageWithNoteTags:(void (^) (Test*))result{
    NSString *simpleHtml = [NSString stringWithFormat: @"<html>\
                            <head>\
                            <title data-tag=\"to-do:completed\">A page created with note tags</title>\
                            <meta name=\"created\" content=\"%@\" />\
                            </head>\
                            <body>\
                            <h1 data-tag=\"important\">Paragraphs with predefined note tags</h1>\
                            <p data-tag=\"to-do\">Paragraph with note tag to-do (data-tag=\"to-do\")</p>\
                            <p data-tag=\"important\">Paragraph with note tag important (data-tag=\"important\")</p>\
                            <p data-tag=\"question\">Paragraph with note tag question (data-tag=\"question\")</p>\
                            <p data-tag=\"definition\">Paragraph with note tag definition (data-tag=\"definition\")</p>\
                            <p data-tag=\"highlight\">Paragraph with note tag highlight (data-tag=\"contact\")</p>\
                            <p data-tag=\"contact\">Paragraph with note tag contact (data-tag=\"contact\")</p>\
                            <p data-tag=\"address\">Paragraph with note tag address (data-tag=\"address\")</p>\
                            <p data-tag=\"phone-number\">Paragraph with note tag phone-number (data-tag=\"phone-number\")</p>\
                            <p data-tag=\"web-site-to-visit\">Paragraph with note tag web-site-to-visit (data-tag=\"web-site-to-visit\")</p>\
                            <p data-tag=\"idea\">Paragraph with note tag idea (data-tag=\"idea\")</p>\
                            <p data-tag=\"password\">Paragraph with note tag password (data-tag=\"critical\")</p>\
                            <p data-tag=\"critical\">Paragraph with note tag critical (data-tag=\"project-a\")</p>\
                            <p data-tag=\"project-a\">Paragraph with note tag project-a (data-tag=\"project-b\")</p>\
                            <p data-tag=\"project-b\">Paragraph with note tag project-b (data-tag=\"remember-for-later\")</p>\
                            <p data-tag=\"remember-for-later\">Paragraph with note tag remember-for-later (data-tag=\"remember-for-later\")</p>\
                            <p data-tag=\"movie-to-see\">Paragraph with note tag movie-to-see (data-tag=\"movie-to-see\")</p>\
                            <p data-tag=\"book-to-read\">Paragraph with note tag book-to-read (data-tag=\"book-to-read\")</p>\
                            <p data-tag=\"music-to-listen-to\">Paragraph with note tag music-to-listen-to (data-tag=\"music-to-listen-to\")</p>\
                            <p data-tag=\"source-for-article\">Paragraph with note tag source-for-article (data-tag=\"source-for-article\")</p>\
                            <p data-tag=\"remember-for-blog\">Paragraph with note tag remember-for-blog (data-tag=\"remember-for-blog\")</p>\
                            <p data-tag=\"discuss-with-person-a\">Paragraph with note tag discuss-with-person-a (data-tag=\"discuss-with-person-a\")</p>\
                            <p data-tag=\"discuss-with-person-b\">Paragraph with note tag discuss-with-person-b (data-tag=\"discuss-with-person-a\")</p>\
                            <p data-tag=\"discuss-with-manager\">Paragraph with note tag discuss-with-manager (data-tag=\"discuss-with-manager\")</p>\
                            <p data-tag=\"send-in-email\">Paragraph with note tag send-in-email (data-tag=\"send-in-email\")</p>\
                            <p data-tag=\"schedule-meeting\">Paragraph with note tag schedule-meeting (data-tag=\"schedule-meeting\")</p>\
                            <p data-tag=\"call-back\">Paragraph with note tag call-back (data-tag=\"call-back\")</p>\
                            <p data-tag=\"to-do-priority-1\">Paragraph with note tag to-do-priority-1 (data-tag=\"to-do-priority-1\")</p>\
                            <p data-tag=\"to-do-priority-2\">Paragraph with note tag to-do-priority-2 (data-tag=\"to-do-priority-2\")</p>\
                            <p data-tag=\"client-request\">Paragraph with note tag client-request (data-tag=\"client-request\")</p>\
                            <br/>\
                            <p style=\"font-size: 16px; font-family: Calibri, sans-serif\">Paragraphs with note tag status</p>\
                            <p data-tag=\"to-do:completed\">Paragraph with note tag status completed</p>\
                            <p data-tag=\"call-back:completed\">Paragraph with note tag status completed</p>\
                            <br/>\
                            <p style=\"font-size: 16px; font-family: Calibri, sans-serif\">Paragraph with multiple note tags</p>\
                            <p data-tag=\"critical, question\">Paragraph with two note tags</p>\
                            <p data-tag=\"password, send-in-email\">Multiple note tags</p>\
                            <h1>List Item with a note tag</h1>\
                            <li data-tag=\"to-do\" id=\"todoitem2\">Build a todo app with OneNote APIs</li>\
                            <p style=\"font-size: 16px; font-family: Calibri, sans-serif\">Image with note tag</p>\
                            <img data-tag=\"important\" src=\"http://placecorgi.com/300\" />\
                            </body>\
                            </html>",[self getSerializedCurrentDate]];
    
    NSMutableArray<MSODataMultiPartElement> *multiparElements = [[NSMutableArray alloc] init];
    MSODataMultiPartElement *m1 = [[MSODataMultiPartElement alloc] initWithName:@"Presentation" andContentString:simpleHtml];
    [multiparElements addObject:m1];
    
    NSURLSessionTask *task = [[self.Client getpages] addParts:multiparElements withCallback:^(id<MSODataResponse> response, MSODataException *error) {
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        if(error == nil)
        {
            passed = true;
            message = @"Ok - ";
        }else{
            message = @"Not - ";
            if(error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}


-(NSURLSessionTask*)TestCreatePageWithAttachment:(void (^) (Test*))result{
    NSString *attachmentPartName = @"attachment1";
    NSString *pageHtml = [NSString stringWithFormat: @"<html><head><title>A page created with a file attachment</title>\
                          <meta name=\"created\" content=\"%@\" /></head>\
                          <body><h1>This is a page with a text file attachment</h1>\
                          <object data-attachment=\"dummyFile.txt\" data=\"name:\%@\" /></body></html>", [self getSerializedCurrentDate], attachmentPartName ];
    
    NSData *attachmentContent = [@"Dummy content" dataUsingEncoding: NSUTF8StringEncoding];
    
    NSMutableArray<MSODataMultiPartElement> *multiparElements = [[NSMutableArray alloc] init];
    MSODataMultiPartElement *m1 = [[MSODataMultiPartElement alloc] initWithName:@"Presentation" andContentString:pageHtml];
    MSODataMultiPartElement *m2 = [[MSODataMultiPartElement alloc] initWithName:attachmentPartName andContentType:@"text/plain" andContent:attachmentContent];
    [multiparElements addObject:m1];
    [multiparElements addObject:m2];
    
    NSURLSessionTask *task = [[self.Client getpages] addParts:multiparElements withCallback:^(id<MSODataResponse> response, MSODataException *error) {
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        if(error == nil)
        {
            passed = true;
            message = @"Ok - ";
        }else{
            message = @"Not - ";
            if(error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestPageCount:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[self.Client getpages] count:^(NSInteger myInt, MSODataException *exception) {
        
        BOOL passed = false;
        
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString* message = @"";
        
        if (exception == nil) {
            
            passed = true;
            message = [NSString stringWithFormat:@"Ok - %ld pages", (long)myInt];
        }
        else {
            
            message = @"Not - ";
            if (exception != nil)
                message = [message stringByAppendingString: [exception localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestGetPagesSearch:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[[self.Client getpages] search:@"disney"] readWithCallback:^(NSArray<MSOneNoteApiPage> *pages, MSODataException *error) {
        
        BOOL passed = false;
        Test *test = [Test alloc];
        
        test.ExecutionMessages = [NSMutableArray array];
        NSString *message = @"";
        
        if (error == nil && pages != nil) {
            
            passed = true;
            message = @"Ok - ";
        }
        else {
            
            message = @"Not - ";
            
            if (error!= nil)
                message = [message stringByAppendingString: [error localizedDescription]];
        }
        
        test.Passed = passed;
        [test.ExecutionMessages addObject:message];
        
        result(test);
    }];
    
    return task;
}

-(NSURLSessionTask*)TestPatchPage:(void (^) (Test*))result{
    
    NSURLSessionTask *task = [[[self.Client getpages] top:1] readWithCallback:^(NSArray<MSOneNoteApiPage> *pages, MSODataException *error) {
        MSOneNoteApiPage *page = [pages objectAtIndex:0];
        
        NSMutableArray<MSOneNoteApiPatchContentCommand> *commands = [[NSMutableArray alloc] init];
        MSOneNoteApiPatchContentCommand *m1 = [[MSOneNoteApiPatchContentCommand alloc] init];
        m1.action = MSOneNoteApi_PatchActionType_Replace;
        m1.content = @"<p>PATCHED</p>";
        [commands addObject:m1];
        
        [[[self.Client getpages] getById:page.id].operations patchContentWithCommands:commands callback:^(int returnValue, MSODataException *exception) {
            
            BOOL passed = false;
            
            Test *test = [Test alloc];
            
            test.ExecutionMessages = [NSMutableArray array];
            NSString* message = @"";
            if(exception == nil)
            {
                passed = true;
                message = @"Ok - ";
            }else{
                message = @"Not - ";
                if(error!= nil)
                    message = [message stringByAppendingString: [error localizedDescription]];
            }
            
            test.Passed = passed;
            [test.ExecutionMessages addObject:message];
            
            result(test);
        }];
    }];
    
    return task;
    
}

-(NSString *) getSerializedCurrentDate{
    return [MSOCalendarSerializer serialize:[NSDate date]];
}

@end
