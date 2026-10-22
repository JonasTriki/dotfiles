#!/usr/bin/env bash
# macOS defaults. Based on https://github.com/driesvints/dotfiles

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

osascript -e 'tell application "System Settings" to quit' 2>/dev/null

# Ask for sudo once and keep it alive until the script ends.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- General

sudo scutil --set ComputerName "Jonas MacBook Pro"
sudo scutil --set HostName "Jonas MacBook Pro"
sudo scutil --set LocalHostName "jonas-macbook-pro"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "Jonas MacBook Pro"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# No auto-capitalisation, smart dashes/quotes, period substitution or autocorrect.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# --- Keyboard and locale

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain AppleLanguages -array "en_GB"
defaults write NSGlobalDomain AppleLocale -string "nb_NO@currency=NOK"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# systemsetup logs a bogus "Error:-99" even on success, so skip it if already set.
if [[ "$(readlink /etc/localtime)" != */Europe/Oslo ]]; then
  sudo systemsetup -settimezone "Europe/Oslo" 2>&1 | grep -vF 'InternetServices.m' || true
fi

# --- Power and screen

sudo pmset -b displaysleep 5
sudo pmset -c displaysleep 15
sudo pmset -b sleep 5
sudo pmset -c sleep 0
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# --- Dock

defaults write com.apple.dock appswitcher-dock-display -bool true

# --- Finder

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
chflags nohidden ~/Library

# Snap icons to grid. `Set` fails on a fresh install, so fall back to `Add`.
for view in DesktopViewSettings FK_StandardViewSettings StandardViewSettings; do
  /usr/libexec/PlistBuddy -c "Set :$view:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null ||
    /usr/libexec/PlistBuddy -c "Add :$view:IconViewSettings:arrangeBy string grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
done

# --- Safari (needs Full Disk Access for the terminal)

if defaults write com.apple.Safari .probe -bool true 2>/dev/null; then
  defaults delete com.apple.Safari .probe
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
  defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
  defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
else
  echo "Skipping Safari: grant your terminal Full Disk Access to apply it."
fi

# --- Apps

defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

defaults write com.apple.appstore WebKitDeveloperExtras -bool true
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.commerce AutoUpdate -bool true

defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "$HOME/Documents/Torrents"
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false
defaults write org.m0k.transmission CheckRemoveDownloading -bool true
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
defaults write org.m0k.transmission WarningDonate -bool false
defaults write org.m0k.transmission WarningLegal -bool false

mkdir -p ~/Library/Application\ Support/Rectangle
cp "$DOTFILES/init/rectangle.json" ~/Library/Application\ Support/Rectangle/RectangleConfig.json

# --- Restart affected apps

for app in "Activity Monitor" Calendar cfprefsd Contacts Dock Finder "Google Chrome" \
  Mail Messages Photos Safari Rectangle SystemUIServer Terminal Transmission; do
  killall "$app" &>/dev/null
done
echo "Done. Some changes need a logout to take effect."
