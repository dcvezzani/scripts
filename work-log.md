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
V"zy:@z

" Copy command on current line into "q" register (use "w" register for this command)
$v^"qy

" Gather work log entries starting with card number or hours (capital letter)
v/^[A-Z0-9]/d

" get sum of all lines from current line to end of block (\n\n)
" update total for story
maV/\n\n


" ====================================================
" Archive

" {n} Or create placeholder for number of hours
:v/^[A-Z0-9]/d


" {v} Format work log entries for standup
:s/^\([^ ;]\+\)[ ;]\+\([^;]\+\)[ ;]\+\(.*\)/- ◐ \{\1\} \2; \3/g


" {n} Format work log entry (one at a time)
^ma/;

- OR -

" {n} Format single work log entry (prep) and find next
^ma/;

" {n} Format all entries in summary
^maV/\n\n

</div>
