#!/usr/bin/env bash

REL_SRC=${BASH_SOURCE[0]}
CANONICAL_SRC=$(readlink -f $REL_SRC)
DIR="$(cd -P "$(dirname $CANONICAL_SRC)" && pwd)"


# mail directories, mutt directories and mu directories
mkdir -p ${HOME}/mail/mail
ln -f -s ${HOME}/mail/mail                    ${HOME}/.mail
mkdir -p ${DIR}/mu/{cache,xapian,results,log}
ln -f -s ${DIR}/mu                            ${HOME}/.mu

ln -f -s ${DIR}/mutt                          ${HOME}/.mutt
mkdir -p ${HOME}/Downloads/mutt-attachments

# mutt-open and urlview
ln -f -s ${DIR}/misc-tools/mutt-open          ${HOME}/bin/mutt-open
ln -f -s ${DIR}/misc-tools/urlview            ${HOME}/.urlview

# msmtp
ln -f -s ${DIR}/msmtp/msmtp.rc                ${HOME}/.msmtprc
ln -f -s ${DIR}/msmtp/msmtp.log               ${HOME}/.msmtp.log

# offlineimap
ln -f -s ${DIR}/offlineimap/offlineimap.rc    ${HOME}/.offlineimaprc
ln -f -s ${DIR}/offlineimap/offlineimap.py    ${HOME}/.offlineimap.py

# goobook
ln -f -s ${DIR}/goobook/goobook.rc            ${HOME}/.goobookrc
chmod +x ${DIR}/goobook/goobook_getpass.sh
ln -f -s ${DIR}/goobook/goobook_getpass.sh    ${HOME}/.goobook_getpass.sh
touch ${DIR}/goobook/goobook_cache
ln -f -s ${DIR}/goobook/goobook_cache         ${HOME}/.goobook_cache


read -r -d '' PYCMD <<'EOF'
import keyring
em = raw_input("gmail-email-address> ")
pw = raw_input("gmail-password-onetime> ")
keyring.set_password("localmail-gmail", em, pw)
EOF

python -c "$PYCMD"

