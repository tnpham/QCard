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
    
    //AnswerView
    NSMutableArray *answerArray;
    int index;
    NSMutableArray *wrongAnswers;
    
    //AuthenticateView
    //Hash Table
    NSMutableDictionary *courseName;
    NSMutableArray *files;
    
}

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
