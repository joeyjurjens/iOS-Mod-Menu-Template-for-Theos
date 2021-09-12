# iOS Mod Menu Template for Theos!

<div style="text-align: center;">
<b>Sample UI of the Menu:</b><br>

<img src="https://i.imgur.com/f20XTb4.png">
</div>

<br>

### Features:
* Customizable UI
* Customizable menu & button image icon
* 4 types of switches:
  * Offset Patcher Switch
  * Empty Switch
  * Textfield Switch
  * Slider Switch

* Backend Offset Patcher Switch is based on [KittyMemory](https://github.com/MJx0/KittyMemory)
  * Original bytes are **not** required
  * Supports MSHookMemory
  * Write unlimited bytes to a offset

* Compile-time string encryption
* Open Source Menu

<br>

### Installation:

You can download the template here: [Latest Release](https://github.com/joeyjurjens/iOS-Mod-Menu-Template-for-Theos/releases/latest). <br>
**iOS**
1. In the makefile on line 22, you've to set the path to your SDK. This menu has been tested with the "iPhoneOS11.2.sdk" SDK from [theos/sdks](https://github.com/theos/sdks)
2. I use initializer_list in this project, iOS doesn't have this included by itself. You can download it [**here**](https://raw.githubusercontent.com/joeyjurjens/iOS-Mod-Menu-Template-for-Theos/977e9ff2c626d6b1308eed7e17f1daf0a610e8e9/template/KittyMemory/initializer_list), save it as "initializer_list" and copy the file to: "$THEOS/sdks/iPhoneOS11.2.sdk/usr/include/c++/4.2.1/" <br>

**MacOS:**
1. Install xCode if you haven't already.
1. In the Makefile of the project, change "MOBILE_THEOS=1" to "MOBILE_THEOS=0" <br>

### Menu setup:

**Changing the menu images**
Inside the **Tweak.xm**, you'll setup the menu under the function "setupMenu". 
Here you'll see two options under the menu: menuIcon & menuButton, those require a base64 image string.
In order to get a base64 string from the image, upload the image here: https://www.browserling.com/tools/image-to-base64

Images 50x50 are recommended, you can get a sample of my images by copying the standard(in tweak.xm) base64 string & use this website to show the picture: https://base64.guru/converter/decode/image

**Setting a framework as executable**
You can set this in the function setupMenu() inside Tweak.xm
```obj-c
[menu setFrameworkName:"FrameworkName"];
```

### Menu usage:

**Encryption**

A quick note before showing all the switch examples; You can and *should* encrypt offsets, hexes, c-strings and NSStrings. Below you can find the proper syntax per string-type.

**Offsets:**
```c
ENCRYPTOFFSET("0x10047FD90")
```

**Hexes:**
```c
ENCRYPTHEX("0x00F0271E0008201EC0035FD6")
```

**C-strings:**
```c
ENCRYPT("I am a c-string")
```

**NSStrings:**
```c
NSSENCRYPT("Copperplate-Bold")
```

<b> Patching a offset without switch: </b>
```c
patchOffset(ENCRYPTOFFSET("0x1002DB3C8"), ENCRYPTHEX("0xC0035FD6"));
patchOffset(ENCRYPTOFFSET("0x10020D2D4"), ENCRYPTHEX("0x00008052C0035FD6"));
// You can write as many bytes as you want to an offset
patchOffset(ENCRYPTOFFSET("0x10020D3A8"), ENCRYPTHEX("0x00F0271E0008201EC0035FD6"));
// or  
patchOffset(ENCRYPTOFFSET("0x10020D3A8"), ENCRYPTHEX("00F0271E0008201EC0035FD6"));
// spaces are fine too
patchOffset(ENCRYPTOFFSET("0x10020D3A8"), ENCRYPTHEX("00 F0 27 1E 00 08 20 1E C0 03 5F D6"));
```


<b> Offset Patcher Switch: </b>
```obj-c
  [switches addOffsetSwitch:NSSENCRYPT("One Hit Kill")
    description:NSSENCRYPT("Enemy will die instantly")
    offsets: {
      ENCRYPTOFFSET("0x1001BB2C0"),
      ENCRYPTOFFSET("0x1002CB3B0"),
      ENCRYPTOFFSET("0x1002CB3B8")
    }
    bytes: {
      ENCRYPTHEX("0x00E0BF12C0035FD6"),
      ENCRYPTHEX("0xC0035FD6"),
      ENCRYPTHEX("0x00F0271E0008201EC0035FD6")
    }
  ];
```

<b> Empty Switch: </b>
```obj-c
[switches addSwitch:NSSENCRYPT("Masskill")
  description:NSSENCRYPT("Teleport all enemies to you without them knowing")
];
```
<b> Textfield Switch: </b>
```obj-c
[switches addTextfieldSwitch:NSSENCRYPT("Custom Gold")
  description:NSSENCRYPT("Here you can enter your own gold amount")
  inputBorderColor:UIColorFromHex(0xBD0000)
];
```
<b> Slider Switch: </b>
```obj-c
[switches addSliderSwitch:NSSENCRYPT("Custom Move Speed")
  description:NSSENCRYPT("Set your custom move speed")
  minimumValue:0
  maximumValue:10
  sliderColor:UIColorFromHex(0xBD0000)
];
```
<b> Checking if a switch is on:
```obj-c
bool isOn = [switches isSwitchOn:NSSENCRYPT("Switch Name Goes Here")];
if(isOn) {
  //Do stuff
}

//Or check directly:
if([switches isSwitchOn:NSSENCRYPT("Switch Name Goes Here")]) {
    // Do stuff
}
```
<b> Getting textfield or slider value: </b>
```obj-c
int userValue = [[switches getValueFromSwitch:NSSENCRYPT("Switch Name Goes Here")] intValue];
float userValue2 = [[switches getValueFromSwitch:NSSENCRYPT("Switch Name Goes Here")] floatValue];
```

### Credits:
* Me
* [MJx0](https://github.com/MJx0)
  * For [KittyMemory](https://github.com/MJx0/KittyMemory)
  * For contributions
* [bR34Kr](https://github.com/bR34Kr)
  * For contributions
* [dogo](https://github.com/dogo)
  * For [SCLAlertView](https://github.com/dogo/SCLAlertView)
* [Rednick16](https://github.com/Rednick16)
  * For contributions
* [busmanl30](https://github.com/busmanl30)
  * For contributions
