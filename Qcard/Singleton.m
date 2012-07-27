//
//  Singleton.m
//  Qcard
//
//  Created by Theodore Pham on 12-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"

@interface Singleton ()

@end

static Singleton *globalVar= nil;

@implementation Singleton

@synthesize answerArray;
@synthesize index;
//@synthesize wrongAnswer;

@synthesize courseName;
@synthesize files;

//@synthesize EF_prime;
//@synthesize EF;
@synthesize troubledWords;
@synthesize initialWords;
@synthesize easyWords;
@synthesize skippedWords;

#pragma mark -
#pragma mark Singleton Methods
+ (Singleton *)globalVar {
    if(globalVar == nil){
        globalVar = [[super allocWithZone:NULL] init];
    }
    return globalVar;
}


/*
+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return NSUIntegerMax;
}
- (void)release {
    //do nothing
}
- (id)autorelease {
    return self;
}*/

@end
