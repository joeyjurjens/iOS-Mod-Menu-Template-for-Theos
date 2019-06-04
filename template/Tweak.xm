#import "Macros.h"


void setup() {

  // Empty switch - usefull with hooking!
  [switches addSwitch:@"Anti Ban"
              description:@"You can't get banned, keep this enabled!"];

  // Offset Switch with one patch
  [switches addOffsetSwitch:@"God Mode"
              description:@"You can't die!"
                offsets:{0x1005AB148}
                  // Get bytes here: http://shell-storm.org/online/Online-Assembler-and-Disassembler/
                  bytes:{"\x00\xe0\xbf\x12\xc0\x03\x5f\xd6"}];

  // Offset switch with multiply patches
  [switches addOffsetSwitch:@"One Hit Kill"
              description:@"You can't die!"
                offsets:{0x1001BB2C0, 0x1002CB3B0}
                  // Get Bytes Here: http://shell-storm.org/online/Online-Assembler-and-Disassembler/
                  bytes:{"\x00\xe0\xbf\x12\xc0\x03\x5f\xd6", "\xc0\x03\x5f\xd6"}];

  // Textfield Switch - used in hooking!
  [switches addTextfieldSwitch:@"Custom Gold: "
              description:@"Here you can enter your own gold amount!"
                inputBorderColor:[UIColor colorWithRed:0.74 green:0.00 blue:0.00 alpha:1.0]];
    
  // Slider Switch - used in hookinh!
  [switches addSliderSwitch:@"Custom Move Speed: "
              description:@"Set your custom move speed!"
                minimumValue:0
                  maximumValue:10
                    sliderColor:[UIColor colorWithRed:0.74 green:0.00 blue:0.00 alpha:1.0]];                                                                                          
}


/*
     
     You can customize the menu here
     Good site for specific UIColor: https://www.uicolor.xyz/#/rgb-to-ui
     NOTE: remove the ";" when you copy your UIColor from there!
     
     Site to find your perfect font for the menu: http://iosfonts.com/  --> view on mac or ios device

     See comment next to maxVisibleSwitches!!!!
     
*/
void setupMenu() {

  menu = [[Menu alloc]  initWithTitle:@"@@APPNAME@@ - Mod Menu"
                        titleColor:[UIColor whiteColor]
                        titleFont:@"Copperplate-Bold"
                        credits:@"This Mod Menu has been made by @@USER@@, do not share this without proper credits or my permission. \nEnjoy!"
                        headerColor:[UIColor colorWithRed:0.74 green:0.00 blue:0.00 alpha:1.0]
                        switchOffColor:[UIColor darkGrayColor]
                        switchOnColor:[UIColor colorWithRed:0.00 green:0.68 blue:0.95 alpha:1.0]
                        switchTitleFont:@"Copperplate-Bold"
                        switchTitleColor:[UIColor whiteColor]
                        infoButtonColor:[UIColor colorWithRed:0.74 green:0.00 blue:0.00 alpha:1.0]
                        maxVisibleSwitches:4 // Less than max -> blank space, more than max -> you can scroll!
                        menuWidth:250];    


    //once menu has been initialized, run the setup functions (here you'll generate the switches).
    setup();
}

/*
    If the menu button doesn't show up; Change the timer to a bigger amount.
*/
static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {

  timer(5) {

    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];

    // Website link, remove it if you don't need it.
    [alert addButton: @"Visit Me!" actionBlock: ^(void) {
      [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"@@SITE@@"]];
      timer(2) {
        setupMenu();
      });        
    }];

    [alert addButton: @"Thankyou, understood." actionBlock: ^(void) {
      timer(2) {
        setupMenu();
      });
    }];    

    alert.shouldDismissOnTapOutside = NO;
    alert.customViewColor = [UIColor purpleColor];  
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromCenter;   
    
    [alert showSuccess: nil
            subTitle:@"@@APPNAME@@ - Mod Menu \n\nThis Mod Menu has been made by @@USER@@, do not share this without proper credits or my permission. \n\nEnjoy!" 
              closeButtonTitle:nil
                duration:99999999.0f];

  });
}


%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}