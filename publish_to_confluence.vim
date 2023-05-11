function! PublishToConfluence(...)
  if (a:0 > 0)
    let pageType = a:1
  else
    let pageType = 'dev'
    let titleLine = search('^#+ ', 'n')
    let titleLineContent = getline(titleLine+1)
    if titleLineContent =~ '^#\+ standup '
      let pageType = 'stand'
    endif
  endif

  let baseFilename = '/Users/dcvezzani/scripts/confluence-publishing'

  let publish = baseFilename . '/publish-to-confluence.sh ' . pageType
  " let publish = 'cat /Users/dcvezzani/Dropbox/journal/current/20230426-asdf.json'
  let getUrl = baseFilename . '/get-url.sh'

  " Execute shell command and capture output
  redir @z
  " silent execute '!' . publish . ' % | ' . getUrl . ' | jq -r ''.url'''
  silent execute '!' . publish . ' %'
  redir END

  " let payload = substitute(''.@z, '^\n\+', '', 'g')
  " echo @z

  " Clean up output so that only the url remains
  " - should be the last line
  let lines = split(@z, '\n')
  echo lines[len(lines)-1]
  " call setline('.', lines)
endfunction

function! OpenInConfluence(pageType)
  let baseFilename = '/Users/dcvezzani/scripts/confluence-publishing'

  let publish = baseFilename . '/publish-to-confluence.sh ' . a:pageType
  " let publish = 'cat /Users/dcvezzani/Dropbox/journal/current/20230426-asdf.json'
  let getUrl = baseFilename . '/get-url.sh'

  " Execute shell command and capture output
  redir @z
  silent execute '!VIEW_ONLY=true ' . publish . ' % | ' . getUrl . ' | jq -r ''.url'''
  redir END

  " let payload = substitute(''.@z, '^\n\+', '', 'g')
  " echo @z

  " Clean up output so that only the url remains
  " - should be the last line
  let lines = split(@z, '\n')
  echo lines[len(lines)-1]
endfunction

:command! Cnp            :call PublishToConfluence()

:command! Cndp            :call PublishToConfluence('developers-blog')
:command! Cnsp            :call PublishToConfluence('standup')

:command! Cndo            :call OpenInConfluence('developers-blog')
:command! CNFso            :call OpenInConfluence('standup')

:command! CNPublishDevnote   :call PublishToConfluence('developers-blog')
:command! CNPublishStandup   :call PublishToConfluence('standup')

:command! CNOpenDevnote      :call OpenInConfluence('developers-blog')
:command! CNOpenStandup      :call OpenInConfluence('standup')

