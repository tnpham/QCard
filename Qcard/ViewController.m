//
//  ViewController.m
//  Qcard
//
//  Created by Theodore Pham on 12-03-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  ViewController.m
//  OpenEarsSampleApp
//
//  ViewController.m demonstrates the use of the OpenEars framework. 
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  This file is licensed under the Politepix Shared Source license found in the root of the source distribution.

// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// IMPORTANT NOTE: This version of OpenEars introduces a much-improved low-latency audio driver for recognition. However, it is no longer compatible with the Simulator.
// Because I understand that it can be very frustrating to not be able to debug application logic in the Simulator, I have provided a second driver that is based on
// Audio Queue Services instead of Audio Units for use with the Simulator exclusively. However, this is purely provided as a convenience for you: please do not evaluate
// OpenEars' recognition quality based on the Simulator because it is better on the device, and please do not report Simulator-only bugs since I only actively support 
// the device driver and generally, audio code should never be seriously debugged on the Simulator since it is just hosting your own desktop audio devices. Thanks!
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************



/*********************
 ********************
 ********************
 File download
 www.iphonedevsdk.com/forum/iphone-sdk-development/50862-download-text-file.html
 *********************
 *********************
 ********************/
 
#import "ViewController.h"
#import <OpenEars/PocketsphinxController.h> // Please note that unlike in previous versions of OpenEars, we now link the headers through the framework.
#import <OpenEars/FliteController.h>
#import <OpenEars/LanguageModelGenerator.h>

#import "Singleton.h"
#import "sqlite3.h"

@implementation ViewController

//@synthesize j;
//@synthesize target;

@synthesize pocketsphinxController;
@synthesize fliteController;

@synthesize startButton;
@synthesize stopButton;
@synthesize resumeListeningButton;
@synthesize suspendListeningButton;

@synthesize statusTextView;
@synthesize heardTextView;

@synthesize pocketsphinxDbLabel;
@synthesize fliteDbLabel;

@synthesize openEarsEventsObserver;
@synthesize usingStartLanguageModel;

@synthesize pathToGrammarToStartAppWith;
@synthesize pathToDictionaryToStartAppWith;
@synthesize pathToDynamicallyGeneratedGrammar;
@synthesize pathToDynamicallyGeneratedDictionary;

@synthesize firstVoiceToUse;
@synthesize secondVoiceToUse;
@synthesize uiUpdateTimer;

@synthesize isPaused;
@synthesize isEnabled;

@synthesize voiceControl;
@synthesize gameOver;

#define kLevelUpdatesPerSecond 18 // We'll have the ui update 18 times a second to show some fluidity without hitting the CPU too hard.

#pragma mark - 
#pragma mark Memory Management

- (void)dealloc {
	[self stopDisplayingLevels]; // We'll need to stop any running timers before attempting to deallocate here.
	openEarsEventsObserver.delegate = nil;
    
    //[super dealloc];
}

#pragma mark -
#pragma mark Lazy Allocation

// Lazily allocated PocketsphinxController.
- (PocketsphinxController *)pocketsphinxController { 
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

// Lazily allocated FliteController.
- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

// Lazily allocated OpenEarsEventsObserver.
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

// The last class we're using here is LanguageModelGenerator but I don't think it's advantageous to lazily instantiate it. You can see how it's used below.

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    //Global variable to store words into array
    Singleton *global = [Singleton globalVar];
    
    NSLog(@"HELLO, THIS IS A TEST FOR E_FACTOR FUNCTION");
    NSLog(@"E_Factor of: %f", [self E_factor:2.5 withq:4]);
    NSLog(@"tset %f", pow(2,4));
    
    isPaused = FALSE;
    global.initial_round = TRUE;
    global.skipped_round = FALSE;
    global.incorrect_round = FALSE;

    
    //NSData *dbFile = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.someurl.com/DatabaseName.sqlite"]];
    NSData *dbFile = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://github.com/ccgus/fmdb/blob/master/src/FMDatabase.h"]];
    NSString *resourceDocPath = [[NSString alloc] initWithString:[[[[NSBundle mainBundle]  resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Documents"]];
    
    NSString *filePath = [resourceDocPath stringByAppendingPathComponent:@"Database.sqlite"];
    
    [dbFile writeToFile:filePath atomically:YES];
    
    [super viewDidLoad];
    
    // BACKGROUND IMAGE
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"try1.png"]];
    
    //********************
    

    NSString *stored_display;
    NSString *stored_answer;
    
    //display
    target = [[NSMutableArray alloc]init];
    //answer
    target2 = [[NSMutableArray alloc]init];
    
    x_right = 0;
    x_wrong = 0;
    
    int i=0;
    j=0;
    
    /*********************Testing data retrieval
     **********************/
    NSError *error1 = nil;
    //Method 2
    // Database variables
    NSString *databaseName;
    NSString *databasePath;
    // Setup some globals
    databaseName = @"test.db";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
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
        exist = [fileManager copyItemAtPath:bundle_path toPath:databasePath error:&error1];
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
    NSString *string;
    //Open the database
    int result = sqlite3_open([databasePath UTF8String], &database);
    NSLog(@"DB Result: %d", result);
    
    //Database failed to open or DNE
    if(result != SQLITE_OK){
        //Closes database
        sqlite3_close(database);
        
        NSLog(@"DATABASE FAILED TO OPEN");
        
        //Successfully opened database
    } else {
        
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
//            NSString *querySQL = [NSString stringWithFormat: @"SELECT content FROM files WHERE filename=\"%@\"", cell.textLabel.text];
            NSString *querySQL = [NSString stringWithFormat: @"SELECT content FROM files WHERE filename=\"3443.txt\""];

            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *content = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                    string = content;
                    NSLog(@"PROBABILITY 1000");
                    
                    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Content string is: %@ ", string]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert1 show];
                    
                } else {
                    NSLog(@"No content found!");
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(database);
        }
    }
    /**********************
     *********************/
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"8109" ofType:@"txt"];
//    NSString *string = [[NSString alloc] initWithContentsOfFile:path encoding:NSASCIIStringEncoding error:NULL];
    
    NSArray *lines = [string componentsSeparatedByString:@"\n"]; // each line, adjust character for line endings
    
    NSEnumerator *nse = [lines objectEnumerator];
    NSString *tmp;
    
    [self initialize_global_arrays];
    
    //Read the file and parse each line and stores the word
    while(tmp = [nse nextObject])
    {
        //tokenizes the string
        NSArray *chunks = [tmp componentsSeparatedByString: @"/"];
        //Iterates through the array
        NSEnumerator *nse2 = [chunks objectEnumerator];
 
        
        stored_display = [nse2 nextObject];
        NSLog(@"----------%@, %d",stored_display,stored_display.length);
        stored_answer = [nse2 nextObject];
        NSLog(@"----------%@, %d",stored_answer,stored_answer.length);
        
        NSLog(@"display %@", stored_display);
        NSLog(@"ans %@", stored_answer);
        
        if ((stored_display.length != 0) && (stored_answer.length != 0)){
            [target addObject:stored_display];
            [target2 addObject:stored_answer];
            NSLog(@"ans %@", stored_answer);

            [global.initialWords addObject:stored_display];
            [global.initialAnswers addObject:stored_answer]; 
            
            NSLog(@"INITIAL WORDS: %@", global.initialWords);
              NSLog(@"TARGET: %@", target);
            
            NSLog(@"INITIAL ANSWERS: %@", global.initialAnswers);
              NSLog(@"TARGET2: %@", target2);
            
            NSLog(@"ADDED");
        
            //debugging
            for(int i =0; i<[target count]; i++);
            {
                NSLog(@"Displayed: %@", [target objectAtIndex:i]);
                NSLog(@"Answer: %@", [target2 objectAtIndex:i]);
            }
            
            //Stores the answer
            [global.answerArray addObject:stored_answer];
            NSLog(@"AnswerArray %@", global.answerArray);
        }
        
    }//End while 

    global.elements = [global.answerArray count];
  
    global.array_index=j+1;
    totalWORDS.text = [NSString stringWithFormat:@"%d / %u", global.array_index, global.elements];
    
    //Prints out the first word
//    [self performSelectorOnMainThread:@selector(Word:) withObject: [target objectAtIndex:j] waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(Word:) withObject: [global.initialWords objectAtIndex:j] waitUntilDone:NO];

    
    sil=2;sp=2;
    printf("BEFORE");
    /*
     agc_set_threshold(agc, 12);
     agcthresh = agc_get_threshold(agc);
     printf("%d\n", agcthresh);
     */
    //Noise threshold level, does not work when you don't have A/D
    printf("%d:%d*************\n", sil, sp);
    thresh = cont_ad_set_thresh(cont, sil, sp);
    printf("%d*************\n", thresh);
    E_INFO("Threshold: %d**************\n", thresh);
    printf("After\n");
    
    
	[self.openEarsEventsObserver setDelegate:self]; // Make this class the delegate of OpenEarsObserver so we can get all of the messages about what OpenEars is doing.
    
	// The following strings could be set to any of the following voices:
	// cmu_us_awb8k // 8k version of the us_awb voice
	// cmu_us_rms8k // 8k version of the us_rms voice
	// cmu_us_slt8k // 8k version of the us_slt voice
	// cmu_time_awb // 16k awb time voice, unlikely to do much unless used to read time
	// cmu_us_awb //  16k us_awb voice
	// cmu_us_kal //  8k us_kal voice
	// cmu_us_kal16 // 16k us_kal voice
	// cmu_us_rms // 16k us_rms voice
	// cmu_us_slt // 16k us_slt voice
    
	self.secondVoiceToUse = @"cmu_us_slt";//female
	self.firstVoiceToUse = @"cmu_us_rms"; //male
	
    // Now, OpenEars ships with all 9 voices enabled, which causes the app binaries to be very large. Before shipping, you want to open up the OpenEars.xcodeproj project and comment out the voices you aren't using in the file OpenEarsConfig.h so that your app binary will be reasonably sized, and then build the project. If you aren't using FliteController at all, you can comment out all the voices and save even more space.
	
    // This is the language model we're going to start up with. The only reason I'm making it a class property is that I reuse it a bunch of times in this example, 
	// but you can pass the string contents directly to PocketsphinxController:startListeningWithLanguageModelAtPath:dictionaryAtPath:languageModelIsJSGF:
	
	//self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"OpenEars1.languagemodel"]; 
    self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"8109.lm.txt"]; 
    
	// This is the dictionary we're going to start up with. The only reason I'm making it a class property is that I reuse it a bunch of times in this example, 
	// but you can pass the string contents directly to PocketsphinxController:startListeningWithLanguageModelAtPath:dictionaryAtPath:languageModelIsJSGF:
	//self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"OpenEars1.dic"]; 
    self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"8109.dic"]; 
    
	self.usingStartLanguageModel = TRUE; // This is not an OpenEars thing, this is just so I can switch back and forth between the two models in this sample app.
	
	// Here is an example of dynamically creating an in-app grammar.
	
	// We want it to be able to response to the speech "CHANGE MODEL" and a few other things.  Items we want to have recognized as a whole phrase (like "CHANGE MODEL") 
	// we put into the array as one string (e.g. "CHANGE MODEL" instead of "CHANGE" and "MODEL"). This increases the probability that they will be recognized as a phrase. This works even better starting with version 1.0 of OpenEars.
	
	NSArray *languageArray = [[NSArray alloc] initWithArray:[NSArray arrayWithObjects: // All capital letters.
                                                             @"SUNDAY",@"MONDAY",@"TUESDAY",@"WEDNESDAY",@"THURSDAY",@"FRIDAY",@"SATURDAY",@"QUIDNUNC",@"CHANGE MODEL",
                                                             nil]];
    
	
	// The last entry, quidnunc, is an example of a word which will not be found in the lookup dictionary and will be passed to the fallback method. The fallback method is slower,
	// so, for instance, creating a new language model from dictionary words will be pretty fast, but a model that has a lot of unusual names in it or invented/rare/recent-slang
	// words will be slower to generate. You can use this information to give your users good UI feedback about what the expectations for wait times should be.
	
	// Turning on OPENEARSLOGGING in the OpenEars.xcodeproj OpenEarsConfig.h header and recompiling the framework will tell you how long the language model took to generate.
    
	// I don't think it's beneficial to lazily instantiate LanguageModelGenerator because you only need to give it a single message and then release it.
	// If you need to create a very large model or any size of model that has many unusual words that have to make use of the fallback generation method,
	// you will want to run this on a background thread so you can give the user some UI feedback that the task is in progress.
    
	LanguageModelGenerator *languageModelGenerator = [[LanguageModelGenerator alloc] init]; 
    
    //	// generateLanguageModelFromArray:withFilesNamed returns an NSError which will either have a value of noErr if everything went fine or a specific error if it didn't.
	NSError *error = [languageModelGenerator generateLanguageModelFromArray:languageArray withFilesNamed:@"OpenEarsDynamicGrammar"]; 
	NSDictionary *dynamicLanguageGenerationResultsDictionary = nil;
	if([error code] != noErr) {
		NSLog(@"Dynamic language generator reported error %@", [error description]);	
	} else {
		dynamicLanguageGenerationResultsDictionary = [error userInfo];
		
		// A useful feature of the fact that generateLanguageModelFromArray:withFilesNamed: always returns an NSError is that when it returns noErr (meaning there was
		// no error, or an [NSError code] of zero), the NSError also contains a userInfo dictionary which contains the path locations of your new files.
		
		// What follows demonstrates how to get the paths for your created dynamic language models out of that userInfo dictionary.
		NSString *lmFile = [dynamicLanguageGenerationResultsDictionary objectForKey:@"LMFile"];
		NSString *dictionaryFile = [dynamicLanguageGenerationResultsDictionary objectForKey:@"DictionaryFile"];
		NSString *lmPath = [dynamicLanguageGenerationResultsDictionary objectForKey:@"LMPath"];
		NSString *dictionaryPath = [dynamicLanguageGenerationResultsDictionary objectForKey:@"DictionaryPath"];
		
		NSLog(@"Dynamic language generator completed successfully, you can find your new files %@\n and \n%@\n at the paths \n%@ \nand \n%@", lmFile,dictionaryFile,lmPath,dictionaryPath);	
		
		// pathToDynamicallyGeneratedGrammar/Dictionary aren't OpenEars things, they are just the way I'm controlling being able to switch between the grammars in this sample app.
		self.pathToDynamicallyGeneratedGrammar = lmPath; // We'll set our new .languagemodel file to be the one to get switched to when the words "CHANGE MODEL" are recognized.
		self.pathToDynamicallyGeneratedDictionary = dictionaryPath; // We'll set our new dictionary to be the one to get switched to when the words "CHANGE MODEL" are recognized.
	}
	
	
    // Next, an informative message.
    
	NSLog(@"\n\nWelcome to the OpenEars sample project. This project understands the words:\nBACKWARD,\nCHANGE,\nFORWARD,\nGO,\nLEFT,\nMODEL,\nRIGHT,\nTURN,\nand if you say \"CHANGE MODEL\" it will switch to its dynamically-generated model which understands the words:\nCHANGE,\nMODEL,\nMONDAY,\nTUESDAY,\nWEDNESDAY,\nTHURSDAY,\nFRIDAY,\nSATURDAY,\nSUNDAY,\nQUIDNUNC");
	
	// This is how to start the continuous listening loop of an available instance of PocketsphinxController. We won't do this if the language generation failed since it will be listening for a command to change over to the generated language.
	if(dynamicLanguageGenerationResultsDictionary) {
        
		// startListeningWithLanguageModelAtPath:dictionaryAtPath:languageModelIsJSGF always needs to know the grammar file being used, 
		// the dictionary file being used, and whether the grammar is a JSGF. You must put in the correct value for languageModelIsJSGF.
		// Inside of a single recognition loop, you can only use JSGF grammars or ARPA grammars, you can't switch between the two types.
		
		// An ARPA grammar is the kind with a .languagemodel or .DMP file, and a JSGF grammar is the kind with a .gram file.
		[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
        
	}
    
    
    
    
	// [self startDisplayingLevels] is not an OpenEars method, just an approach for level reading
	// that I've included with this sample app. My example implementation does make use of two OpenEars
	// methods:	the pocketsphinxInputLevel method of PocketsphinxController and the fliteOutputLevel
	// method of fliteController. 
	//
	// The example is meant to show one way that you can read those levels continuously without locking the UI, 
	// by using an NSTimer, but the OpenEars level-reading methods 
	// themselves do not include multithreading code since I believe that you will want to design your own 
	// code approaches for level display that are tightly-integrated with your interaction design and the  
	// graphics API you choose. 
	// 
	// Please note that if you use my sample approach, you should pay attention to the way that the timer is always stopped in
	// dealloc. This should prevent you from having any difficulties with deallocating a class due to a running NSTimer process.
	
	[self startDisplayingLevels];
    
	// Here is some UI stuff that has nothing specifically to do with OpenEars implementation
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = TRUE;
	self.suspendListeningButton.hidden = TRUE;
	self.resumeListeningButton.hidden = TRUE;
    
    
    
 
}




/**************************** FUNCTIONS **********************************/


//Displays the speech interpreted
-(void) Word: (NSString*) word
{
    //Another way to display text
    //Rotates text
    //lblWORD.transform = CGAffineTransformMakeRotation(-3.14/3.5);
    lblWORD.text = word;

    
}

//Allows user to pass on to the next word
- (IBAction) Pass:(id)sender
{
    Singleton *global = [Singleton globalVar];
    int p = [global.answerArray count];
//    int p = [global.skippedAnswers count];

    NSLog(@"p = %d", p);
    NSLog(@"j = %d", j);
    int h = p-1;
    NSLog(@"h = %d", h);
    
    if (j == h){
        if (([global.skippedWords count] == 0) && ([global.troubledWords count] == 0)){
            [self.pocketsphinxController stopListening];
            NSLog(@"NO MORE WORDS");
            
            [self endGame];
            
        } else {
            [global.initialWords removeAllObjects];
            [self check_any_skipped_or_incorrect_words_left];
            global.initial_round = TRUE;
        }

        NSLog(@"Skipped Words: %@", global.skippedWords);
        
    } else {
        /******
         BIG BUG when looping second time
         *****/
        
        //Start a new round with skipped and incorrect words
        if (global.initial_round == TRUE){
            //Prints out next word
            NSLog(@"value of j: %d", j);
//            j++;
//            global.index = j;

            [self performSelectorOnMainThread:@selector(Word:) withObject:[global.skippedWords objectAtIndex:j]waitUntilDone:NO];
            j++;
            global.index = j;
            NSLog(@"value of j: %d", j);
            NSLog(@"value of gindex: %d", global.index);
            
//            global.elements = [global.answerArray count];
//            global.array_index=j+1;
            global.elements = [global.skippedWords count];
            global.array_index=j;
            totalWORDS.text = [NSString stringWithFormat:@"%d / %u", global.array_index, global.elements];
            
            [self resetImage];

        } else {

            //Stores all the skipped words
//            [global.skippedWords addObject:[global.answerArray objectAtIndex:j]]; 
            NSLog(@"Round not over yet");
            [global.skippedWords addObject:[global.initialWords objectAtIndex:j]];    
            [global.skippedAnswers addObject:[global.initialAnswers objectAtIndex:j]];    

        
            //Prints out next word
            j++;
            global.index = j;
            [self performSelectorOnMainThread:@selector(Word:) withObject:[global.initialWords objectAtIndex:j]waitUntilDone:NO];
            
            global.elements = [global.answerArray count];
            global.array_index=j+1;
            totalWORDS.text = [NSString stringWithFormat:@"%d / %u", global.array_index, global.elements];
            
            [self resetImage];
            
        }
        
        
        if (global.initial_round){
            [global.skippedWords addObject:[global.initialWords objectAtIndex:j]];    
            [global.skippedAnswers addObject:[global.initialAnswers objectAtIndex:j]];  
            //Prints out next word
            j++;
            global.index = j;
            [self performSelectorOnMainThread:@selector(Word:) withObject:[global.initialWords objectAtIndex:j]waitUntilDone:NO];
            
            global.elements = [global.answerArray count];
            global.array_index=j+1;
            totalWORDS.text = [NSString stringWithFormat:@"%d / %u", global.array_index, global.elements];
            
            [self resetImage];
            
        } else if (global.skipped_round){
            
            
        } else if (global.incorrect_round){
            
        }
        
    }//end outer else
}

//Displays if word was said correctly
-(void) Correctness: (NSString*) correctness
{
    //Another way to display text
    //lblCORRECTNESS.transform = CGAffineTransformMakeRotation(-3.14/3);
    lblCORRECTNESS.text = correctness;
    
}

//Controls which view to go to after user finishes
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"OMGGG OK");
    }
    else
    {
        NSLog(@"OMGGG cancel");
    }
}

/************************
 Function that calculates the frequency of a word reappearing.
 EF is between 1.1 and 2.5
 q is rated according to a 5 point scale:
 5- Correct
 4- Correct with hesitation
 3- Correct with 1 miss
 2- Correct with 2 misses
 1- Incorrect
 0- Skipped

 ***********************/
- (double) E_factor: (double)EF withq: (double)q{
    double EF_prime;
    
    EF_prime = EF - 0.8 + (0.28*q) - (0.02*pow(q,2));
    return EF_prime;
}

//things to do after game has ended
- (void) endGame {
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil message:@"END OF GAME"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert1 show];
}

//Sets the iamges back to blank
- (void) resetImage {
    UIImage *img1 = [UIImage imageNamed:@"blank.png"];
    [imageView1 setImage:img1];
    UIImage *img2 = [UIImage imageNamed:@"blank.png"];
    [imageView2 setImage:img2];
    UIImage *img3 = [UIImage imageNamed:@"blank.png"];
    [imageView3 setImage:img3];
}

//Displays message according to number of wrongs user obtains
- (void) wrong_answer_message: (NSString *) trim{
    
    Singleton *global = [Singleton globalVar];
    
    if(x==0){
        [self.fliteController say:[NSString stringWithFormat:@"TRY AGAIN"] withVoice:self.secondVoiceToUse];
        [buttonCHECK1 setImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
        UIImage *img1 = [UIImage imageNamed:@"wrong.png"];
        [imageView1 setImage:img1];
        
    } else if(x==1){
        [self.fliteController say:[NSString stringWithFormat:@"TRY AGAIN"] withVoice:self.secondVoiceToUse];
        [buttonCHECK2 setImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
        UIImage *img2 = [UIImage imageNamed:@"wrong.png"];
        [imageView2 setImage:img2];
        
    } else if(x==2){
        //Number of tries exceeded
        [self.fliteController say:[NSString stringWithFormat:@"NO MORE TRIES"] withVoice:self.secondVoiceToUse];
        [buttonCHECK3 setImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
        UIImage *img3 = [UIImage imageNamed:@"wrong.png"];
        [imageView3 setImage:img3];
        
        //Stores all the words the user says incorrectly
//        [global.troubledWords addObject:[global.answerArray objectAtIndex:j]];    
        [global.troubledWords addObject:trim];    

        
        
        printf("&&&&&&&&&&&&%d&&&&&&&&&&&&&&\n", x);
        
        int p = [global.answerArray count];
        NSLog(@"p = %d", p);
        NSLog(@"j = %d", j);
        int h = p-1;
        NSLog(@"h = %d", h);
        
        //No more Cue cards left
        if (j == h){
            if (([global.skippedWords count] == 0) && ([global.troubledWords count] == 0)){
                [self.pocketsphinxController stopListening];
                NSLog(@"NO MORE WORDS");
                
                [self endGame];
                
            } else {
                [global.initialWords removeAllObjects];
                [self check_any_skipped_or_incorrect_words_left];
            }

            
        //Prepare for the next one
        } else {
            j++;
            
            global.index = j;
            [self performSelectorOnMainThread:@selector(Word:) withObject:[target objectAtIndex:j] waitUntilDone:NO];
            
            global.elements = [global.answerArray count];
            global.array_index=j+1;
            totalWORDS.text = [NSString stringWithFormat:@"%d / %u", global.array_index, global.elements];
            
            [self resetImage];
            
            x_wrong++;
            [self display_number_of_correct_and_incorrect_answers ];
            
            x = -1;
        }
    } 
}

- (void) check_any_skipped_or_incorrect_words_left{
    
    Singleton *global = [Singleton globalVar];
    
    if ([global.skippedWords count] != 0){
        j=0;
        NSLog(@"Skipped words still left");
//        global.index = j;
        
    } else if ([global.troubledWords count] != 0){
        j=0;
        NSLog(@"Troubled words still left");
//        global.index =  j;
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////

//Displays the ratio of correct and incorrect answers
- (void) display_number_of_correct_and_incorrect_answers{
    
    lblRIGHT.text = [NSString stringWithFormat:@"%g",x_right];
    lblWRONG.text = [NSString stringWithFormat:@"%g",x_wrong];
}

//Initalize all global arrays
- (void) initialize_global_arrays{
    
    Singleton *global = [Singleton globalVar];
    
    if (global.answerArray == nil)
    {
        global.answerArray = [[NSMutableArray alloc] init ];
    }
    if (global.troubledWords == nil)
    {
        global.troubledWords = [[NSMutableArray alloc] init ];
    }
    if (global.initialWords == nil)
    {
        global.initialWords = [[NSMutableArray alloc] init ];
    }
    if (global.easyWords == nil)
    {
        global.easyWords = [[NSMutableArray alloc] init ];
    }
    if (global.skippedWords == nil)
    {
        global.skippedWords = [[NSMutableArray alloc] init ];
    }
    if (global.troubledAnswers == nil)
    {
        global.troubledAnswers = [[NSMutableArray alloc] init ];
    }
    if (global.initialAnswers == nil)
    {
        global.initialAnswers = [[NSMutableArray alloc] init ];
    }
    if (global.skippedAnswers == nil)
    {
        global.skippedAnswers = [[NSMutableArray alloc] init ];
    }
}

//Analyzes what the user said and evaluates accordingly
- (void) analyze_input: (NSString *) trim withb: (NSString *) trim2{
    Singleton *global = [Singleton globalVar];
    
    if([trim isEqualToString: trim2] == YES){
        [self performSelectorOnMainThread:@selector(Correctness:) withObject:[NSString stringWithUTF8String:"CORRECT"] waitUntilDone:NO];
        
        //Suspend recognition so that the playback voice does not get recorded
        [self.pocketsphinxController suspendRecognition];	
        NSLog(@"PAUSED");
        
        [self.fliteController say:[NSString stringWithFormat:@"GOOD JOB"] withVoice:self.secondVoiceToUse];NSLog(@"GOOD JOB!!!");
        
        [buttonCHECK2 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        sleep(2);
        
        //Increments to the next word
        j++;
        global.elements = [global.answerArray count];
        global.array_index = j + 1;
        totalWORDS.text = [NSString stringWithFormat:@"%d / %u", global.array_index, global.elements];
        
        global.index = j;
        
        //Displays next word in line
        [self performSelectorOnMainThread:@selector(Word:) withObject:[target objectAtIndex:j] waitUntilDone:NO];
        
        //Stats
        x_right++;
        
        [self display_number_of_correct_and_incorrect_answers];
        
        //Extra Stats
        //lblPOSTERIOR.text = [NSString stringWithFormat:@"Posterior: %d",prob];
        //lblCONFIDENCE.text = [NSString stringWithFormat:@"Confidence: %g",conf];
        
        [self resetImage];
        
        x=0;
        
//        [global.easyWords addObject:[global.answerArray objectAtIndex:j]];    
        [global.easyWords addObject: trim];
        
        ///Checks if round 1 is over
        if (global.initial_round){
            [global.skippedWords removeObjectAtIndex:j];
            [global.skippedAnswers removeObjectAtIndex:j];
        }
        
        //Resume recognition
        [self.pocketsphinxController resumeRecognition];
        NSLog(@"RESUMED");
        //Word was incorrectly said
    } else {
        
        [self performSelectorOnMainThread:@selector(Correctness:) withObject:[NSString stringWithUTF8String:"INCORRECT"] waitUntilDone:NO];
        
        //Extra Stats
        //lblPOSTERIOR.text = [NSString stringWithFormat:@"Posterior: %d",prob];
        //lblCONFIDENCE.text = [NSString stringWithFormat:@"Confidence: %g",conf];
        
        [self wrong_answer_message: trim];
        x++;
    }//end if
    
}


- (void) enableButtons{
    Pass.enabled = YES;
    Peek.enabled = YES;
    startButton.enabled = YES;
}

-(void) disableButtons{
    Pass.enabled = NO;
    Peek.enabled = NO;
    startButton.enabled = NO;
}

/**************************** END FUNCTIONS **********************************/



#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

// What follows are all of the delegate methods you can optionally use once you've instantiated an OpenEarsEventsObserver and set its delegate to self. 
// I've provided some pretty granular information about the exact phase of the Pocketsphinx listening loop, the Audio Session, and Flite, but I'd expect 
// that the ones that will really be needed by most projects are the following:
//
//- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID;
//- (void) audioSessionInterruptionDidBegin;
//- (void) audioSessionInterruptionDidEnd;
//- (void) audioRouteDidChangeToRoute:(NSString *)newRoute;
//- (void) pocketsphinxDidStartListening;
//- (void) pocketsphinxDidStopListening;
//
// It isn't necessary to have a PocketsphinxController or a FliteController instantiated in order to use these methods.  If there isn't anything instantiated that will
// send messages to an OpenEarsEventsObserver, all that will happen is that these methods will never fire.  You also do not have to create a OpenEarsEventsObserver in
// the same class or view controller in which you are doing things with a PocketsphinxController or FliteController; you can receive updates from those objects in
// any class in which you instantiate an OpenEarsEventsObserver and set its delegate to self.
// An optional delegate method of OpenEarsEventsObserver which delivers the text of speech that Pocketsphinx heard and analyzed, along with its accuracy score and utterance ID.
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {

	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID); // Log it.
    
//	if([hypothesis isEqualToString:@"CHANGE MODEL"]) { // If the user says "CHANGE MODEL", we will switch to the alternate model (which happens to be the dynamically generated model).
//        
//		// Here is an example of language model switching in OpenEars. Deciding on what logical basis to switch models is your responsibility.
//		// For instance, when you call a customer service line and get a response tree that takes you through different options depending on what you say to it,
//		// the models are being switched as you progress through it so that only relevant choices can be understood. The construction of that logical branching and 
//		// how to react to it is your job, OpenEars just lets you send the signal to switch the language model when you've decided it's the right time to do so.
//		
//		if(self.usingStartLanguageModel == TRUE) { // If we're on the starting model, switch to the dynamically generated one.
//			
//			// You can only change language models with ARPA grammars in OpenEars (the ones that end in .languagemodel or .DMP). 
//			// Trying to switch between JSGF models (the ones that end in .gram) will return no result.
//			[self.pocketsphinxController changeLanguageModelToFile:self.pathToDynamicallyGeneratedGrammar withDictionary:self.pathToDynamicallyGeneratedDictionary]; 
//			self.usingStartLanguageModel = FALSE;
//		} else { // If we're on the dynamically generated model, switch to the start model (this is just an example of a trigger and method for switching models).
//			[self.pocketsphinxController changeLanguageModelToFile:self.pathToGrammarToStartAppWith withDictionary:self.pathToDictionaryToStartAppWith];
//			self.usingStartLanguageModel = TRUE;
//		}
//	}        
	
	self.heardTextView.text = [NSString stringWithFormat:@"You said: \"%@\"", hypothesis]; // Show it in the status box.
    
    char const *hyp;
    char word[MAX_CHAR_LEN];
    NSString *tmp_word;

    Singleton *global = [Singleton globalVar];
    
    NSMutableArray *test;

    
    //Change up the arrays to accomodate the skipped and incorrect words
    if (global.initial_round){
        test = global.initialAnswers;
        NSLog(@"Initial Array");
        
    } else if (global.skipped_round){
        test = global.skippedAnswers;
        NSLog(@"Skipped Array");

    } else if (global.incorrect_round){
        test = global.troubledAnswers;
        NSLog(@"Incorrect Array");

    }
//    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$---------%@", global.index);
//    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$---------%@", j);

    //Converts Objective c pointer to type const char
    hyp = [hypothesis UTF8String];
    
    printf("What you said: %s\n", hyp);
    
    //If nothing was said or background noise heard
    if (hyp == NULL || strlen(hyp) <= 0)
    {
        //[self performSelectorOnMainThread:@selector(setStatus:) withObject:@"Sorry, Unable to Recognise, please try again" waitUntilDone:NO];
        printf("Nothing was heard!!!\n");

        return;
    } else {
        //printf("%s: %s\n", uttid, hyp);
        fflush(stdout);
        
        // Evaluates only the first word said 
        if (hyp) {
            //Scans what is said and places it in the array 'word'
            sscanf(hyp, "%s", word);
            NSLog(@"WORD: %s", word);
            NSLog(@"HYP: %s",hyp);
            
            tmp_word = [NSString stringWithFormat:@"%s", word];
         
            //Word answer
//            NSString *trim = [[global.initialWords objectAtIndex:j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *trim = [[test objectAtIndex:j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //Word said
            NSString *trim2 = [tmp_word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSLog(@"Word----->>>> %@, %d", trim, [trim length]);
            NSLog(@"Said----->>>> %@, %d", trim2, [trim2 length]);
            
            [self analyze_input:trim withb:trim2];        
        }
    }//End Checking
//    }
}








// An optional delegate method of OpenEarsEventsObserver which informs that there was an interruption to the audio session (e.g. an incoming phone call).
- (void) audioSessionInterruptionDidBegin {
	NSLog(@"AudioSession interruption began."); // Log it.
	self.statusTextView.text = @"Status: AudioSession interruption began."; // Show it in the status box.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since it will need to restart its loop after an interruption.
}

// An optional delegate method of OpenEarsEventsObserver which informs that the interruption to the audio session ended.
- (void) audioSessionInterruptionDidEnd {
	NSLog(@"AudioSession interruption ended."); // Log it.
	self.statusTextView.text = @"Status: AudioSession interruption ended."; // Show it in the status box.
    // We're restarting the previously-stopped listening loop.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the audio input became unavailable.
- (void) audioInputDidBecomeUnavailable {
	NSLog(@"The audio input has become unavailable"); // Log it.
	self.statusTextView.text = @"Status: The audio input has become unavailable"; // Show it in the status box.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since there is no available input
}

// An optional delegate method of OpenEarsEventsObserver which informs that the unavailable audio input became available again.
- (void) audioInputDidBecomeAvailable {
	NSLog(@"The audio input is available"); // Log it.
	self.statusTextView.text = @"Status: The audio input is available"; // Show it in the status box.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was a change to the audio route (e.g. headphones were plugged in or unplugged).
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute {
	NSLog(@"Audio route change. The new audio route is %@", newRoute); // Log it.
	self.statusTextView.text = [NSString stringWithFormat:@"Status: Audio route change. The new audio route is %@",newRoute]; // Show it in the status box.
    
	[self.pocketsphinxController stopListening]; // React to it by telling the Pocketsphinx loop to shut down and then start listening again on the new route
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

//*************************
//*************************
//*************************

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop hit the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx. Another good reason to know when you're in the middle of
// calibration is that it is a timeframe in which you want to avoid playing any other sounds including speech so the calibration will be successful.
- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx calibration has started."; // Show it in the status box.
    [self disableButtons];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop completed the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx calibration is complete."; // Show it in the status box.
    
	self.fliteController.duration_stretch = 1.0; // Change the speed
	self.fliteController.target_mean = 0.7; // Change the pitch
	self.fliteController.target_stddev = 1.5; // Change the variance
	
    [self.fliteController say:@"Welcome, Let Us Begin" withVoice:self.firstVoiceToUse];
    // The same statement with the pitch and other voice values changed.
	
	self.fliteController.duration_stretch = 1.0; // Reset the speed
	self.fliteController.target_mean = 1.0; // Reset the pitch
	self.fliteController.target_stddev = 1.0; // Reset the variance
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop has entered its actual loop.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxRecognitionLoopDidStart {
    
	NSLog(@"Pocketsphinx is starting up."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx is starting up."; // Show it in the status box.
    self.statusTextView.text = @"Initializing....";
    
    [self disableButtons];
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is now listening for speech.
- (void) pocketsphinxDidStartListening {
	
	NSLog(@"Pocketsphinx is now listening."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx is now listening."; // Show it in the status box.
    self.statusTextView.text = @"Ready to go";
	
	self.startButton.hidden = FALSE; // React to it with some UI changes.
	self.stopButton.hidden = FALSE;
	self.suspendListeningButton.hidden = FALSE;
	self.resumeListeningButton.hidden = TRUE;
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected speech and is starting to process it.
- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech."); // Log it.
	//self.statusTextView.text = @"Status: Pocketsphinx has detected speech."; // Show it in the status box.
    self.statusTextView.text = @"Evaluating...";
    
    [self disableButtons];
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected a second of silence, indicating the end of an utterance. 
// This was added because developers requested being able to time the recognition speed without the speech time. The processing time is the time between 
// this method being called and the hypothesis being returned.
- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a second of silence, concluding an utterance."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has detected finished speech."; // Show it in the status box.
    
    [self enableButtons];
}


// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx has exited its recognition loop, most 
// likely in response to the PocketsphinxController being told to stop listening via the stopListening method.
- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has stopped listening."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop but it is not
// Going to react to speech until listening is resumed.  This can happen as a result of Flite speech being
// in progress on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to suspend recognition via the suspendRecognition method.
- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has suspended recognition."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop and after recognition
// having been suspended it is now resuming.  This can happen as a result of Flite speech completing
// on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to resume recognition via the resumeRecognition method.
- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has resumed recognition."; // Show it in the status box.
}

// An optional delegate method which informs that Pocketsphinx switched over to a new language model at the given URL in the course of
// recognition. This does not imply that it is a valid file or that recognition will be successful using the file.
- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

// An optional delegate method of OpenEarsEventsObserver which informs that Flite is speaking, most likely to be useful if debugging a
// complex interaction between sound classes. You don't have to do anything yourself in order to prevent Pocketsphinx from listening to Flite talk and trying to recognize the speech.
- (void) fliteDidStartSpeaking {
	NSLog(@"Flite has started speaking"); // Log it.
	self.statusTextView.text = @"Status: Flite has started speaking."; // Show it in the status box.
    
    [self disableButtons];
}

// An optional delegate method of OpenEarsEventsObserver which informs that Flite is finished speaking, most likely to be useful if debugging a
// complex interaction between sound classes.
- (void) fliteDidFinishSpeaking {
	NSLog(@"Flite has finished speaking"); // Log it.
	self.statusTextView.text = @"Status: Flite has finished speaking."; // Show it in the status box.
    [self enableButtons];
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OPENEARSLOGGING in OpenEarsConfig.h to learn more."); // Log it.
	self.statusTextView.text = @"Status: Not possible to start recognition loop."; // Show it in the status box.	
}

#pragma mark -
#pragma mark UI

// This is not OpenEars-specific stuff, just some UI behavior
/*
- (IBAction) suspendListeningButtonAction { // This is the action for the button which suspends listening without ending the recognition loop
	[self.pocketsphinxController suspendRecognition];	
	
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = FALSE;
	self.suspendListeningButton.hidden = TRUE;
	self.resumeListeningButton.hidden = FALSE;
    
    //Disables button on pause
    [Pass setEnabled:FALSE];
    [buttonANSWER setEnabled:FALSE];
}

- (IBAction) resumeListeningButtonAction { // This is the action for the button which resumes listening if it has been suspended
	[self.pocketsphinxController resumeRecognition];
	
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = FALSE;
	self.suspendListeningButton.hidden = FALSE;
	self.resumeListeningButton.hidden = TRUE;	
    
    //Enables button on resume
    [Pass setEnabled:TRUE];
    [buttonANSWER setEnabled:TRUE];
}

- (IBAction) stopButtonAction { // This is the action for the button which shuts down the recognition loop.
	[self.pocketsphinxController stopListening];
	
	self.startButton.hidden = FALSE;
	self.stopButton.hidden = TRUE;
	self.suspendListeningButton.hidden = TRUE;
	self.resumeListeningButton.hidden = TRUE;
}
 */

- (IBAction) startButtonAction { // This is the action for the button which starts up the recognition loop again if it has been shut down.
	//[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
    
    if(isPaused){
        [startButton setImage:[UIImage imageNamed:@"microphone-128.png"] forState:UIControlStateNormal];
        NSLog(@"RESUMED");
        [self.pocketsphinxController resumeRecognition];
        isPaused = FALSE;
    } else {
        [startButton setImage:[UIImage imageNamed:@"no_mic.png"] forState:UIControlStateNormal];
        NSLog(@"PAUSED");
        [self.pocketsphinxController suspendRecognition];	
        isPaused = TRUE;
    }
	//self.startButton.hidden = TRUE;
	//self.stopButton.hidden = FALSE;
	//self.suspendListeningButton.hidden = FALSE;
	//self.resumeListeningButton.hidden = TRUE;
}

- (IBAction) muteVoice {
    
    if(isEnabled){
        [voiceControl setImage:[UIImage imageNamed:@"speaker.png"] forState:UIControlStateNormal];
        NSLog(@"Voice unmuted");
        //[self.pocketsphinxController resumeRecognition];
        isEnabled = FALSE;
    } else {
        [voiceControl setImage:[UIImage imageNamed:@"speaker_mute.png"] forState:UIControlStateNormal];
        NSLog(@"Voice muted");
        //[self.pocketsphinxController suspendRecognition];	
        isEnabled = TRUE;
    }

}


#pragma mark -
#pragma mark Example for reading out Pocketsphinx and Flite audio levels without locking the UI by using an NSTimer

// What follows are not OpenEars methods, just an approach for level reading
// that I've included with this sample app. My example implementation does make use of two OpenEars
// methods:	the pocketsphinxInputLevel method of PocketsphinxController and the fliteOutputLevel
// method of fliteController. 
//
// The example is meant to show one way that you can read those levels continuously without locking the UI, 
// by using an NSTimer, but the OpenEars level-reading methods 
// themselves do not include multithreading code since I believe that you will want to design your own 
// code approaches for level display that are tightly-integrated with your interaction design and the  
// graphics API you choose. 
// 
// Please note that if you use my sample approach, you should pay attention to the way that the timer is always stopped in
// dealloc. This should prevent you from having any difficulties with deallocating a class due to a running NSTimer process.

- (void) startDisplayingLevels { // Start displaying the levels using a timer
	[self stopDisplayingLevels]; // We never want more than one timer valid so we'll stop any running timers first.
	self.uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/kLevelUpdatesPerSecond target:self selector:@selector(updateLevelsUI) userInfo:nil repeats:YES];
}

- (void) stopDisplayingLevels { // Stop displaying the levels by stopping the timer if it's running.
	if(self.uiUpdateTimer && [self.uiUpdateTimer isValid]) { // If there is a running timer, we'll stop it here.
		[self.uiUpdateTimer invalidate];
		self.uiUpdateTimer = nil;
	}
}

- (void) updateLevelsUI { // And here is how we obtain the levels.  This method includes the actual OpenEars methods and uses their results to update the UI of this view controller.
    
	self.pocketsphinxDbLabel.text = [NSString stringWithFormat:@"Pocketsphinx Input level:%f",[self.pocketsphinxController pocketsphinxInputLevel]];  //pocketsphinxInputLevel is an OpenEars method of the class PocketsphinxController.
    
	if(self.fliteController.speechInProgress == TRUE) {
		self.fliteDbLabel.text = [NSString stringWithFormat:@"Flite Output level: %f",[self.fliteController fliteOutputLevel]]; // fliteOutputLevel is an OpenEars method of the class FliteController.
	}
}




//Changing views
-(IBAction)switch2answer {
    /*
    AnswerViewController *answer = [[AnswerViewController alloc] initWithNibName:@"AnswerViewController" bundle:nil];
    //FlipHorizontal and CoverVertical
    answer.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:answer animated:YES];
    
    //[answer release];*/
    
    AnswerViewController *answer = [[AnswerViewController alloc] initWithNibName:@"AnswerViewController" bundle:nil];
    //FlipHorizontal and CoverVertical
    answer.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:answer animated:YES];
    
    
    //If wanting to use 'release', must turn off Objective-C AUtomatic Referencing Counting in "Build Settings
    //[answer release];
}


@end
