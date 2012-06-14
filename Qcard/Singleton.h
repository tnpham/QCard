//
//  Singleton.h
//  Qcard
//
//  Created by Theodore Pham on 12-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//http://derekneely.com/2009/11/iphone-development-global-variables/

#import <UIKit/UIKit.h>

@interface Singleton : UIViewController{
    NSMutableArray *answerArray;
    int index;
}
@property (nonatomic, retain) NSMutableArray *answerArray;
@property (nonatomic) int index;


+ (Singleton *) globalVar;


@end
