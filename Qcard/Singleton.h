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
    //Initial words
    NSMutableArray *initWords;
    //Have no trouble with
    NSMutableArray *easyWords;
    //Skipped words
    NSMutableArray *skippedWords;
    
    //AnswerView
    NSMutableArray *answerArray;
    int index;
    NSMutableArray *wrongAnswers;
    
    //AuthenticateView
    //Hash Table
    NSMutableDictionary *courseName;
    NSMutableArray *files;
    
}

//SuperMemo 
//@property (nonatomic, retain) NSDecimalNumber *EF_prime;
//@property (nonatomic, retain) NSDecimalNumber *EF;
@property (nonatomic, retain) NSMutableArray *troubledWords;
@property (nonatomic, retain) NSMutableArray *initWords;
@property (nonatomic, retain) NSMutableArray *easyWords;
@property (nonatomic, retain) NSMutableArray *skippedWords;


//AnswerView
@property (nonatomic, retain) NSMutableArray *answerArray;
@property (nonatomic) int index;
@property (nonatomic, retain) NSMutableArray *wrongAnswer;

//AuthenticateView
@property (nonatomic, retain) NSMutableDictionary *courseName;
@property (nonatomic, retain) NSMutableArray *files;



//Global var
+ (Singleton *) globalVar;

@end
