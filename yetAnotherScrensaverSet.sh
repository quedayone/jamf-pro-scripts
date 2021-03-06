#!/bin/sh

#  
# Get user logged into console and put into variable "user"
user=`ls -l /dev/console | cut -d " " -f 4`
osMajor=$(sw_vers -productVersion | awk -F"." '{print $2}')
osMinor=$(sw_vers -productVersion | awk -F"." '{print $3}')


sudo -u $user defaults -currentHost write com.apple.screensaver CleanExit -string "YES"
sudo -u $user defaults -currentHost write com.apple.screensaver PrefsVersion -int 100
sudo -u $user defaults -currentHost write com.apple.screensaver showClock -string "NO"
sudo -u $user defaults -currentHost write com.apple.screensaver idleTime -int 600


if [[ $osMajor -eq 14 ]] && [[ $osMinor -ge 2 ]]; then

sudo -u $user defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "iLifeSlideshows" path -string "/System/Library/Frameworks/ScreenSaver.framework/PlugIns/iLifeSlideshows.appex" type -int 0

else

sudo -u $user defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "iLifeSlideshows" path -string "/System/Library/Frameworks/ScreenSaver.framework/Resources/iLifeSlideshows.saver" type -int 0
fi

sudo -u $user defaults -currentHost write com.apple.screensaver tokenRemovalAction -int 0

sudo -u $user defaults -currentHost write com.apple.ScreenSaverPhotoChooser LastViewedPhotoPath -string ""
sudo -u $user defaults -currentHost write com.apple.ScreenSaverPhotoChooser SelectedFolderPath -string "/Users/Shared/ScreenSaverPhotos"
sudo -u $user defaults -currentHost write com.apple.ScreenSaverPhotoChooser SelectedSource -int 3

sudo -u $user defaults -currentHost write com.apple.ScreenSaver.iLifeSlideShows styleKey -string "Classic"

sudo killall -hup cfprefsd