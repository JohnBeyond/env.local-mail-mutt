#!/usr/bin/env bash

DIR="$(cd -P "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"

mkdir -p "${HOME}/.cache/rss2maildir" "${HOME}/.config/rss2maildir"  "${HOME}/.localmail-custom"
cp --no-clobber "${DIR}/feeds.json.sample" "${HOME}/.localmail-custom/feeds.json"
ln -f -s -n "${HOME}/.localmail-custom/feeds.json" "${HOME}/.config/rss2maildir/feeds.json"

NDIR_NAME="news"
MUTTROOT="${HOME}/comm/mutt"
NDIR_TRUE="${HOME}/comm/.news"
NDIR_LINKS="${MUTTROOT}/${NDIR_NAME}"
NDIR_GLOBAL="${HOME}/.news"

mkdir -p "${NDIR_TRUE}" "${NDIR_LINKS}"
ln -f -s -n "${NDIR_TRUE}" "${NDIR_GLOBAL}"

maildir-feed "${NDIR_GLOBAL}"  # assumes that maildir-feed is already installed and on PATH

CNT=0
rm -f "${NDIR_LINKS}"/*   # removing all links before trying to install new ones.
for n in $(ls -A1 "${NDIR_TRUE}"); do
    ln -f -s -n "${NDIR_TRUE}/${n}" "${NDIR_LINKS}/$(printf %02d ${CNT})_$(echo ${n} | sed 's/^.//')"
    (( CNT++ ))
done


# Now, create the news-mailboxes file and mutt-news.rc
NEWSBOXES_FILE="${DIR}/mailboxes-news"
NEWSRC="${DIR}/mutt-news.rc"

echo $(ls -A1 "${NDIR_LINKS}") > "${NEWSBOXES_FILE}-dirs"
cp "${NEWSBOXES_FILE}-dirs"  "${NEWSBOXES_FILE}"

# mailboxes-news
sed -i "s/ \(.\)/ +${NDIR_NAME}\/\1/g"  "${NEWSBOXES_FILE}"  # cheesy whitespace handling
sed -i "s/\(.\)/ +${NDIR_NAME}\/\1/"    "${NEWSBOXES_FILE}"

# mutt-news.rc
RCPREFIX="macro index,pager gw"
RCSUFFIX="<enter>\" \"go news\""
SYNCLINE="macro index O \"<shell-escape>timeout --preserve-status 30s maildir-feed ${NDIR_GLOBAL}<enter>\" \"synchronize news\""

tr " " "\n" < "${NEWSBOXES_FILE}-dirs" > "${NEWSRC}"  # cheesy whitespace handling
sed -i "s/\(^[0-9]\+\)\(.*\)/${RCPREFIX}\1 \"<change-folder>+${NDIR_NAME}\/\1\2${RCSUFFIX}/g" "${NEWSRC}"
echo "${SYNCLINE}" >> "${NEWSRC}"

rm "${NEWSBOXES_FILE}-dirs"

