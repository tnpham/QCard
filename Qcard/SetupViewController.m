//
//  SetupViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetupViewController.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

@synthesize langlabel;
@synthesize setlabel;
@synthesize langButton;
@synthesize pickerView;
@synthesize setButton;


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
    
    //Initialize array for language and number if cards
    //Loads the available language packs
    langarrayNo = [[NSMutableArray alloc] init];
	[langarrayNo addObject:@" FR "];
	[langarrayNo addObject:@" EN "];
	[langarrayNo addObject:@" GR "];
	[langarrayNo addObject:@" RU "];
	[langarrayNo addObject:@" AU "];
    
    
    setarrayNo = [[NSMutableArray alloc] init];
	[setarrayNo addObject:@" 15 "];
	[setarrayNo addObject:@" 30 "];
	[setarrayNo addObject:@" 45 "];
	[setarrayNo addObject:@" 60 "];
	[setarrayNo addObject:@" 100 "];
	
	//[pickerView selectRow:1 inComponent:0 animated:NO];
    //setlabel.text= [setarrayNo objectAtIndex:[pickerView selectedRowInComponent:0]];	
}

/*
- (IBAction) langButtonAction { // This is the action for the button which shuts down the recognition loop.
    
    self.pickerView.hidden = FALSE;
}*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Picker View
//Implementing delegate when user make selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0){
        langlabel.text=[langarrayNo objectAtIndex:row];
    }else {
        setlabel.text=	[setarrayNo objectAtIndex:row];
    }
}

//Datasource protocol
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 2;
}
//Returns number of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component == 0)
        return [langarrayNo count];
    
	return [setarrayNo count];
}
//Returns language or #cards for desired component and row using row and component references
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (component == 0)
        return [langarrayNo objectAtIndex:row];
	return [setarrayNo objectAtIndex:row];
}
 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



@end
