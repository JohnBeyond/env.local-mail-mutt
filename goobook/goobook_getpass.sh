#!/usr/bin/env python

import keyring
import os

with open(os.path.expanduser('~/.localmail-custom/username-gmail'), 'r') as localmail_username_file:
    localmail_username = localmail_username_file.read()

print keyring.get_password("localmail-gmail", localmail_username)
