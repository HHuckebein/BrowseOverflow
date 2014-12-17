//
//  BrowseOverflow - BrowseOverflowAppDelegateTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "AppDelegate.h"

    // Collaborators
#import "BrowseOverflowViewController.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface BrowseOverflowAppDelegateTest : SenTestCase
@property (nonatomic, strong) AppDelegate *sut;

@property (nonatomic, assign) BOOL didFinishLaunchingWithOptionReturnValue;

@end

@implementation BrowseOverflowAppDelegateTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    self.sut = [[AppDelegate alloc] init];
    
    _didFinishLaunchingWithOptionReturnValue = [self.sut application:nil didFinishLaunchingWithOptions:nil];
}

- (void)tearDown
{
    _sut = nil;
    
    [super tearDown];
}

- (void)testAppDidFinishLaunchingReturnsYES
{
    assertThatBool(_didFinishLaunchingWithOptionReturnValue, is(equalToBool(TRUE)));
}

@end
