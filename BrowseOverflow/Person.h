//
//  Person.h
//  BrowseOverflow
//
//  Created by Bernd Rabe on 29.04.13.
//  Copyright (c) 2013 RABE_IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic, copy) NSString     *name;
@property(nonatomic, strong) NSURL      *avatarURL;

- (id)initWithName:(NSString *)name avatarLocation:(NSString *)location;
+ (Person *)personWithName:(NSString *)name avatarURL:(NSString *)avatarURL;
+ (Person *)personFromOwnerDictionary:(NSDictionary *)ownerDictionary;

- (NSString *)description;
@end
