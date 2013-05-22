//
//  BrowseOverflowViewController.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "BrowseOverflowViewController.h"

#import "BrowseOverflowDelegate.h"
#import "TopicTableProvider.h"
#import "QuestionTableProvider.h"
#import "QuestionDetailProvider.h"
#import "StackOverflowManager.h"
#import "Topic.h"
#import <objc/runtime.h>

@interface BrowseOverflowViewController () {
    NSMutableArray *_objects;
}
@property (nonatomic, weak) id <BrowseOverflowDelegate> delegate;

@end

@implementation BrowseOverflowViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (nil == _provider) {
        _provider = [[TopicTableProvider alloc] init];
        ((TopicTableProvider *)_provider).topicsList = [[self delegate] topics];
    }
    
    self.tableView.dataSource = _provider;
    self.tableView.delegate = _provider;
    
    // set the tableView only in case the _provider has this iVar
    objc_property_t tableViewProperty = class_getProperty([_provider class], "tableView");
    if (tableViewProperty) {
        [_provider setValue:self.tableView forKey:@"tableView"];
    }}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self delegate] manager].delegate = self;
    
    if ([self.provider isKindOfClass:[QuestionTableProvider class]]) {
        QuestionTableProvider *provider = (QuestionTableProvider *)self.provider;
        [[[self delegate] manager] fetchQuestionsOnTopic:provider.topic];
    }
    else if ([self.provider isKindOfClass:[QuestionDetailProvider class]]) {
        QuestionDetailProvider *provider = (QuestionDetailProvider *)self.provider;
        [[[self delegate] manager] fetchBodyForQuestion:provider.question];
        [[[self delegate] manager] fetchAnswersForQuestion:provider.question];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectTopic:) name:TopicTableDidSelectTopicNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectQuestion:) name:QuestionTableDidSelectQuestionNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didSelectTopic:(NSNotification *)notification
{
    Topic *selectedTopic = (Topic *)[notification object];
    
    QuestionTableProvider *provider = [[QuestionTableProvider alloc] init];
    provider.topic = selectedTopic;
    
    BrowseOverflowViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    nextViewController.provider = provider;
    
    [[self navigationController] pushViewController:nextViewController animated:YES];
}

- (void)didSelectQuestion:(NSNotification *)notification
{    
    Question *question = (Question *)[notification object];
    
    QuestionDetailProvider *provider = [[QuestionDetailProvider alloc] init];
    provider.question = question;

    BrowseOverflowViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    nextViewController.provider = provider;
    
    
    [[self navigationController] pushViewController:nextViewController animated:YES];
}

#pragma mark - StackOverflowManagerDelegate

- (void)fetchingQuestionsFailedWithError:(NSError *)error {
    
}

- (void)didReceiveQuestions:(NSArray *)questions {
    Topic *topic = ((QuestionTableProvider *)self.provider).topic;
    for (Question *thisQuestion in questions) {
        [topic addQuestion:thisQuestion];
    }
    [self.tableView reloadData];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    
}

- (void)retrievingAnswersFailedWithError:(NSError *)error {
    
}

- (void)answersReceivedForQuestion:(Question *)question {
    [self.tableView reloadData];
}

- (void)bodyReceivedForQuestion:(Question *)question {
    [self.tableView reloadData];
}

#pragma mark - BrowseOverflowDelegate

- (id)delegate
{
    if (nil == _delegate && [[[UIApplication sharedApplication] delegate] conformsToProtocol:@protocol(BrowseOverflowDelegate)]) {
        _delegate = (id)[[UIApplication sharedApplication] delegate];
    }
    return _delegate;
}

@end
