"
" Given a block of text formatted in markdown for standup notes, generate a plain text version for
" pasting in Slack channel.
"
" Usage
"
" Highlight markdown of daily standup notes and invoke one of the following commands.
"
"   :SNC    export plain text version to clip board
"   :SNC2   export plain text version to clip board *and* replace highlighted text
"
" Example
"
"   2016-10-13 - Dave V
"   -------------------
"
"   1. [130472613](https://www.pivotaltracker.com/story/show/130472613) 8070-submitting-products-to-amazon-isnt-generating-asins
"   2. [130497471](https://www.pivotaltracker.com/story/show/130497471) incorrect information entered for the Canadian sales tax
"   3. [131695597](https://www.pivotaltracker.com/story/show/131695597) [SL] Swap DNS for Catalog
"   4. [131695779](https://www.pivotaltracker.com/story/show/131695779) [SL] Move NFS to Soft Layer
"   5. [131816043](https://www.pivotaltracker.com/story/show/131816043) [CATALOG] Catalog Object
"
"   #### Yesterday:
"   * attempted to finish setting up ice-nfs [4:move-nfs]
"   * created checklist for hosts that use nfs; will use when migrating to ice-nfs [4:move-nfs]
"   * deployed Canadian tax fix to production [2:canada-tax]
"   * continued dialog with Jerad and Ruth [1:asin]
"   * asked Katelyn and catalog team to test out catalog-staging [5:catalog-obj]
"   * schedule a date with Marcelo to go over new stories, filter tasks that can wait [5:catalog-obj]
"
"   #### Today:
"   * issues reported for catalog-staging; will investigate [3:catalog-dns]
"   * nurse rsync along for nfs [4:move-nfs]
"   * create script to point all nfs-using hosts to ice-nfs [4:move-nfs]
"
"   #### <img src="https://cloud.githubusercontent.com/assets/218810/19271504/cd66ab20-8f79-11e6-8992-3c78abe7ddc0.png" alt="Attention!" style="vertical-align: middle;"> Blockers:
"   * waiting for response from Dan/Ruth re: Amazon; contact information for manufacturers [1:asin]
"   * [some hosts](https://www.pivotaltracker.com/story/show/131695779/comments/152385177) are not available via ssh; needs resolution to complete nfs transition [4:move-nfs]
"   * address new stories re: catalog object -- now or later? [5:catalog-obj]
"
" Gets converted to
"
"   2016-10-13 - Dave V
"   -------------------
"
"   1. 130472613 8070-submitting-products-to-amazon-isnt-generating-asins
"   2. 130497471 incorrect information entered for the Canadian sales tax
"   3. 131695597 [SL] Swap DNS for Catalog
"   4. 131695779 [SL] Move NFS to Soft Layer
"   5. 131816043 [CATALOG] Catalog Object
"
"   Yesterday:
"   - attempted to finish setting up ice-nfs [4:move-nfs]
"   - created checklist for hosts that use nfs; will use when migrating to 
"     ice-nfs [4:move-nfs]
"   - deployed Canadian tax fix to production [2:canada-tax]
"   - continued dialog with Jerad and Ruth [1:asin]
"   - asked Katelyn and catalog team to test out catalog-staging 
"     [5:catalog-obj]
"   - schedule a date with Marcelo to go over new stories, filter tasks that 
"     can wait [5:catalog-obj]
"
"   Today:
"   - issues reported for catalog-staging; will investigate [3:catalog-dns]
"   - nurse rsync along for nfs [4:move-nfs]
"   - create script to point all nfs-using hosts to ice-nfs [4:move-nfs]
"
"   Blockers:
"   - waiting for response from Dan/Ruth re: Amazon; contact information for 
"     manufacturers [1:asin]
"   - some hosts are not available via ssh; needs resolution to complete nfs 
"     transition [4:move-nfs]
"   - address new stories re: catalog object -- now or later? [5:catalog-obj]
"
"
" Parameters (optional)
"
"   replace_inline     string:arg:1    'true' | 'false' - indicate if you wish to replace the
"                                      highlighted text with the function results or to simply copy to
"                                      clip board. The option that replaces the text still puts the
"                                      values in the clip board.
"
" Variables
"
"   cur_col_width      integer         when a line is being hard wrapped, this is the length of the
"                                      current line segment
"                                      the first line segment should be flush with the left margin
"                                      the following line segments should be indented by @indent_str
"   cur_row            integer         this function will iterate through each highlighted line
"                                      @cur_row represents the current line being processed
"                                      the line is stored in a local variable and mutated there instead
"                                      of directly in-line
"
"   cur_wrap           integer         counter used to avoid infinite loops for processing a single line
"   fnd                integer         index position in #strpart(@new_line) where the last space is
"                      integer         found before the cur_col_width
"   indent_cols        integer         number of indent columns that should be prepended to paragraph
"                                      lines > 1
"
"   indent_str         string          characters that should be prepended to paragraph lines > 1.
"                                      Typically spaces.
"   line_segment       string          after the @cur_row is saved and mutated in a local variable, this
"                                      represents a slice of @new_line that should fit in the specified
"                                      cur_col_width
"   max_col            integer         define the width of text before hard wrapping
"
"   max_row            integer         max number of iterations allowed before exiting loop. Prevents
"                                      accidental infinite loops based relative to the value of @cur_row
"   max_wrap           integer         max number of iterations allowed before exiting loop. Prevents
"                                      accidental infinite loops
"   new_line           string          the line being mutated. Should be stored in a list (array) and
"                                      rendered at the end of function
"
"   new_line_length    integer         length of the line *after* mutation
"   new_lines          list:string     queue of lines to be rendered at the end of function
"   offset             integer         while hard-wrapping a single line, this keeps track of the
"                                      current column location
"   offset_len         integer         used to determine how to slice the string and where to advance
"                                      the next offset value
"
"   origPos            list:integer    base position in vim document. Mostly just using to capture the
"                                      buffer index.
"   re_header          regexp:string   cleans off the mark down headers
"   re_img             regexp:string   cleans off any html img tag
"   re_link            regexp:string   cleans off the mark down links
"   re_ul              regexp:string   cleans off the mark down list item markers
"
"   start_row          integer         specifies the line where the selection begins
"   stop_row           integer         specifies the line where the selection ends
"
"
" Returns
"
"   $SNC               string          string formatted in a more plain fashion; used to store value 
"                                      before pushing to clip board
"
"
" These notes formatted using: 
"   * set formatprg=/usr/local/bin/par\ -w100p35
"   * !column -t -s\;
"   
    
function! StandupNotesWrap(...)

  " ### USER PREFERENCES
  "
  " set with of 'page' before hard wrapping beings
  let max_col = 75

  " guard against infinite loops; it doesn't seem likely that a single line
  " will need to be wrapped more than 25 times
  let max_wrap = 25

  " characters that will compose the hanging indent
  let indent_str = '  '

  " ### DONE: USER PREFERENCES
  

  " ensure starting in normal mode
  let @z = '' | normal @z

  " remember row positions of highlighted text
  let start_row = line("'<")
  let stop_row = line("'>")
  
  " keep track of which row is being processed
  let cur_row = start_row

  " not expecting to process a status block consisting of more than 200 lines
  let max_row = (cur_row + 200)
  let new_lines = []
  let indent_cols = strlen(indent_str)

  " regular expressions used to strip out mark down syntax
  let re_link = ['^\([^\[]\+\)\[\([^\]]\+\)\](\([^)]\+\))\(.*\)$', '\1\2\4']
  let re_header = ['^#* ', '']
  let re_img = ['<img src=[^>]\+> ', '']
  let re_ul = ['^\* ', '- ']

  " check optional function parameter; defaults to 'false'
  let replace_inline = 0
  if(a:0 > 0 && (a:1 == 'true'))
    let replace_inline = 1
  endif
  
  " Process each line in turn
  " If the line length goes beyond the @max_wrap threshold, the line 
  " will be converted to multiple lines, formatted with @indent_str
  " The first line length should be based on @max_col.
  " The subsequent line lengths should be based on @max_col minus
  " strlen(@indent_str).
  "
  " Loop until either 
  "   - all rows have been processed or 
  "   - the @max_row threshold has been breached (likely marking an infinite loop)
  "
  while ((cur_row < (stop_row+1)) && (cur_row < max_row))
    let new_line = getline(cur_row)

    " clean out mark down from line
    let new_line = substitute(new_line, re_link[0],   re_link[1],   "")
    let new_line = substitute(new_line, re_header[0], re_header[1], "")
    let new_line = substitute(new_line, re_img[0],    re_img[1],    "")
    let new_line = substitute(new_line, re_ul[0],     re_ul[1],     "")

    " prep for hard-wrapping the mutated line
    let new_line_length = strlen(new_line)
    let offset = 0
    let origPos = getpos('.')
    let cur_col_width = max_col
    let cur_wrap = 0

    " the current line has content
    if (new_line_length > 0)

      " Loop while
      "   - the offset pointer isn't past the length of the mutated string, @new_line
      "   - what's left of the mutated string is longer than @cur_col_width
      "   - not marked as an infinite loop
      "
      while ((offset < new_line_length) && ((new_line_length - offset) > cur_col_width ) && (cur_wrap < max_wrap))

        " find the index of the character just before the last space in the substring
        let fnd = match(strpart(new_line, offset, cur_col_width), '\( \)\@<=[^ ]*$')

        " determine the substring
        let offset_len = (fnd - offset)
        let line_segment = strpart(new_line, offset, offset_len)

        " Start adding processed lines into 'out' queue
        " The first time through for a given original line, modify @cur_col_width
        " so that it accounts for the hanging indentation.
        if offset == 0
          let cur_col_width = cur_col_width - indent_cols
          call add(new_lines, line_segment)

        " For subsequent hard-wraps, prepend the value of @indent_str
        else
          call add(new_lines, indent_str.line_segment)
        endif
        
        let offset = offset + offset_len
        let cur_wrap = cur_wrap + 1
      endwhile

    " the current line is empty, but still needs to be represented
    else
      call add(new_lines, '')
    endif


    " Check to see if there is any content left over; chances are
    " there is
    if ((new_line_length - offset) > 0)
      let line_segment = strpart(new_line, offset, (new_line_length - offset))

      " Exactly what's added depends on how many times the @new_line has been
      " hard-wrapped
      if cur_wrap < 1
        call add(new_lines, line_segment)
      else
        call add(new_lines, indent_str.line_segment)
      endif
    endif

    " advance to the next row to be processed
    let cur_row = cur_row + 1
  endwhile

  " if the option was selected to replace the highlighted text
  "   - 'replace' the selected lines with the ones highlighted
  if replace_inline == 1
    let cur_row = start_row

    while cur_row < (stop_row+1)
      d
      let cur_row = cur_row + 1
    endwhile

    call append(line('.')-1, new_lines)
  endif
  
  " store queued lines in shell environment variable
  let $SNC = join(new_lines, "\n")

  " don't show function results in vim 'console'
  silent! echo $SNC
  
endfunction

:command! -range SNC  :call StandupNotesWrap() | :r!echo "$SNC" | pbcopy
:command! -range SNC2 :call StandupNotesWrap('true') | :r!echo "$SNC" | pbcopy



function! StandupNotesCleanup(...)
  let @z = '' | normal @z
  let start_row = line("'<")
  let stop_row = line("'>")
  let cur_row = start_row
  let max_row = (cur_row + 200)
  let new_lines = []
  let replace_inline = 0

  let re_link = ['^\([^\[]\+\)\[\([^\]]\+\)\](\([^)]\+\))\(.*\)$', '\1\2\4']
  let re_header = ['^#* ', '']
  let re_img = ['<img src=[^>]\+> ', '']
  let re_ul = ['^\* ', '- ']

  if(a:0 > 0 && (a:1 == 'true'))
    let replace_inline = 1
  endif

  " let g1 = [cur_row, stop_row]
  
  while ((cur_row < (stop_row+1)) && (cur_row < max_row))
    let new_line = getline(cur_row)
    " call add(g1, new_line)
    let new_line = substitute(new_line, re_link[0],   re_link[1],   "")
    let new_line = substitute(new_line, re_header[0], re_header[1], "")
    let new_line = substitute(new_line, re_img[0],    re_img[1],    "")
    let new_line = substitute(new_line, re_ul[0],     re_ul[1],     "")

    call add(new_lines, new_line)

    if replace_inline == 1
      call setline(cur_row, new_line)
    endif

    " call add(g1, new_line)
    let cur_row = cur_row + 1
  endwhile

  let $SNC = join(new_lines, "\n")
  silent! echo $SNC
  
  " let @g = join(g1)
endfunction
" :command! -range SNC  :call StandupNotesCleanup() | :r!echo "$SNC" | pbcopy
" :command! -range SNC2 :call StandupNotesCleanup('true') | :r!echo "$SNC" | pbcopy

