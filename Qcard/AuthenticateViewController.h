//
//  AuthenticateViewController.h
//  Qcard
//
//  Created by Theodore Pham on 12-05-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Internet connectivity
#import "Reachability.h"

@interface AuthenticateViewController : UIViewController <UITextFieldDelegate> {
    
    //www.edumobile.org/iphone/iphone-programming-tutorials/create-a-loginscreen-in-iphone/
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *servername;
    IBOutlet UIButton *authenticate;
    IBOutlet UIButton *recoverpass;
    
    IBOutlet UIButton *checkBox;
    BOOL isChecked;
    //IBOutlet UIActivityIndicatorView *loader;
    //NSMutableData *webData;

}

@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UITextField *servername;
@property (nonatomic, retain) UIButton *authenticate;
@property (nonatomic, retain) UIButton *recoverpass;
@property (nonatomic, retain) UIButton *checkBox;

@property (nonatomic, assign) BOOL isChecked;
//@property (nonatomic, retain) UIActivityIndicatorView *loader;

//@property(nonatomic, retain) NSMutableData *webData;

- (IBAction) authenticate: (id) sender;
- (IBAction) recoverpass: (id) sender;
- (IBAction) checkBox: (id) sender;

@end
