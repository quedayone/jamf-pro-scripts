#!/bin/sh

# Variables
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

applicationTitle="Hot Corners" # Firefox no .app
#
customTrigger="main_hotCorners" # The name of the cuntom Trigger for the Provisiong policy:  provision_firefox
#
# appPath="/Applications/Adobe Acrobat DC" ## Leave blank if /Applacations
#
appIcon="/System/Library/PreferencePanes/Expose.prefPane/Contents/Resources/Expose.icns" ## Find the icon name in: "/"$appPath"/"$applicationTitle".app/Contents/Resources/
#
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
#
jh_icon="/System/Library/PreferencePanes/Dock.prefPane/Contents/Resources/Dock.icns"
#
jamfPath="/usr/local/jamf/bin/jamf"
#
title="Colle McVoy Provisioning Bot 5000"
##########- DONT NOT EDIT BELOW THIS LINE -########## ###############
dateStamp=$( date "+%a %b %d %H%M%S" )
#
log=/Users/Shared/Provisiong-log.txt
#
appPath="${appPath:-Applications}"
#
log=/Users/Shared/Provisiong-log.txt
#
app_IconPath="/"$appPath"/"$applicationTitle".app/Contents/Resources/$appIcon"
## Verbose
echo "######### ##########"
echo "App Title is:" $applicationTitle
echo "Custom Trigger is:" $customTrigger
echo "App Icon is: $appIcon"
echo "Applacation path is: $appPath"
echo "######### ##########"
###################################
# Main Application Install #
###################################
/bin/echo "######### ##########" >> $log
/bin/echo "Installing: $applicationTitle" >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Installing:" -description "$applicationTitle" -icon "$jh_icon" &
/usr/local/jamf/bin/jamf policy -trigger $customTrigger
#
version=$(defaults read /Users/$loggedInUser/Library/Preferences/com.apple.dock.plist wvous-bl-corner)
echo $applicationTitle "versions is:" $version
botomRight=$(defaults read /Users/$loggedInUser/Library/Preferences/com.apple.dock.plist wvous-br-corner)
echo "Botom right is:" $botomRight
if [[ $botomRight == "2" ]]; then
    botomRightSet="Mission Control"
    echo "Bottom Right Set is:" $botomRight
else
    botomRightSet= 'NOT SET'
fi

if [[ $version == *"5"* ]]; then
	# Setting is set
    botomLeft="Start screen saver"
    /bin/echo "$applicationTitle $version - Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "Installed" -description "$applicationTitle Botom Left = $botomLeft Botom Right = $botomRightSet" -icon "$appIcon" &
	sleep 5
    killAll jamfHelper
	
else
	# App is installed
    /bin/echo "$applicationTitle install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "ERROR:" -description "$applicationTitle install FAILED" -icon "$app_icon" &
	sleep 5
    killAll jamfHelper
	
fi
/bin/echo >> $log
exit 0
###################################


