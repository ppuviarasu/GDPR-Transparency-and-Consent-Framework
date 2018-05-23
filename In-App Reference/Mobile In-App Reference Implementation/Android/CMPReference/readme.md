Implementation Guide for Android App Publishers

* Drag and drop the classes from the CMPReference/InAppCMPReference library to your project.

* Configure the CMP Reference by providing a set of properties encapsulated in the CMPSettings object. Where:

  * `SubjectToGdpr`: Enum that indicates
    * `CMPGDPRDisabled` - value 0, not subject to GDPR
    * `CMPGDPREnabled` - value 1, subject to GDPR
    * `CMPGDPRUnknown` - value Nil, unset
  * `consentToolURL`: `String url` that is used to create and load the request into the WebView – it is the request for the consent webpage. This property is mandatory.
  * `consentString`: If this property is given, it enforces reinitialization with the given string, configured based on the consentToolURL. This property is optional.
  
```
CMPSettings cmpSettings = new CMPSettings(SubjectToGdpr.CMPGDPREnabled, “https://consentWebPage”, null);
```

* In order to start the `CMPConsentActivity`, you can call the following method: `CMPConsentActivity.showCMPConsentActivity(cmpSettings, context, onCloseCallback);`
* In order to receive a callback when close or done button is tapped, you may use `OnCloseCallback` listener, otherwise pass null as the third parameter to `openCMPConsentToolView()`.
* `SubjectToGdpr`, `consentString` and `cmpPresent` will be stored in SharedPreferences
