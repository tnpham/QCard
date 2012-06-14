//
//  AppDelegate.h
//  Qcard
//
//  Created by Theodore Pham on 12-03-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
//  AppDelegate.h
//  OpenEarsSampleApp
//
//  Created by Halle Winkler on 3/7/12.
//  Copyright (c) 2012 Politepix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>

@class ViewController;
@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    UIWindow *window;
    ViewController *viewController;
    
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

//Coverflow variables
@property (nonatomic, retain) RootViewController *root;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

