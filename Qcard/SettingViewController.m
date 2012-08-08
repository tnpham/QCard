//
//  SettingViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-03-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "Singleton.h"
#import "sqlite3.h"
//#import "CollapsableTableView.h"

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

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

	//Set the title
	self.navigationItem.title = @"CourseFiles";
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

    NSArray *keys = [global.courseName allKeys];
//    NSLog(@"%@", keys);
    NSLog(@"Number of keys: %i", [keys count]);

    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *rval;
    
    //Grab row number
    int row = indexPath.row;
    NSLog(@"cell ROW: %d", row);
    
    //Grab name of cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell text: %@", cell.textLabel.text); 
    
    NSString *url_file = [NSString stringWithFormat:@"https://129.128.136.68/moodle/mod/qcardloader/infoControl.php?filename=%@", cell.textLabel.text];

    NSURL *URL_file = [NSURL URLWithString:url_file];
    
    NSLog(@"%@", url_file);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL_file];
    NSURLResponse *response;
    NSError *error = nil;
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[URL_file host]];
    NSData *file_content = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    
    if(file_content){
        NSLog(@"FILE RETRIEVED!");
//        NSLog(@"%@", file_content);
        
        if(error){
            
        } else {
            //Contians the return value(file content) 
            rval = [[NSString alloc] initWithData: file_content encoding:NSUTF8StringEncoding];
            NSLog(@"%@", rval);
            
            //Checkmarks if user downloaded the file
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            //Method 2
            // Database variables
            NSString *databaseName;
            NSString *databasePath;
            // Setup some globals
            databaseName = @"test.db";
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            //Gives date and time and time zone
            NSDate *today = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat: @"EEEE MMMM d, YYYY h:mm a, zzz"];
            
            // Get the path to the documents directory and append the databaseName
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDir = [documentPaths objectAtIndex:0];
            databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
            NSLog(@"DatabasePath: %@", databasePath);
            
            //Checks if file exists at this path
            BOOL exist = [fileManager fileExistsAtPath: databasePath];
            
            if(!exist){
                NSLog(@"DATABASE NOT WRITABLE");
                NSString *bundle_path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"db"];
                //Copy path
                exist = [fileManager copyItemAtPath:bundle_path toPath:databasePath error:&error];
                if (!exist){
                    NSLog(@"FAILED!");
                } else {
                    NSLog(@"SUCCESSFULLY COPIED");
                }
            } else {
                NSLog(@"DATABASE WRITABLE");
            }
            
            
            //Method 1
            sqlite3 *database;
            //Open the database
            int result = sqlite3_open([databasePath UTF8String], &database);
            NSLog(@"DB Result: %d", result);
            
            //Database failed to open or DNE
            if(result != SQLITE_OK){
                //Closes database
                sqlite3_close(database);
                
                NSLog(@"DATABASE FAILED TO OPEN: %@", [dateFormat stringFromDate: today]);
                
            //Successfully opened database
            } else {
                NSLog(@"Database successfully opened");
                NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO files(content, id, downloaded, filename, filesize, courseid) VALUES ('%@', '%d', '%d', '%@', '%d', '%d' )", rval, 1, 1, cell.textLabel.text, 1, 1];

                const char *sql = [insertSQL UTF8String];
                sqlite3_stmt *sqlStatement;
                
                //Creates the object
                if (sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                    NSLog(@"Problem with prep  statement");
                    NSLog(@"%s", sqlite3_errmsg(database));
                    NSLog(@"%d", sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL));

                } else { 
                    //evaluates sql statement
                    if (sqlite3_step(sqlStatement) == SQLITE_DONE){
                        //deletes prepared statement(instance of object representing a single sql statment) to avoid resource leaks
                        sqlite3_finalize(sqlStatement);
                        //close database
                        sqlite3_close(database);
                        NSLog(@"SQLITE DONE");
                        
                    }
                    NSLog(@"SQLITE == OK");
                    
                }
            }
        }
    //Files were not retrieved
    } else {
        NSLog(@"NOT RETRIEVED!");

        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //Animates the delselecting of a row after it is selected
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    
}

//- (void) saveData{
//    sqlite3_stmt *statement;
//    //const char *dbpath = [databasePath UTF8String];
//    
//}

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
//    //Using checkmark
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
