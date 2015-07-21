#!/bin/bash

# Example script to set any environment variables for osx worker
# Write the specified variables into a separate script (my_vars.txt used as example)

# Example my_vars.txt content:
# export MY_VAR_1=$MY_VAR_1
# export MY_VAR_2=$MY_VAR_2

# scripts/osx_command.sh will run the following  on the osx worker
# ./scripts/osx_command.sh "cat my_vars.txt >> osx-env-set.sh"
