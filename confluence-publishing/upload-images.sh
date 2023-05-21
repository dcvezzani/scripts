#!/bin/bash

filename="$1"

if [[ -z $filename ]]; then
cat << EOL
Usage: ~/scripts/confluence-publishing/upload-images.sh <filename>
EOL
exit 1
fi

echo; cat << EOL
Opening resource in Chrome...
EOL
open -a 'google chrome' "file://${filename}"

echo; cat << 'EOL'
Open inspector, paste in console

console.log(`localSource=JSON.parse('[${Array.from(document.querySelectorAll('img')).map(img => {
const src=`/Users/dcvezzani/Dropbox/journal/${img.getAttribute('src')}`;
const srcPath=img.getAttribute('src');
return `{"src":"${src}","srcPath":"${srcPath}"}`;
}).sort((a, b) => (a.src < b.src) ? -1 : (a.src > b.src) ? 1 : 0).join(",")}]')`);

Example of results:

localSource=JSON.parse('[{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-01.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-01.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-02.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-02.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-03.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-03.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-04.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-04.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-05.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-05.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-06.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-06.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-07.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-07.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-08.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-08.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-09.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-09.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-10.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-10.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-11.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-11.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-12.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-12.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-13.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-13.png"},{"src":"/Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-14.png","srcPath":"images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-14.png"}]')
EOL

echo; cat << 'EOL'
Copy results and paste in console again (eat your own dogfood)
EOL

echo "Hit any key to continue..."
read userInput

echo; cat << 'EOL'
Paste the following in console, copy results

EOL

echo; cat << 'EOL'
console.log(`if [[ -d /tmp/asdf1234 ]]; then rm -r /tmp/asdf1234; fi; mkdir /tmp/asdf1234; cp ${localSource.map(entry => entry.src).join(" ")} /tmp/asdf1234; open /tmp/asdf1234; open https://confluence.churchofjesuschrist.org/pages/resumedraft.action?draftId=149356993&draftShareId=1dbc910d-aa34-46e6-b929-975066cbb175&`);

Example of results:

if [[ -d /tmp/asdf1234 ]]; then rm -r /tmp/asdf1234; fi; mkdir /tmp/asdf1234; cp /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-01.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-02.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-03.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-04.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-05.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-06.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-07.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-08.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-09.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-10.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-11.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-12.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-13.png /Users/dcvezzani/Dropbox/journal/images/14ae1a96-ca54-4c4d-9639-115425fbd0d9-14.png /tmp/asdf1234; open /tmp/asdf1234; open https://confluence.churchofjesuschrist.org/pages/resumedraft.action?draftId=149356993&draftShareId=1dbc910d-aa34-46e6-b929-975066cbb175&
EOL

echo "Hit any key to continue..."
read userInput

echo; cat << 'EOL'
Paste the following into terminal to collect images and copy to temp directory
- open folder
- open Confluence to edit a document, open inspector > console

Select files from finder window, drag into Confluence document
- should be sorted in ascending order

Paste into the inspector console
1. localSource definition from previous browser window
2. the following code

substitutions=Array.from(document.querySelectorAll('#tinymce img')).map(img => {
const src=`${document.location.origin}${img.getAttribute('src')}`;
return {src};
}).map((entry, index) => {
const re = /\//g;
return `s/${localSource[index].srcPath.replaceAll(re, '\\\/')}/${entry.src.replaceAll(re, '\\\/')}/g`
});
console.log(`perl -p -i -e '${substitutions.join("; ")}' /Users/dcvezzani/Dropbox/journal/current/20230511-lambda-testing-with-the-serverless-appli.md`)

Example of results:

perl -p -i -e 's/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-01.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-01.png?version=5&modificationDate=1683842387044&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-02.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-02.png?version=5&modificationDate=1683842387554&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-03.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-03.png?version=5&modificationDate=1683842388088&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-04.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-04.png?version=5&modificationDate=1683842388807&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-05.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-05.png?version=5&modificationDate=1683842389289&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-06.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-06.png?version=5&modificationDate=1683842389786&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-07.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-07.png?version=5&modificationDate=1683842390141&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-08.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-08.png?version=5&modificationDate=1683842390353&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-09.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-09.png?version=7&modificationDate=1683842390839&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-10.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-10.png?version=5&modificationDate=1683842391226&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-11.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-11.png?version=5&modificationDate=1683842391514&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-12.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-12.png?version=5&modificationDate=1683842391970&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-13.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-13.png?version=5&modificationDate=1683842392198&api=v2/g; s/images\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-14.png/https:\/\/confluence.churchofjesuschrist.org\/download\/attachments\/149356869\/14ae1a96-ca54-4c4d-9639-115425fbd0d9-14.png?version=5&modificationDate=1683842392798&api=v2/g' /Users/dcvezzani/Dropbox/journal/current/20230511-lambda-testing-with-the-serverless-appli.md

EOL

echo "Hit any key to continue..."
read userInput

echo; cat << 'EOL'
Copy and paste results into terminal window, publish to Confluence
EOL

