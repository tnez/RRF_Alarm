////////////////////////////////////////////////////////////
//  RRFAlarmController.m
//  RRFAlarm
//  --------------------------------------------------------
//  Author: Travis Nesland
//  Created: 1/4/11
//  Copyright 2011, Residential Research Facility,
//  University of Kentucky. All Rights Reserved.
/////////////////////////////////////////////////////////////
#import "RRFAlarmController.h"

@implementation RRFAlarmController
@synthesize delegate,definition,errorLog,view,promptField,continueButton,audio;

#pragma mark HOUSEKEEPING METHODS
/**
 Give back any memory that may have been allocated by this bundle
 */
- (void)dealloc {
    [errorLog release];
    // any additional release calls go here
    // ------------------------------------
    [audio release];
    [super dealloc];
}

#pragma mark REQUIRED PROTOCOL METHODS
/**
 Start the component - will receive this message from the component controller
 */
- (void)begin {
  [audio setLoops:YES];
  [audio play];
}
/**
 Return a string representation of the data directory
 */
- (NSString *)dataDirectory {
    return [[definition valueForKey:RRFAlarmDataDirectoryKey] 
            stringByStandardizingPath];
}
/**
 Return a string object representing all current errors in log form
 */
- (NSString *)errorLog {
    return errorLog;
}
/**
 Perform any and all error checking required by the component - return YES
 if passed
 */
- (BOOL)isClearedToBegin {
    return YES; // this is the default; change as needed
}
/**
 Returns the file name containing the raw data that will be appended to the 
 data file
 */
- (NSString *)rawDataFile {
    return [delegate defaultTempFile]; // this is the default implementation
}
/**
 Perform actions required to recover from crash using the given raw data passed
 as string
 */
- (void)recover {
    // if no recovery is needed, nothing need be done here
}
/**
 Accept assignment for the component definition
 */
- (void)setDefinition: (NSDictionary *)aDictionary {
    definition = aDictionary;
}
/**
 Accept assignment for the component delegate - The component controller will 
 assign itself as the delegate
 Note: The new delegate must adopt the TKComponentBundleDelegate protocol
 */
- (void)setDelegate: (id <TKComponentBundleDelegate> )aDelegate {
    delegate = aDelegate;
}
/**
 Perform any and all initialization required by component - load any nib files
 and perform all required initialization
 */
- (void)setup {

  // CLEAR ERROR LOG
  //////////////////
  [self setErrorLog:@""];
  
  // --- WHAT NEEDS TO BE INITIALIZED BEFORE THIS COMPONENT CAN OPERATE? ---
  /////////////////////////////////////////////////////////////////////////////
  // load audio
  NSString *audioPath = [[NSBundle bundleForClass:[self class]]
                         pathForResource:@"Alarm" ofType:@"wav"];
  audio = [[NSSound alloc] initWithContentsOfFile:audioPath byReference:YES];
  if(!audio) {
    [self registerError:@"Alarm - could not load audio"];
  }
  // LOAD NIB
  ///////////
  if([NSBundle loadNibNamed:RRFAlarmMainNibNameKey owner:self]) {
    // SETUP THE INTERFACE VALUES
    /////////////////////////////
    // set the prompt value
    [promptField setStringValue:[definition valueForKey:RRFAlarmPromptKey]];
  } else { // NIB DID NOT LOAD
    [self registerError:@"Could not load Nib file"];
  }
}
/**
 Return YES if component should perform recovery actions
 */
- (BOOL)shouldRecover {
    return NO;  // this is the default; change if needed
}
/**
 Perform any and all finalization required by component
 */
- (void)tearDown {
    // any finalization should be done here:
    // - remove any temporary data files
}
/**
 Return the name of the current task
 */
- (NSString *)taskName {
    return [definition valueForKey:RRFAlarmTaskNameKey];
}
/**
 Return the main view that should be presented to the subject
 */
- (NSView *)mainView {
    return view;
}

#pragma mark OPTIONAL PROTOCOL METHODS
/** Uncomment and implement the following methods if desired */
/**
 Run header if something other than default is required
 */
//- (NSString *)runHeader {
//
//}
/**
 Session header if something other than default is required
 */
//- (NSString *)sessionHeader {
//
//}
/**
 Summary data if desired
 */
//- (NSString *)summary {
//
//}
        
#pragma mark ADDITIONAL METHODS
/** Add additional methods required for operation */
- (void)registerError: (NSString *)theError {
    // append the new error to the error log
    [self setErrorLog:[[errorLog stringByAppendingString:theError]
                       stringByAppendingString:@"\n"]];
}
/** When the button is clicked... the alarm is over */
- (IBAction)buttonClicked: (id)sender {
  // stop the annoying alarm!!!
  [audio stop];
  // notify our delegate that we are done
  [delegate componentDidFinish:self];
}

#pragma mark Preference Keys
// HERE YOU DEFINE KEY REFERENCES FOR ANY PREFERENCE VALUES
// ex: NSString * const RRFAlarmNameOfPreferenceKey = @"RRFAlarmNameOfPreference"
NSString * const RRFAlarmTaskNameKey = @"RRFAlarmTaskName";
NSString * const RRFAlarmDataDirectoryKey = @"RRFAlarmDataDirectory";
NSString * const RRFAlarmAudioKey = @"RRFAlarmAudio";
NSString * const RRFAlarmAudioDurationKey = @"RRFAlarmAudioDuration";
NSString * const RRFAlarmShouldRequireSequenceKey = @"RRFAlarmShouldRequireSequence";
NSString * const RRFAlarmSequenceKey = @"RRFAlarmSequence";
NSString * const RRFAlarmPromptKey = @"RRFAlarmPrompt";


#pragma mark Internal Strings
// HERE YOU DEFINE KEYS FOR CONSTANT STRINGS //
///////////////////////////////////////////////
NSString * const RRFAlarmMainNibNameKey = @"RRFAlarmMainNib";
        
@end
