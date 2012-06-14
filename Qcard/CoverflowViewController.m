//
//  CoverflowViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-04-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
//  CoverflowViewController.m
//  Created by Devin Ross on 1/3/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */
#import "CoverflowViewController.h"

@implementation CoverflowViewController
@synthesize coverflow,covers;

/*
 - (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
 return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
 return YES;
 }*/
- (void) didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void) viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
/*
- (void) dealloc {
	[coverflow release];
	[covers release];
    [super dealloc];
}*/

- (void) loadView{
	
	CGRect r = [UIScreen mainScreen].bounds;
	r = CGRectApplyAffineTransform(r, CGAffineTransformMakeRotation(90 * M_PI / 180.));
	r.origin = CGPointZero;
	
	//self.view = [[[UIView alloc] initWithFrame:r] autorelease];
    self.view = [[UIView alloc] initWithFrame:r];
	
	
	
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	
	r = self.view.bounds;
	r.size.height = 1000;
	
	coverflow = [[TKCoverflowView alloc] initWithFrame:self.view.bounds];
	coverflow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	coverflow.coverflowDelegate = self;
	coverflow.dataSource = self;
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
		coverflow.coverSpacing = 100;
		coverflow.coverSize = CGSizeMake(300, 300);
	}
	
	[self.view addSubview:coverflow];
	
	
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btn.frame = CGRectMake(0,0,100,20);
		[btn setTitle:@"# Covers" forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(changeNumberOfCovers) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn];
	}else{
		
		UIBarButtonItem *nocoversitem = [[UIBarButtonItem alloc] initWithTitle:@"# Covers" 
                                                                         style:UIBarButtonItemStyleBordered 
                                                                        target:self action:@selector(changeNumberOfCovers)];
		
		UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
		self.toolbarItems = [NSArray arrayWithObjects:flex,nocoversitem,nil];
		//[nocoversitem release];
		//[flex release];
	}
    
	CGSize s = self.view.bounds.size;
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
	infoButton.frame = CGRectMake(s.width-50, 5, 50, 30);
	[self.view addSubview:infoButton];
    
	
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //NSNumber *num = [NSNumber numberWithFloat:10.0f];
    //NSString *str = @"HELLO";
	
    //Must use images for this to work
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
		covers = [[NSMutableArray alloc] initWithObjects:
				  [UIImage imageNamed:@"oohoo.png"],[UIImage imageNamed:@"oohoo.png"],
				  [UIImage imageNamed:@"oohoo.png"],[UIImage imageNamed:@"oohoo.png"],
				  [UIImage imageNamed:@"oohoo.png"],[UIImage imageNamed:@"oohoo.png"],
				  [UIImage imageNamed:@"oohoo.png"],[UIImage imageNamed:@"oohoo.png"],
				  [UIImage imageNamed:@"oohoo.png"],
                  nil];
        
            
        printf("IPHONE!");
	}else{
		covers = [[NSMutableArray alloc] initWithObjects:
                  [UIImage imageNamed:@"oohoo.png"],[UIImage imageNamed:@"oohoo.png"],
				  [UIImage imageNamed:@"oohoo.png"],[UIImage imageNamed:@"oohoo.png"],
				  [UIImage imageNamed:@"oohoo.png"],[UIImage imageNamed:@"oohoo.png"],
				  [UIImage imageNamed:@"oohoo.png"],[UIImage imageNamed:@"oohoo.png"],
				  [UIImage imageNamed:@"oohoo.png"],
                  nil];
        printf("IPAD!!");
	}
    
	[coverflow setNumberOfCovers:20];
	
}
- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque]; 
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[coverflow bringCoverAtIndexToFront:[covers count]*2 animated:NO];
}
- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void) info{
	
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
		[self dismissModalViewControllerAnimated:YES];
	else{
		
		CGRect rect = self.view.bounds;
        
		
		if(!collapsed)
			rect = CGRectInset(rect, 100, 100);
		self.coverflow.frame = rect;
		
		collapsed = !collapsed;
        
	}
}
- (void) changeNumberOfCovers{
	
	NSInteger index = coverflow.currentIndex;
	NSInteger no = arc4random() % 200;
	NSInteger newIndex = MAX(0,MIN(index,no-1));
	
	//NSLog(@"Covers Count: %d index: %d",no,newIndex);
    
	[coverflow setNumberOfCovers:no];
	coverflow.currentIndex = newIndex;
	
}

//Front side of image
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index{
	NSLog(@"Front %d",index);
}
- (TKCoverflowCoverView*) coverflowView:(TKCoverflowView*)coverflowView coverAtIndex:(int)index{
	
	TKCoverflowCoverView *cover = [coverflowView dequeueReusableCoverView];
	
	
	
	if(cover == nil){
		BOOL phone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
		CGRect rect = phone ? CGRectMake(0, 0, 224, 300) : CGRectMake(0, 0, 300, 600);
        
		
		//cover = [[[TKCoverflowCoverView alloc] initWithFrame:rect] autorelease]; // 224
        	cover = [[TKCoverflowCoverView alloc] initWithFrame:rect];
		cover.baseline = 224;
		
	}
	cover.image = [covers objectAtIndex:index%[covers count]];
    
	return cover;
	
}

//Back side of image
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasDoubleTapped:(int)index{
	
	
	TKCoverflowCoverView *cover = [coverflowView coverAtIndex:index];
	if(cover == nil) return;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
    
    //Other animations:
    //FlipFromRight; CurlUp; CurlDown;
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cover cache:YES];
	[UIView commitAnimations];
	
	NSLog(@"Index: %d",index);
	
    
	
}

@end
