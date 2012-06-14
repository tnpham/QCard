//
//  SettingViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-03-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize blockLabel, notificationLabel, wifiLabel;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // BACKGROUND IMAGE
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];

    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.moodle.org"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            blockLabel.text = @"Block Says Reachable";

        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [reach startNotifier];
    
    Reachability * wifi = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus remoteHostStatus = [wifi currentReachabilityStatus];
    
    //Checks for wifi or 3g connections
    if(remoteHostStatus == NotReachable) {
        NSLog(@"no"); wifiLabel.text = @"Wifi: DISCONNECTED!";
   
        //Sets image for no wifi
        UIImage *img = [UIImage imageNamed:@"oohoo1.png"];
        [imageView setImage:img];
        
    } else if (remoteHostStatus == ReachableViaWiFi) {
        NSLog(@"wifi"); wifiLabel.text = @"Wifi: CONNECTED!";
        
        //Sets image for wifi
        UIImage *img = [UIImage imageNamed:@"oohoo.png"];
        [imageView setImage:img];
        
    } else if (remoteHostStatus == ReachableViaWWAN) {
        NSLog(@"cell"); wifiLabel.text = @"No 3G"; 
    }
   
    [wifi startNotifier];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        notificationLabel.text = @"Notification Says Reachable";
    }
    else
    {
        notificationLabel.text = @"Notification Says Unreachable";
    }
}

@end
