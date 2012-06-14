//
//  AnswerViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnswerViewController.h"
#import "Singleton.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

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
    
    //Grabs the value at speicified index in array
    id str = [global.answerArray objectAtIndex: global.index];
    
    lblANSWER.text = [NSString stringWithFormat:@"%@", str];

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

@end
