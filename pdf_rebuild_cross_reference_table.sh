#!/bin/zsh

path_to_executable=$(which pdftk)
if [ ! -x "$path_to_executable" ] ; then
  echo "Unable to locate pdftk tool; loading environment"

  # so that AppleScript can set up environment; runs in 'sh' shell by default
  # file references should have been translated from POSIX paths in the AppleScript
  # already
  source ~/.zshrc
fi

#echo "here i am: $@" 1>&2; exit 1
#echo "here i am: $@" >> /var/tmp/myScript.log

if [ $# -gt 0 ] && [ $# -lt 11 ]; then
  BUNDLE_GEMFILE=~/Gemfile bundle exec ruby ~/scripts/pdf_rebuild_cross_reference_table.rb "$@"

else
  echo "======================================
Repair the Cross Reference Table for a Pdf document

Usage: 
~/scripts/pdf_rebuild_cross_reference_table.sh /Users/davidvezzani/Downloads/wip01/invoice-002.pdf
PDF_REBUILD_CROSS_REFERENCE_TABLE_NO_PROMPT=true ~/scripts/pdf_rebuild_cross_reference_table.sh /Users/davidvezzani/Downloads/wip01/invoice-002.pdf

Can handle from 1 to 10 pdf documents at a time.
~/scripts/pdf_rebuild_cross_reference_table.sh /Users/davidvezzani/Downloads/wip01/invoice-002.pdf <file> <file> ...
" 1>&2; exit 1
fi
