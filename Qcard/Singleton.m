//
//  Singleton.m
//  Qcard
//
//  Created by Theodore Pham on 12-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//This is a class that can ONLY have one instance throughout the program

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
@synthesize troubledAnswers;
@synthesize initialAnswers;
@synthesize skippedAnswers;

@synthesize elements;
@synthesize array_index;

@synthesize initial_round;
@synthesize skipped_round;
@synthesize incorrect_round;

@synthesize serverName;

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
