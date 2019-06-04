#import "Macros.h"

/******************************
        
    EXAMPLE PROJECT MOD MENU TEMPLATE

    GAME: Bowmasters
    Version: 2.14.2

*******************************/


//public void KillCharacter(); // RVA: 0x101949634 Offset: 0x1949634
void(*KillCharacter)(void *this_) = (void(*) (void *))getRealOffset(0x101949634);

bool shouldActivateKillAll = true;

void(*old_CharacterBase_UpdateCharacter)(void *characterBase, float deltaTime);
void CharacterBase_UpdateCharacter(void *characterBase, float deltaTime) {

  //private bool isAI; // 0x221
  //private bool <IsMultiplayerEnemy>k__BackingField; // 0x228
  bool isEnemy = *(bool*)((uint64_t)characterBase + 0x221);
  bool IsMultiplayerEnemy = *(bool*)((uint64_t)characterBase + 0x228);

  if(isEnemy || IsMultiplayerEnemy) {

    // One Hit Kill
    if([switches isSwitchOn:@"Kill Enemy"]) {
      if(shouldActivateKillAll) {
        KillCharacter(characterBase);
        shouldActivateKillAll = false;
      }
    } else {
      shouldActivateKillAll = true;
    }
  }

  if(!isEnemy && !IsMultiplayerEnemy) {
    
    if([switches isSwitchOn:@"God Mode"]) {
      //protected float health; // 0x48
      *(float*)((uint64_t)characterBase + 0x48) = 999999999.0f;
    }
  }

  old_CharacterBase_UpdateCharacter(characterBase, deltaTime);
}

int(*old_get_coins)(void *this_);
int get_coins(void *this_) {

  int userAmount = [[switches getValueFromSwitch:@"Custom Coins:"] intValue];

  if([switches isSwitchOn:@"Custom Coins:"]) {
    return userAmount;
  }

  return old_get_coins(this_);
}

int(*old_get_Gems)(void *this_);
int get_Gems(void *this_) {

  int userAmount = [[switches getValueFromSwitch:@"Custom Gems:"] intValue];

  if([switches isSwitchOn:@"Custom Coins:"]) {
    return userAmount;
  }

  return old_get_Gems(this_);
}

void setup() {

  //public virtual void UpdateCharacter(float deltaTime); // RVA: 0x10194DE30 Offset: 0x194DE30 -> CharacterBase
  HOOK(0x10194DE30, CharacterBase_UpdateCharacter, old_CharacterBase_UpdateCharacter);

  //public int get_Coins(); // RVA: 0x1018A3DA0 Offset: 0x18A3DA0
  HOOK(0x1018A3DA0, get_coins, old_get_coins);

  //public int get_Gems(); // RVA: 0x1018A3F24 Offset: 0x18A3F24
  HOOK(0x1018A3F24, get_Gems, old_get_Gems);

    [switches addTextfieldSwitch:@"Custom Coins:"
                description:@"Here you can enter your own coins amount!"
                  inputBorderColor:[UIColor colorWithRed:0.74 green:0.00 blue:0.00 alpha:1.0]];

    [switches addTextfieldSwitch:@"Custom Gems:"
                description:@"Here you can enter your own coins amount!"
                  inputBorderColor:[UIColor colorWithRed:0.74 green:0.00 blue:0.00 alpha:1.0]];                    

    [switches addSwitch:@"God Mode"
                description:@"You can't die!"];

    [switches addSwitch:@"Kill Enemy"
                description:@"Kills the enemy. Disable it after using, then use it again when you want to."];    

    [switches addOffsetSwitch:@"No Shity Ads"
                description:@"Title says it all ^_^"
                  offsets:{0x10184866C}
                    // Get Bytes Here: http://shell-storm.org/online/Online-Assembler-and-Disassembler/
                    bytes:{"\x20\x00\x80\x52\xc0\x03\x5f\xd6"}];                  


}


/*
     
     You can customize the menu here
     Good site for specific UIColor: https://www.uicolor.xyz/#/rgb-to-ui
     NOTE: remove the ";" when you copy your UIColor from there!
     
     Site to find your perfect font for the menu: http://iosfonts.com/  --> view on mac or ios device

     See comment next to maxVisibleSwitches!!!!
     
*/
void setupMenu() {

  menu = [[Menu alloc]  initWithTitle:@"Bowmaster - Mod Menu"
                        titleColor:[UIColor whiteColor]
                        titleFont:@"Copperplate-Bold"
                        credits:@"This Mod Menu has been made by Ted2, do not share this without proper credits or my permission. \nEnjoy!"
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
      [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"https://iosgods.com"]];
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
            subTitle:@"Bowmaster - Mod Menu \n\nThis Mod Menu has been made by Ted2, do not share this without proper credits or my permission. \nEnjoy!" 
              closeButtonTitle:nil
                duration:99999999.0f];

  });
}


%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}