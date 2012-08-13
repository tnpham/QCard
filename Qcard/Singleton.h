//
//  Singleton.h
//  Qcard
//
//  Created by Theodore Pham on 12-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//Contains all the shared global variables of each view

//http://derekneely.com/2009/11/iphone-development-global-variables/

#import <UIKit/UIKit.h>

@interface Singleton : UIViewController{
    
    //SuperMemo algorithm
    
    //old easiness factor
//    NSDecimalNumber *EF_prime;
    double EF_prime;
    
    //new easiness factor
//    NSDecimalNumber *EF;
    double EF;
    
    //Words needing reviewing
    NSMutableArray *troubledWords;
    NSMutableArray *troubledAnswers;
    //Initial words
    NSMutableArray *initialWords;
    NSMutableArray *initialAnswers;
    //Have no trouble with
    NSMutableArray *easyWords;
    //Skipped words
    NSMutableArray *skippedWords;
    NSMutableArray *skippedAnswers;
    
    //AnswerView
    NSMutableArray *answerArray;
    int index;
//    NSMutableArray *wrongAnswers;
    
    //AuthenticateView
    //Hash Table
    NSMutableDictionary *courseName;
    NSMutableArray *files;
    
    //Total number of elements (words)
    NSUInteger elements;
    //Current array index
    NSUInteger array_index;
    
    BOOL initial_round;
    BOOL skipped_round;
    BOOL incorrect_round;
    
    NSString *serverName;
    
}

//SuperMemo 
//@property (nonatomic, retain) NSDecimalNumber *EF_prime;
//@property (nonatomic, retain) NSDecimalNumber *EF;
@property (nonatomic, retain) NSMutableArray *troubledWords;
@property (nonatomic, retain) NSMutableArray *initialWords;
@property (nonatomic, retain) NSMutableArray *easyWords;
@property (nonatomic, retain) NSMutableArray *skippedWords;
@property (nonatomic, retain) NSMutableArray *troubledAnswers;
@property (nonatomic, retain) NSMutableArray *initialAnswers;
@property (nonatomic, retain) NSMutableArray *skippedAnswers;



//AnswerView
@property (nonatomic, retain) NSMutableArray *answerArray;
@property (nonatomic) int index;
//@property (nonatomic, retain) NSMutableArray *wrongAnswer;

//AuthenticateView
@property (nonatomic, retain) NSMutableDictionary *courseName;
@property (nonatomic, retain) NSMutableArray *files;

@property (nonatomic) NSUInteger elements;
@property (nonatomic) NSUInteger array_index;

@property (nonatomic, assign) BOOL initial_round;
@property (nonatomic, assign) BOOL skipped_round;
@property (nonatomic, assign) BOOL incorrect_round;

@property (nonatomic, copy) NSString *serverName;

//Global var
+ (Singleton *) globalVar;

@end
