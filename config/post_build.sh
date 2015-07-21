#!/bin/bash

# Solano CI post_build hook

echo "\$TDDIUM_BUILD_STATUS = $TDDIUM_BUILD_STATUS" # Possible values: passed, failed, error

# Example post_build actions on passed:
# Sign app with provisioning profile
# Deploy app to internal testers or TestFlight
