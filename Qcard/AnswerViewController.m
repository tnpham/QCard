//
//  AnswerViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnswerViewController.h"
#import "Singleton.h"
#import <AVFoundation/AVFoundation.h>

@interface AnswerViewController ()

@end

@implementation AnswerViewController

@synthesize playWord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //Background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"try1.png"]];
    [super viewDidLoad];
    
    //Global variable
    Singleton *global = [Singleton globalVar];
    // Do any additional setup after loading the view from its nib.
    
    id str;
    NSLog(@"GLBOALLLLLLL INDEX %d", global.index);
    
    if(global.initial_round != TRUE){
        //Grabs the value at specified index in array
        str = [global.initialAnswers objectAtIndex: global.index];
        
    } else {
        str = [global.skippedAnswers objectAtIndex: global.index];
    }
    
    lblANSWER.text = [NSString stringWithFormat:@"%@", str];

    ////////////////////////////////////////////////////////
    
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"goodbye" ofType:@"mp3"]];
    
//    NSString *url = [[NSBundle mainBundle] pathForResource:[[global.answerArray objectAtIndex: global.index] lowercaseString] ofType:@"mp3"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:[[global.answerArray objectAtIndex: global.index] lowercaseString] ofType:@"mp3"];

    //BROKEN
//    NSString *path = [[NSBundle mainBundle] pathForResource:[[global.answerArray objectAtIndex: global.index] lowercaseString] ofType:@"mp3"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//
//    
//    NSError *error;
//    audioPlayer = [[AVAudioPlayer alloc]
//                   initWithContentsOfURL:url
//                   error:&error];
//    if (error)
//    {
//        NSLog(@"Error in audioPlayer: %@", 
//              [error localizedDescription]);
//    } else {
//        audioPlayer.delegate = self;
//        [audioPlayer prepareToPlay];
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)goBack{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) playSound{
//    Singleton *global = [Singleton globalVar];
    //Plays audio for correct answer
    //Reference:GeekyLemon -> http://www.youtube.com/watch?v=QuwTvg7Mi24
//    NSString *path = [[NSBundle mainBundle] pathForResource:[[global.answerArray objectAtIndex: global.index] lowercaseString] ofType:@"mp3"];
//    NSLog(@"%@", [[global.answerArray objectAtIndex: global.index] lowercaseString]);
//    NSLog(@"Method Called");
//
//    NSError *error = nil;    
//    AVAudioPlayer* theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
//    if(theAudio){
//        [theAudio play];
//        NSLog(@"Playing Audio");
//
//    }

    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"hello" ofType:@"mp3"];
//    AVAudioPlayer* theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
//    [theAudio play];
    [audioPlayer play];
}

@end
