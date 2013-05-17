//
//  BrowseOverflow - BrowseOverflowViewControllerTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "BrowseOverflowViewController.h"

    // Collaborators
#import "TopicTableProvider.h"
#import <objc/runtime.h>
#import "Topic.h"
#import "QuestionTableProvider.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


static const char *notificationKey = "BrowseOverflowViewControllerTestsAssociatedNotificationKey";

@implementation BrowseOverflowViewController (TestNotificationDelivery)

- (void)browseOverflowControllerTests_didSelectTopic:(NSNotification *)note {
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

@end


@interface BrowseOverflowViewControllerTest : SenTestCase
@property (nonatomic, strong) BrowseOverflowViewController *sut;

@property (nonatomic, strong) UINavigationController *navController;
@end

@implementation BrowseOverflowViewControllerTest
{
    SEL realUserDidSelectTopic, testUserDidSelectTopic;
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

    objc_removeAssociatedObjects(_sut);
    
    realUserDidSelectTopic = @selector(didSelectTopic:);
    testUserDidSelectTopic = @selector(browseOverflowControllerTests_didSelectTopic:);
}

- (void)tearDown
{
    objc_removeAssociatedObjects(_sut);
    _sut = nil;
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


@end

