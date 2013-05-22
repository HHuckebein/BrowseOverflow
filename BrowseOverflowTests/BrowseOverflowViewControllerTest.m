//
//  BrowseOverflow - BrowseOverflowViewControllerTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "BrowseOverflowViewController.h"

    // Collaborators
#import <objc/runtime.h>
#import "TopicTableProvider.h"
#import "QuestionTableProvider.h"
#import "Topic.h"
#import "QuestionTableProvider.h"
#import "Question.h"
#import "QuestionDetailProvider.h"
#import "StackOverflowManager.h"
#import "AppDelegate.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


static const char *notificationKey = "BrowseOverflowViewControllerTestsAssociatedNotificationKey";
static const char *delegateKey = "BrowseOverflowViewControllerTestsAssociatedDelegateKey";

@implementation BrowseOverflowViewController (TestNotificationDelivery)

- (void)browseOverflowControllerTests_didSelectTopic:(NSNotification *)note {
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

- (void)browseOverflowControllerTests_didSelectQuestion:(NSNotification *)note {
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

- (AppDelegate *)browseOverflowControllerTests_AppDelegate
{
    AppDelegate *delegate = objc_getAssociatedObject(self, delegateKey);
    return delegate;
}

- (void)initWithAppDelegate:(AppDelegate *)delegate
{
    objc_setAssociatedObject(self, delegateKey, delegate, OBJC_ASSOCIATION_RETAIN);
}

@end


@interface BrowseOverflowViewControllerTest : SenTestCase
@property (nonatomic, strong) BrowseOverflowViewController *sut;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) AppDelegate *mockAppDelegate;
@end

@implementation BrowseOverflowViewControllerTest
{
    SEL realUserDidSelectTopic, testUserDidSelectTopic;
    SEL realUserDidSelectQuestion, testUserDidSelectQuestion;
    SEL realAppDelegate, testAppDelegate;
}

+ (void)swapInstanceMethodsForClass:(Class)cls selector:(SEL)sel1 andSelector:(SEL)sel2
{
    Method method1 = class_getInstanceMethod(cls, sel1);
    Method method2 = class_getInstanceMethod(cls, sel2);
    method_exchangeImplementations(method1, method2);
}

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.sut = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BrowseOverflowViewController class])];
    [self.sut view];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.sut];
    
    self.mockAppDelegate = mock([AppDelegate class]);

    objc_removeAssociatedObjects(_sut);
    
    realUserDidSelectTopic = @selector(didSelectTopic:);
    testUserDidSelectTopic = @selector(browseOverflowControllerTests_didSelectTopic:);
    
    realUserDidSelectQuestion = @selector(didSelectQuestion:);
    testUserDidSelectQuestion = @selector(browseOverflowControllerTests_didSelectQuestion:);
    
    realAppDelegate = @selector(appDelegate);
    testAppDelegate = @selector(browseOverflowControllerTests_AppDelegate);
}

- (void)tearDown
{
    objc_removeAssociatedObjects(_sut);
    _sut = nil;
    _navController = nil;
    _mockAppDelegate = nil;
    
    [super tearDown];
}

- (void)testViewControllersTableViewShouldBeConnected
{
    assertThat([self.sut tableView], is(notNilValue()));
}

- (void)testViewControllerConnectsTableViewsDataSourceInViewDidLoad
{
    // given
    id dataSource = mockObjectAndProtocol([NSObject class], @protocol(UITableViewDataSource));
    self.sut.provider = dataSource;
    
    // when
    [self.sut viewDidLoad];
    
    // then
    assertThat(self.sut.tableView.dataSource, is(equalTo(dataSource)));
}

- (void)testViewControllerConnectsTableViewsDelegateInViewDidLoad
{
    // given
    id delegate = mockObjectAndProtocol([NSObject class], @protocol(UITableViewDelegate));
    self.sut.provider = delegate;
    
    // when
    [self.sut viewDidLoad];
    
    // then
    assertThat(self.sut.tableView.delegate, is(equalTo(delegate)));
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications
{
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectTopic
                                                      andSelector: testUserDidSelectTopic];

    // when
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    
    // then
    assertThat(objc_getAssociatedObject(self.sut, notificationKey), is(nilValue()));

    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectTopic
                                                      andSelector: testUserDidSelectTopic];
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear
{
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectTopic
                                                      andSelector: testUserDidSelectTopic];
    // when
    [self.sut viewDidAppear:NO];
    [self.sut viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    
    // then
    assertThat(objc_getAssociatedObject(self.sut, notificationKey), is(nilValue()));

    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectTopic
                                                      andSelector: testUserDidSelectTopic];
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear
{
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectTopic
                                                      andSelector: testUserDidSelectTopic];
    // when
    [self.sut viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    
    // then
    assertThat(objc_getAssociatedObject(self.sut, notificationKey), is(notNilValue()));
    
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectTopic
                                                      andSelector: testUserDidSelectTopic];
}

- (void)testSelectingTopicPushesNewViewController
{
    // when
    [self.sut performSelector:@selector(didSelectTopic:) withObject:nil];
    
    // then
    assertThatBool([self.navController topViewController] == self.sut, is(equalToBool(FALSE)));
}

- (void)testNewViewControllerHasAQuestionListProviderForTheSelectedTopic
{
    // given
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    NSNotification *iPhoneTopicSelectedNotification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:topic];
    
    // when
    [self.sut performSelector:@selector(didSelectTopic:) withObject:iPhoneTopicSelectedNotification];
    
    // then
    BrowseOverflowViewController *nextViewController = (BrowseOverflowViewController *)self.navController.topViewController;
    
    assertThatBool([nextViewController.provider isKindOfClass:[QuestionTableProvider class]], is(equalToBool(TRUE)));
    assertThat([(QuestionTableProvider *)nextViewController.provider topic], is(equalTo(topic)));
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveQuestionSelectionNotification
{
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectQuestion
                                                      andSelector:testUserDidSelectQuestion];

    // given
    Question *question = [[Question alloc] init];
    
    // when
    [[NSNotificationCenter defaultCenter] postNotificationName:QuestionTableDidSelectQuestionNotification object:question userInfo:nil];
    
    // then
    assertThat(objc_getAssociatedObject(self.sut, notificationKey), is(nilValue()));
    
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectQuestion
                                                      andSelector:testUserDidSelectQuestion];
}

- (void)testViewControllerReceivesQuestionSelectionNotificationAfterViewDidAppear
{
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectQuestion
                                                      andSelector:testUserDidSelectQuestion];
    
    // given
    Question *question = [[Question alloc] init];
    
    // when
    [self.sut viewDidAppear:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:QuestionTableDidSelectQuestionNotification object:question userInfo:nil];
    
    // then
    assertThat(objc_getAssociatedObject(self.sut, notificationKey), is(notNilValue()));
    
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectQuestion
                                                      andSelector:testUserDidSelectQuestion];
}

- (void)testViewControllerDoesNotReceiveQuestionSelectNotificationAfterViewWillDisappear
{
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectQuestion
                                                      andSelector:testUserDidSelectQuestion];
    
    // given
    Question *question = [[Question alloc] init];
    
    // when
    [self.sut viewDidAppear:NO];
    [self.sut viewWillDisappear:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:QuestionTableDidSelectQuestionNotification object:question userInfo:nil];
    
    // then
    assertThat(objc_getAssociatedObject(self.sut, notificationKey), is(nilValue()));
    
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realUserDidSelectQuestion
                                                      andSelector:testUserDidSelectQuestion];
}

- (void)testSelectingQuestionPushesNewViewController
{
    // when
    [self.sut performSelector:@selector(didSelectQuestion:) withObject:nil];
    
    // then
    assertThatBool([self.navController topViewController] == self.sut, is(equalToBool(FALSE)));
}


- (void)testViewControllerPushedOnQuestionSelectionHasQuestionDetailDataSourceForSelectedQuestion
{
    // given
    Question *sampleQuestion = [[Question alloc] init];
    NSNotification *questionSelectedNotification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:sampleQuestion];
    
    // when
    [self.sut performSelector:@selector(didSelectQuestion:) withObject:questionSelectedNotification];
    
    // then
    BrowseOverflowViewController *nextViewController = (BrowseOverflowViewController *)self.navController.topViewController;
    assertThatBool([nextViewController.provider isKindOfClass:[QuestionDetailProvider class]], is(equalToBool(TRUE)));
    assertThat([(QuestionDetailProvider *)nextViewController.provider question], is(equalTo(sampleQuestion)));
}

- (void)testViewWillAppearOnQuestionListInitiatesLoadingOfQuestions
{
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realAppDelegate
                                                      andSelector:testAppDelegate];
    
    // given
    [self.sut initWithAppDelegate:self.mockAppDelegate];
    
    StackOverflowManager *mockManager = mockObjectAndProtocol([StackOverflowManager class], @protocol(StackOverflowManagerDelegate));
    [given([self.mockAppDelegate manager]) willReturn:mockManager];
    
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    QuestionTableProvider *provider = [[QuestionTableProvider alloc] init];
    provider.topic = topic;
    
    self.sut.provider = provider;
    
    // when
    [self.sut viewWillAppear:NO];
    
    // then
    [verify(mockManager) fetchQuestionsOnTopic:topic];
    
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realAppDelegate
                                                      andSelector:testAppDelegate];
}

- (void)testViewWillAppearOnQuestionDetailInitiatesLoadingOfAnswersAndBody
{
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realAppDelegate
                                                      andSelector:testAppDelegate];
    
    // given
    [self.sut initWithAppDelegate:self.mockAppDelegate];
    
    StackOverflowManager *mockManager = mockObjectAndProtocol([StackOverflowManager class], @protocol(StackOverflowManagerDelegate));
    [given([self.mockAppDelegate manager]) willReturn:mockManager];
    
    Question *question = [[Question alloc] init];
    QuestionDetailProvider *provider = [[QuestionDetailProvider alloc] init];
    provider.question = question;
    
    self.sut.provider = provider;
    
    // when
    [self.sut viewWillAppear:NO];
    
    // then
    [verify(mockManager) fetchBodyForQuestion:question];
    
    [BrowseOverflowViewControllerTest swapInstanceMethodsForClass:[BrowseOverflowViewController class]
                                                         selector:realAppDelegate
                                                      andSelector:testAppDelegate];
}


//- (void)testViewWillAppearOnQuestionDetailInitiatesLoadingOfAnswersAndBody {
//    viewController.objectConfiguration = testConfiguration;
//    viewController.dataSource = [[QuestionDetailDataSource alloc] init];
//    [viewController viewWillAppear: YES];
//    STAssertTrue([manager didFetchQuestionBody], @"View controller should arrange for question detail to be loaded");
//    STAssertTrue([manager didFetchAnswers], @"View controller should arrange for answers to be loaded");
//}
//
//- (void)testQuestionsNotLoadedForDetailView {
//    viewController.objectConfiguration = testConfiguration;
//    viewController.dataSource = [[QuestionDetailDataSource alloc] init];
//    [viewController viewWillAppear: YES];
//    STAssertFalse([manager didFetchQuestions], @"Don't load question when displaying answers");
//}
//
//- (void)testDetailsNotLoadedForQuestionListView {
//    viewController.objectConfiguration = testConfiguration;
//    viewController.dataSource = [[QuestionListTableDataSource alloc] init];
//    [viewController viewWillAppear: YES];
//    STAssertFalse([manager didFetchQuestionBody], @"View controller should not arrange for question detail to be loaded");
//    STAssertFalse([manager didFetchAnswers], @"View controller should not arrange for answers to be loaded");
//}
//
//- (void)testNoDataLoadedForTopicListView {
//    viewController.objectConfiguration = testConfiguration;
//    STAssertFalse([manager didFetchQuestions], @"Don't load question when displaying topics");
//    STAssertFalse([manager didFetchQuestionBody], @"View controller should not arrange for question detail to be loaded");
//    STAssertFalse([manager didFetchAnswers], @"View controller should not arrange for answers to be loaded");
//}
//
//- (void)testViewControllerConformsToStackOverflowManagerDelegateProtocol {
//    STAssertTrue([viewController conformsToProtocol: @protocol(StackOverflowManagerDelegate)], @"View controllers need to be StackOverflowManagerDelegates");
//}
//
//- (void)testViewControllerConfiguredAsStackOverflowManagerDelegateOnManagerCreation {
//    [viewController viewWillAppear: YES];
//    STAssertEqualObjects(viewController.manager.delegate, viewController, @"View controller sets itself as the manager's delegate");
//}
//
//- (void)testDownloadedQuestionsAreAddedToTopic {
//    QuestionListTableDataSource *topicDataSource = [[QuestionListTableDataSource alloc] init];
//    viewController.dataSource = topicDataSource;
//    Topic *topic = [[Topic alloc] initWithName: @"iPhone" tag: @"iphone"];
//    topicDataSource.topic = topic;
//    Question *question1 = [[Question alloc] init];
//    [viewController didReceiveQuestions: [NSArray arrayWithObject: question1]];
//    STAssertEqualObjects([topic.recentQuestions lastObject], question1, @"Question was added to the topic");
//}
//
//- (void)testTableViewReloadedWhenQuestionsReceived {
//    QuestionListTableDataSource *topicDataSource = [[QuestionListTableDataSource alloc] init];
//    viewController.dataSource = topicDataSource;
//    ReloadDataWatcher *watcher = [[ReloadDataWatcher alloc] init];
//    viewController.tableView = (UITableView *)watcher;
//    [viewController didReceiveQuestions: [NSArray array]];
//    STAssertTrue([watcher didReceiveReloadData], @"Table view was reloaded after fetching new data");
//}
//
//- (void)testTableViewReloadedWhenAnswersReceived {
//    QuestionDetailDataSource *detailDataSource = [[QuestionDetailDataSource alloc] init];
//    viewController.dataSource = detailDataSource;
//    ReloadDataWatcher *watcher = [[ReloadDataWatcher alloc] init];
//    viewController.tableView = (UITableView *)watcher;
//    [viewController answersReceivedForQuestion: nil];
//    STAssertTrue([watcher didReceiveReloadData], @"Table view data was reloaded after fetching new answers");
//}
//
//- (void)testQuestionListViewIsGivenAnAvatarStore {
//    QuestionListTableDataSource *listDataSource = [[QuestionListTableDataSource alloc] init];
//    viewController.dataSource = listDataSource;
//    [viewController viewWillAppear: YES];
//    STAssertNotNil(listDataSource.avatarStore, @"The avatarStore property should be configured in -viewWillAppear:");
//}
//
//- (void)testQuestionDetailViewIsGivenAnAvatarStore {
//    QuestionDetailDataSource *detailDataSource = [[QuestionDetailDataSource alloc] init];
//    viewController.dataSource = detailDataSource;
//    [viewController viewWillAppear: YES];
//    STAssertNotNil(detailDataSource.avatarStore, @"The avatarStore property should be configured in -viewWillAppear:");
//}
//
//- (void)testTableReloadedWhenQuestionBodyReceived {
//    QuestionDetailDataSource *detailDataSource = [[QuestionDetailDataSource alloc] init];
//    viewController.dataSource = detailDataSource;
//    ReloadDataWatcher *watcher = [[ReloadDataWatcher alloc] init];
//    viewController.tableView = (UITableView *)watcher;
//    [viewController bodyReceivedForQuestion: nil];
//    STAssertTrue([watcher didReceiveReloadData], @"Table reloaded when question body received");
//}

@end

