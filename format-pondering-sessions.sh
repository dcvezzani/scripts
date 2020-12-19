#/bin/bash

cd /Users/dcvezzani/Dropbox/journal/current

today=$(date +"%Y%m%d")
backup=y

if [ -f "pondering-sessions-${today}.tar" ]; then
  echo "A backup file already exists; do you want to overwrite it? (y/n)"
  read backup
fi
  
if [ "$backup" == 'y' ]; then
  tar cvf "pondering-sessions-${today}.tar" *-pondering-session.md &> /dev/null
fi

prevPondering=''
style=$(cat /Users/dcvezzani/Dropbox/journal/current/20200902-pondering-session-style.md)
indexPageTemplate=$(cat /Users/dcvezzani/Dropbox/journal/current/20200902-pondering-sessions-index-template.md)
indexPage=/Users/dcvezzani/Dropbox/journal/current/20200902-pondering-sessions-index.md

echo "${indexPageTemplate}" > "${indexPage}"

for file in $(ls *-pondering-session.md); do
  fileWithPath="/Users/dcvezzani/Dropbox/journal/current/${file}"
  prefix="${file%%-*}"
  echo "- [${prefix}](${fileWithPath})" >> "${indexPage}"

  if [ ! "$prevPondering" == "" ]; then
    perl -pi -e "s#^.*class=\"prev-pondering\".*#  <div class="prev-pondering"> <a href=\"${prevPondering}\">Prev</a> </div>#g" "${fileWithPath}"
    perl -pi -e "s#^.*class=\"next-pondering\".*#  <div class="next-pondering"> <a href=\"${fileWithPath}\">Next</a> </div>#g" "${prevPondering}"
  fi

  # apply style
  perl -pin -e 'BEGIN {undef $/} s/<style>(.*\n)*<\/style>/'"${style}"'/' "${fileWithPath}"

  # format scripture anchor tag
  perl -pin -e 's/<a class="scripture"[^>]*>([^<]*)<\/a>/<a class="scripture" href="\1" target="_scripture">\1<\/a>/' "${fileWithPath}"

  # update page title
  # title=$(date -jf "%Y%m%d" "${prefix}" "+\"%A,%_d %B %Y %H:%M:%S\"")
  title=$(date -jf "%Y%m%d" "${prefix}" +"%A,%_d %B %Y")
  # perl -pin -e 's/pondering-session/<div class="title">'"${prefix}"'<\/div>/' "${fileWithPath}"

  perl -pin -e 's/^pondering-session$/<div class="title">'"${title}"'<\/div>/' "${fileWithPath}"
  # perl -pin -e 's/<div class="title">[^<]*<\/div>/<div class="title">'"${title}"'<\/div>/' "${fileWithPath}"
  # perl -pn -e 's/<div class="title">[^<]*<\/div>/<div class="title">'"${prefix}"'<\/div>/' /Users/dcvezzani/Dropbox/journal/current/20200909-pondering-session.md
  

  prevPondering="${fileWithPath}"
done



