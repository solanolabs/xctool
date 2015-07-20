Changes in Xcode 6 disallow launching the iOS simulator through the default SSH daemon. The simulator now requires an Aqua session type, which cannot be provided by a LaunchDaemon (https://developer.apple.com/library/mac/technotes/tn2083/_index.html#//apple_ref/doc/uid/DTS10003794-CH1-TABLE1).

Two product-agnostic workarounds to this issue are to use osascript to launch a terminal in the user’s GUI space and run a proxy script, and having a secondary LaunchAgent SSH daemon. The second workaround is much more consistent with most users existing workflow: 

The contents of this directory are mostly inspired by https://gist.github.com/xfreebird/93901ce603cbe087329e (linked from https://github.com/facebook/xctool/issues/404)

OS X workspace setup instructions:
The build user must always have an active GUI session: login as the user and disable auto-logoff and power saving features. 
Run any installed versions of XCode in order to accept the licensing agreements (this can be done via the shell, but would get repetitive for every build script).
Open up and run the iPhone/iOS Simulator(s) in XCode (again for potential license agreements). Right click on Xcode.app -> Show Package Contents -> Contents -> Applications -> ___ Simulator

Needs the following environment variables set:
$TDDIUM_REPO_ROOT   # Repo root on Solano linux worker (should be set automatically)
$OSX_REMOTE_DIR     # Repo root on OSX 
$SOLANO_SSH_PORT    # Defaults to 2222 if not set

Run setup.sh in pre_setup hook to have the files sed/cp into the correct place

To enable secondary ssh: launchctl load -wF $OSX_REMOTE_DIR/.solano-ssh/com.solanolabs.custom_sshd.plist
To disable secondary: launchctl unload $OSX_REMOTE_DIR/.solano-ssh/com.solanolabs.custom_sshd.plist
