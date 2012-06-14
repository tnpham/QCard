//
//  SettingViewController.h
//  Qcard
//
//  Created by Theodore Pham on 12-03-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Internet connectivity
#import "Reachability.h"

@interface SettingViewController : UIViewController{
    
    IBOutlet UIImageView * imageView;
    
}

@property (assign, nonatomic) IBOutlet UILabel * blockLabel;
@property (assign, nonatomic) IBOutlet UILabel * notificationLabel;
@property (assign, nonatomic) IBOutlet UILabel * wifiLabel;

//@property (assign, nonatomic) IBOutlet UIImageView * image;

@end
