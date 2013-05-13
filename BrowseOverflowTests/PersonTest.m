//
//  BrowseOverflow - PersonTest.m
//  Copyright 2013 RABE_IT Services. All rights reserved.
//
//  Created by: Bernd Rabe
//

    // Class under test
#import "Person.h"

    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface PersonTest : SenTestCase
@property (nonatomic, strong) Person *person;
@end

@implementation PersonTest
{
    // test fixture ivars go here
}

- (void)setUp
{
    [super setUp];
    _person = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
}

- (void)tearDown
{
    _person = nil;
    [super tearDown];
}

- (void)testThatPersonHasName
{
    assertThat(self.person.name, equalTo(@"Graham Lee"));
}

- (void)testThatPersonsHasAvatarURL
{
    assertThat([self.person.avatarURL absoluteString], equalTo(@"http://example.com/avatar.png"));
}

- (void)testThatOwnerDictionaryContainsDisplayNameKey
{
    // given
    NSDictionary *dictionary = @{@"email_hash" : @""};
    
    // then
    STAssertThrows([Person personFromOwnerDictionary:dictionary], @"Owner dictionary must contain display_name key");
}

- (void)testThatOwnerDictionaryContainsEmailHashKey
{
    // given
    NSDictionary *dictionary = @{@"display_name" : @""};
    
    // then
    STAssertThrows([Person personFromOwnerDictionary:dictionary], @"Owner dictionary must contain email_hash key");
}

- (void)testThatWellFormedOwnerDictionaryLeadToProperPersonCreation
{
    // given
    NSDictionary *dictionary = @{@"display_name" : @"Graham Lee", @"email_hash" : @"563290c0c1b776a315b36e863b388a0c"};
    
    // when
    Person *person = [Person personFromOwnerDictionary:dictionary];
    
    // then
    assertThat(person.name, is(equalTo(@"Graham Lee")));
    assertThat([person.avatarURL absoluteString], is(equalTo(@"http://www.gravatar.com/avatar/563290c0c1b776a315b36e863b388a0c")));
}
                                       
@end
