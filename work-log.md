## work log {date}

### What am I spending my time on?


#### 7:00


#### 8:00


#### 9:00


#### 10:00


#### 11:00


#### 12:00


#### 13:00


#### 14:00


#### 15:00


#### 16:00


#### 17:00


### Summary


<div style="display: none; ">

" ====================================================
" Create summary of work (projected or recorded) to be included in standup

" Copy command on line; results are the only thing left in the document; then paste after "Summary"
V"zy:@zVgg"xyu/SummaryA"xp

" Copy command on current line into "q" register (use "w" register for this command)
$v^"qy

" Gather work log entries starting with card number or hours (capital letter)
v/^[A-Z0-9]/d

" get sum of all lines from current line to end of block (\n\n)
" update total for story
maV/\n\n:s/^\( *\)- \([^;]\+\);.*/\2/gv:!/Users/dcvezzani/scripts/add.shv$h"zyu?^\dv/;hx"zP


" ====================================================
" Archive

" {n} Or create placeholder for number of hours
:v/^[A-Z0-9]/dggVG:s/^/1 ;/


" {v} Format work log entries for standup
:s/^\([^ ;]\+\)[ ;]\+\([^;]\+\)[ ;]\+\(.*\)/- ◐ \{\1\} \2; \3/g


" {n} Format work log entry (one at a time)
^ma/;dwindwikA, ENDV:s/.*/ ç\0ç/V:s/, */ç\r ç/gmbjdd`ajp`aJxJxV`b:!column -t -s'ç'gv:s/^  *END$///^\d

- OR -

" {n} Format single work log entry (prep) and find next
^ma/;dwindwikA, ENDV:s/.*/ ç\0ç/V:s/, */ç\r ç/gmbjdd`ajp`aJxJx`b/^\d

" {n} Format all entries in summary
^maV/\n\nmbgv:!column -t -s'ç'gv:s/^  *END$//i````aO```

</div>

