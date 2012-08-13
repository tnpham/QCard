//
//  AuthenticateViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-05-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthenticateViewController.h"
#import "Singleton.h"
#import "MBProgressHUD.h"

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@interface AuthenticateViewController ()

@end

@implementation AuthenticateViewController

@synthesize username;
@synthesize password;
@synthesize servername;
@synthesize authenticate;
@synthesize recoverpass;
@synthesize checkBox;
@synthesize isChecked;
//@synthesize loader;
//@synthesize webData;

/******************************************/

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
    
    //Hides keyboard when user hits 'done'
    username.returnKeyType = UIReturnKeyDone;
    password.returnKeyType = UIReturnKeyDone;
    servername.returnKeyType = UIReturnKeyDone;
    
    username.delegate = self;
    password.delegate = self;
    servername.delegate = self;
    
    Reachability * wifi = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus remoteHostStatus = [wifi currentReachabilityStatus];
    
    if (remoteHostStatus == ReachableViaWiFi) {
        NSLog(@"wifi");
    } else {
        NSLog(@"No wifi detected, please connect to view");

        [self message:@"Wifi undetected. Please connect to log in."];

    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *usernameField = [defaults objectForKey:@"username"];
    NSString *passwordField = [defaults objectForKey:@"password"];
    NSString *servernameField = [defaults objectForKey:@"server"];
    
    // Update the UI elements with the saved data
    username.text = usernameField;
    password.text = passwordField;
    servername.text = servernameField;
    
    //[checkBox setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
    //0 means not checked
    isChecked = 0;
    
    //NSUserDefaults *defaultData = [NSUserDefaults standardUserDefaults];
    
    
}
    
//www.roseindia.net/answers/viewqa/Mobile-Applications/14965-uikeyboard-done-button/return-button.html
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [username resignFirstResponder];
    [password resignFirstResponder];
    [servername resignFirstResponder];
    
    return YES;
}


- (IBAction) checkBox: (id) sender{
    if (isChecked == 1){
        
        [checkBox setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
        [checkBox setSelected: NO];
        isChecked = 0;
        NSLog(@"Not Checked");

    } else {
        
        [checkBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        [checkBox setSelected : YES];
        isChecked = 1;
        NSLog(@"Checked");

        
        /*
        NSString *usernameField = [username  text];
        NSString *passwordField = [password text];
        NSString *serverField = [servername text];
        
        NSUserDefaults *defaultData = [NSUserDefaults standardUserDefaults];
        
        [defaultData setObject:usernameField forKey:@"username"];
        [defaultData setObject:passwordField forKey:@"password"];
        [defaultData setObject:serverField forKey:@"server"];
        
        [defaultData synchronize];
         */
    }
}



//Checks if the username and password is valid
- (IBAction) authenticate:(id)sender
{
    Singleton *global = [Singleton globalVar];

    NSString *rval;
        
    //Finding memory disk space$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$//
    /*
    NSDictionary *fsAttr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float diskSize = [[fsAttr objectForKey:NSFileSystemSize] doubleValue] / 1000000000;
                      NSLog(@"Disk Size: %0.0f", diskSize);
    
    float freeSize = [[fsAttr objectForKey:NSFileSystemFreeSize] doubleValue] / 1000000000;
    NSLog(@"Free Disk Size: %0.0f", freeSize);
    
    float totalSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        NSLog(@"%0.0f", totalSpace);
    }*/
    //Finding memory disk space$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$//
    

    
        
    //If valid, go to next page
    //if ([username.text isEqualToString: @"%@"] && [password.text isEqualToString: @"%@"]){
    //Checks if the username and password is empty
    if (([username.text length] > 0) && ([password.text length] > 0) && ([servername.text length] > 0)){

            //loader.hidden = FALSE;
            //[loader startAnimating];
            authenticate.enabled = FALSE;
            
            //www.cocoanetics.com/2009/11/ignoring-certificate-errors-on-nsurlrequest
            //passes the username and password to the server php pages to check valid user
            //NSString *url = [NSString stringWithFormat:@"https://129.128.136.143/moodle/local/phpFile.php?user=%@&pass=%@", username.text, password.text];  // server name does not match
            
            NSString *url = [NSString stringWithFormat:@"https://%@/moodle/mod/qcardloader/infoControl.php?user=%@&pass=%@&request=app", servername.text, username.text, password.text];  // server name does not match
            
            //NSString *url = [NSString stringWithFormat:@"https://%@/moodle/local/qcardloader/phpFile.php?user=%@&pass=%@", servername.text, username.text, password.text];  // server name does not match


            NSURL *URL = [NSURL URLWithString:url];
            NSString *course;
            
            NSLog(@"%@", url);
            
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            NSURLResponse *response;
            NSError *error = nil;
            [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[URL host]];
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response error:&error];
        
            //Authenticate loader
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Authenticating...";
        
             NSArray *file;
            //Have a setting where you can trust the certificate or not.
            //popup of confirmation to bypass certificate
            if (error)
            {
                NSLog(@"%@", [error localizedDescription]);
                NSLog(@"Could not connect to server");
                [self message:@"COuld not connect to server"];

                
                //Hide Loader
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } else {
                //Grabs the return value
                rval = [[NSString alloc]initWithData: data encoding:NSUTF8StringEncoding];
                NSLog(@"RVAL: %@",rval);
                
                    NSLog(@"%@",rval);
                    
                    //Grabs all the available files
                    file = [rval componentsSeparatedByString:@"\n"];
                    
                    NSLog(@"%i", [file count]);
                
                if ([[file objectAtIndex:0] isEqualToString: @"empty"]){
                    //Hide Loader
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
  
                    [self message:@"No files found"];

                    //checks if check box is checked
                    [self checked];
                    
                } else if ([[file objectAtIndex:0] isEqualToString: @"DNE"]){
                    //Hide Loader
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    [self message:@"Username does not exist"];
               
                    
                    //checks if check box is checked
                    [self checked];
                    
                } else if([[file objectAtIndex:0] isEqualToString: @"true"]){
                    //Initializes the array
                    if (global.courseName == nil)
                    {
                        global.courseName = [[NSMutableDictionary alloc] init];
                        
                    }
                    if (global.files == nil)
                    {
                        global.files = [[NSMutableArray alloc] init]; 
                        NSLog(@"Allocated");
                    }
                    
                    //Stores the files with their respective courses

                    int i=1;
                    
                    while (i<[file count]){
                        if ([[file objectAtIndex:i] isEqualToString: @"course:"]){
                            NSLog(@"Coursetest");
                            //Increments to get the course name
                            i++;
                            //Temp holder for course
                            course = [file objectAtIndex:i];
                            NSLog(@"&&&---%@---&&&", course);
                            //Creates a new array to store all the file names
                            global.files = [[NSMutableArray alloc] init]; 

                        }
                        
                        if ([[file objectAtIndex:i] isEqualToString: @"file:"]){
                            //Increments to retrieve the file name
                            i++;
                            NSLog(@"File: %@", [file objectAtIndex:i]);
                            //Add file names to array
                            [global.files addObject:[file objectAtIndex:i]];
                            NSLog(@"Added %@", [file objectAtIndex:i]);
                            
                        }
                        
                        //Stores the courses and their respective files
                        [global.courseName setObject:global.files forKey:course];

                        i++;
                    }
                } else if ([[file objectAtIndex:0] isEqualToString: @"false"]){
                    //Hide Loader
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [self message:@"Invalid username or password"];

                    //checks if check box is checked
                    [self checked];
                    
                }
                
                NSLog(@"File Ended");
                NSLog(@"%i", [global.courseName count]);

                NSLog(@"Contents of Dictionary: %@", global.courseName);
                
        }
        
    //Displays error message when either username or password is invalid
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self message:@"Invalid username or password"];

        
    }
}

//Saves user default values if the checkbox is checked
- (void) checked{
    if (isChecked == 1){
        
        NSLog(@"YAY");
        NSString *usernameField = [username  text];
        NSString *passwordField = [password text];
        NSString *serverField = [servername text];
        
        NSUserDefaults *defaultData = [NSUserDefaults standardUserDefaults];
        
        [defaultData setObject:usernameField forKey:@"username"];
        [defaultData setObject:passwordField forKey:@"password"];
        [defaultData setObject:serverField forKey:@"server"];
        
        //Saves the state of the NSUserDefault values
        [defaultData synchronize];
    }
}

//Displays a message according to the outcome
- (void) message: (NSString *) msg{
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",msg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert1 show];
    
    UILabel *theBody = [alert1 valueForKey:@"_bodyTextLabel"];
    [theBody setTextColor:[UIColor orangeColor]];
    
    UIImage *theImage = [UIImage imageNamed:@"blank.png"];
    theImage = [theImage stretchableImageWithLeftCapWidth:16 topCapHeight:16];
    CGSize theSize = [alert1 frame].size;
    
//    UIGraphicsBeginImageContext(theSize);
//    [theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
//    theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
   // [[alert1 layer] setContents:[theImage CGImage]];
    
    //Add image to the alert background
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:theImage];
    backgroundImageView.frame = CGRectMake(0, 0, 282, 100);
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    
    [alert1 addSubview:backgroundImageView];
    [alert1 sendSubviewToBack:backgroundImageView];
    [alert1 show];

}


//http://www.iphonedevsdk.com/forum/iphone-sdk-development/2982-2-button-uialertview-button-pressed.html
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"button0");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"button1");
    } 
    else if(buttonIndex == 2)
    {
        NSLog(@"button2");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSArray *trustedHosts = [NSArray arrayWithObjects:@"mytrustedhost",nil];
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if ([trustedHosts containsObject:challenge.protectionSpace.host]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


/*
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"DONE.........");
    [webData appendData:data];
    [self.webData appendData:data]; 

}*/


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"Notification Says Reachable");
    }
    else
    {
        NSLog(@"Notification Says Unreachable");
    }
}


//Links to specified webpage in safari to recover password and username
- (IBAction) recoverpass:(id)sender
{
     //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://password.srv.ualberta.ca"]];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://patrickt.csj.ualberta.ca/moodle/login/index.php"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //Use to autorotate when user rotates phone
    //return true;
}

@end
