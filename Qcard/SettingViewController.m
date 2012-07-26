//
//  SettingViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-03-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "Singleton.h"
//#import "CollapsableTableView.h"

@interface SettingViewController ()

@end

@implementation SettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    Singleton *global = [Singleton globalVar];

    NSArray *keys = [global.courseName allKeys];
    id key, value;
    
	for(NSString *key in keys){
        NSLog(@"%@ is %@", key, [global.courseName objectForKey:key]);
        NSLog(@"BreaK");
    }
    
    listOfItems = [[NSMutableArray alloc] init];

    for (int i=0; i < [global.courseName count]; i++){
        
        key = [keys objectAtIndex: i];
        value = [global.courseName objectForKey: key];
        
        //Allocates memory for array and then adds all the files
        NSMutableArray *courseFiles = [[NSMutableArray alloc] init ];
        for(int j=0; j < [value count]; j++){
            [courseFiles addObject:[value objectAtIndex:j]];
        }
        
//        NSMutableArray *countriesToLiveInArray = [NSMutableArray arrayWithObjects: @"TEST", nil];
        
        NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:courseFiles forKey:@"CourseFiles"];
        [listOfItems addObject:countriesToLiveInDict];
        
        NSLog(@"Key: %@ for values: %@", key, value);
        
        
        
    }
    
	//Initialize the array.
//	listOfItems = [[NSMutableArray alloc] init];
	
    /*
    for (int i=0; i < [global.courseName count]; i++){
        listOfItems = [[NSMutableArray alloc] init];

        for (int i=0; i < [global.files count]; i++){
            NSArray *countriesToLiveInArray = [NSArray arrayWithObjects: global.files,nil];
            
            if(i == [global.files count]){
                NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
                [listOfItems addObject:countriesToLiveInDict];

            }
        }
    }
     */
    
//	NSArray *countriesToLiveInArray = [NSArray arrayWithObjects:@"French", @"German", @"Russian", @"English", nil];
//	NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
//	
//	NSArray *countriesLivedInArray = [NSArray arrayWithObjects:@"Exercise 1", @"Exercise 2", nil];
//	NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Countries"];
//    
 
	
//	[listOfItems addObject:countriesToLiveInDict];
//	[listOfItems addObject:countriesLivedInDict];
	
	//Set the title
	self.navigationItem.title = @"CourseFiles";
    
    //NSLog(@"%@", [global.courseName objectAtIndex: 1]);
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Number of sections: %i", [listOfItems count]);
	return [listOfItems count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//Number of rows it should expect should be based on the section
	NSDictionary *dictionary = [listOfItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"CourseFiles"];
	return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Singleton *global = [Singleton globalVar];

    /*
	if(section == 0)
		return @"Moodle 101";
	else
		return @"French 301";
    */
    //NSLog(@"%@", global.courseName);
    NSArray *keys = [global.courseName allKeys];
//    NSLog(@"%@", keys);
    NSLog(@"Number of keys: %i", [keys count]);
    
//    for (NSString *key in keys){
//        NSLog(@"%@ is %@", key, [global.courseName objectForKey:key]);
//    }
    
    for(int i=0; i < [keys count]; i++){
        if (section == i){

            NSLog(@"Header %@", [keys objectAtIndex:i]);
            //return [global.courseName objectForKey:[[global.courseName allKeys] objectAtIndex:i]];
            return [keys objectAtIndex:i];

        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //Deprecated initWithFrame:CGRectZero
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
	
	//First get the dictionary object
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"CourseFiles"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
    
    //Deprecated
//	cell.text = cellValue;
    cell.textLabel.text = cellValue;
    
    //Image on the left of the cell
    cell.imageView.image = [UIImage imageNamed:@"blank.png"];
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Get the selected country
	
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"Countries"];
	NSString *selectedCountry = [array objectAtIndex:indexPath.row];
	
	//Initialize the detail view controller and display it.
	DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:[NSBundle mainBundle]];
	dvController.selectedCountry = selectedCountry;
	[self.navigationController pushViewController:dvController animated:YES];
	//[dvController release];
	dvController = nil;
}*/

//Deprecated, use one below
/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryDisclosureIndicator;
}*/

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Image on the right side of the cell, can be customized to represent downloaded and not downloaded yet***
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speaker.png"]];
}

/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}*/

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
- (void)dealloc {
	
	[listOfItems release];
    [super dealloc];
}
*/




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}









/*
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
 */

@end
