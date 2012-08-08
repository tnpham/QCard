//
//  AnswerViewController.h
//  Qcard
//
//  Created by Theodore Pham on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "audioControl.h"

@interface AnswerViewController : UIViewController{
    
    IBOutlet UIButton *playWord;

    IBOutlet UILabel *lblANSWER;
    
    audioControl *audio;
    char audioFilePath[256];
    AVAudioPlayer *audioPlayer;
    
}

- (IBAction) playSound;
- (IBAction) goBack;

@property (nonatomic, strong) IBOutlet UIButton *playWord;

@end
