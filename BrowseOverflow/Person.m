//
//  Person.m
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithName:(NSString *)name avatarLocation:(NSString *)location
{
    self = [super init];
    if (self) {
        self.name = name;
        self.avatarURL = [NSURL URLWithString:location];
    }
    return self;
}

+ (Person *)personWithName:(NSString *)name avatarURL:(NSString *)avatarURL
{
    return [[Person alloc] initWithName:name avatarLocation:avatarURL];
}

+ (Person *)personFromOwnerDictionary:(NSDictionary *)ownerDictionary
{
    NSArray *allKeys = [ownerDictionary allKeys];
    NSAssert([allKeys containsObject:@"display_name"], @"Dictionary must contain display_name key");
    NSAssert([allKeys containsObject:@"email_hash"], @"Dictionary must contain email_hash key");

    NSString *name = ownerDictionary[@"display_name"];
    NSString *avatarURL = [NSString stringWithFormat: @"http://www.gravatar.com/avatar/%@", ownerDictionary[@"email_hash"]];

    return [[Person alloc] initWithName:name avatarLocation:avatarURL];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name %@, avatarURL %@", self.name, self.avatarURL];
}

@end
