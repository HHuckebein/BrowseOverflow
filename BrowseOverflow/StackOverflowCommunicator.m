//
//  StackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 30.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "StackOverflowCommunicator.h"

typedef void (^ErrorHandler)(NSError *error);
typedef void (^SuccessHandler)(NSString *objectNotation);

@interface StackOverflowCommunicator() 

@property (nonatomic, strong) NSURL             *fetchingURL;
@property (nonatomic, strong) NSURLConnection   *fetchingConnection;
@property (nonatomic, strong) NSMutableData     *mReceivedData;

@property (nonatomic, copy) ErrorHandler         errorHandler;
@property (nonatomic, copy) SuccessHandler      successHandler;

@end

NSString *const StackOverflowCommunicatorErrorDomain = @"StackOverflowCommunicatorErrorDomain";

@implementation StackOverflowCommunicator

- (void)searchForQuestionsWithTag:(NSString *)tag
{
    [self fetchContentAtURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/search?tagged=%@&pagesize=20", tag]]
               errorHandler:^(NSError *error) {
                   [_delegate searchingForQuestionsFailedWithError:error];
               }
             successHandler:^(NSString *objectNotation) {
                 [_delegate receivedQuestionsJSON: objectNotation];
             }];
}

- (void)downloadInformationForQuestionWithID:(NSInteger)identifier
{
    [self fetchContentAtURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/questions/%d?body=true", identifier]]
               errorHandler:^(NSError *error) {
                   [_delegate fetchingQuestionBodyFailedWithError:error];
               }
             successHandler:^(NSString *objectNotation) {
                 [_delegate receivedQuestionBodyJSON: objectNotation];
             }];
}

- (void)downloadAnswersToQuestionWithID:(NSInteger)identifier
{
    [self fetchContentAtURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/questions/%d/answers?body=true", identifier]]
               errorHandler:^(NSError *error) {
                   [_delegate fetchingAnswersFailedWithError: error];
               }
             successHandler:^(NSString *objectNotation) {
                 [_delegate receivedAnswerListJSON: objectNotation];
             }];
}

- (void)cancelAndDiscardURLConnection
{
    [self.fetchingConnection cancel];
    _fetchingConnection = nil;
}

- (void)fetchContentAtURL:(NSURL *)url errorHandler:(ErrorHandler)errorBlock successHandler:(SuccessHandler)successBlock
{
    self.fetchingURL = url;
    self.successHandler = successBlock;
    self.errorHandler = errorBlock;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.fetchingURL];

    [self launchConnectionForRequest:request];
}

- (void)launchConnectionForRequest:(NSURLRequest *)request
{
    [self cancelAndDiscardURLConnection];
    self.fetchingConnection = [NSURLConnection connectionWithRequest: request delegate: self];
}

- (void)dealloc {
    [self.fetchingConnection cancel];
}

- (void)setReceivedData:(NSData *)receivedData
{
    self.mReceivedData = [receivedData mutableCopy];
}

- (NSData *)receivedData
{
    return [self.mReceivedData copy];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.mReceivedData = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] != 200) {
        NSError *error = [NSError errorWithDomain: StackOverflowCommunicatorErrorDomain code:[httpResponse statusCode] userInfo:nil];
        self.errorHandler(error);
        [self cancelAndDiscardURLConnection];
    }
    else {
        self.mReceivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _mReceivedData = nil;
    _fetchingConnection = nil;
    _fetchingURL = nil;

    self.errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _fetchingConnection = nil;
    _fetchingURL = nil;
    NSString *receivedText = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    _mReceivedData = nil;
    self.successHandler(receivedText);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mReceivedData appendData: data];
}


@end
