//
//  SetupViewController.h
//  Qcard
//
//  Created by Theodore Pham on 12-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    //Mutable array contents can be changed while NSArray contents cannot be changed without recreating it
	NSMutableArray *langarrayNo;
    NSMutableArray *setarrayNo;
    
    IBOutlet UILabel *langlabel; 
    IBOutlet UILabel *setlabel;
    
	IBOutlet UIPickerView *pickerView;
    
    IBOutlet UIButton *langButton;
    IBOutlet UIButton *setButton;
    
}

//- (IBAction) langButtonAction;

@property (nonatomic, retain) UILabel *langlabel;
@property (nonatomic, retain) UILabel *setlabel;

@property (nonatomic, strong) IBOutlet UIButton *langButton;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIButton *setButton;

@end
