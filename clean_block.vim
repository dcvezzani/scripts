function! CleanBlock() range
  let origPos = getpos('.')

	let startLine = line("'<")
	let endLine = line("'>")

  let newPos = [origPos[0], startLine, 0, origPos[3]]
  call setpos('.', newPos)

	let states = {}
	let events = {}
	let viewLines = []

	let currentState = ''
	let currentEvent = ''
	let currentTransition = ''

	"echo "startLine: " . string(startLine)
	for i in range(startLine,endLine)
	  let line = getline(i)
			"echo "line: " . line

		if( match(line, '^	function ') == 0 )
			" state name
			"echo "found state name"

			if( currentState != '' )
				let states[currentState] = events
			endif 

			let events = {}
			let currentState = ''
			let currentState = substitute(line, '^	function \([^(]\+\).*', '\1', 'g')
			"echo "found state name: " . currentState

		elseif( match(line, '^		this.') == 0 )
			" state event
			"echo "found state event"

			let currentEvent = ''
			let currentEvent = substitute(line, '^		this.\([^ ]\+\).*', '\1', 'g')
			"echo "found state event: " . currentEvent

			let events[currentEvent] = []

			call add(viewLines, currentState . ' -> ' . currentEvent)

		elseif( match(line, 'transition(') > 0 )
			" transition
			"echo "found state transition"

			let currentTransition = ''
			let currentTransition = substitute(line, '.*transition(\"\([^\"]\+\).*', '\1', 'g')
			"echo "found state transition: " . currentTransition
			call add(events[currentEvent], currentTransition)

			call add(viewLines, currentEvent . ' -> ' . SnakeToCamelCase(currentTransition))
			
		else
			" skip
		endif
	endfor

	if( currentState != '' )
		let states[currentState] = events
	endif 

	"dump the associative array with state, event and transition info
	"echo states

	"pull out all the transitions; will need to de-duplicate afterwards 
	"('sort -u')
	"call GetTransitions(states)

	"add viewLines to document
	call FormatBlock(viewLines, (startLine - 1))

	"remove source content (original content)	
  let newPos = [origPos[0], startLine + len(viewLines), 0, origPos[3]]
  call setpos('.', newPos)
	let @z = string(endLine - startLine) . 'dd' | normal @z
endfunction

function! MapStatesOnly() range
  let origPos = getpos('.')

	let startLine = line("'<")
	let endLine = line("'>")

  let newPos = [origPos[0], startLine, 0, origPos[3]]
  call setpos('.', newPos)

	let states = {}
	let events = {}
	let viewLines = []

	let currentState = ''
	let currentEvent = ''
	let currentTransition = ''

	"echo "startLine: " . string(startLine)
	for i in range(startLine,endLine)
	  let line = getline(i)
			"echo "line: " . line

		if( match(line, '^	function ') == 0 )
			" state name
			"echo "found state name"

			if( currentState != '' )
				let states[currentState] = events
			endif 

			let events = {}
			let currentState = ''
			let currentState = substitute(line, '^	function \([^(]\+\).*', '\1', 'g')
			"echo "found state name: " . currentState

		elseif( match(line, '^		this.') == 0 )
			" state event
			"echo "found state event"

			let currentEvent = ''
			let currentEvent = substitute(line, '^		this.\([^ ]\+\).*', '\1', 'g')
			"echo "found state event: " . currentEvent

			let events[currentEvent] = []

			"call add(viewLines, currentState . ' -> ' . currentEvent)

		elseif( match(line, 'transition(') > 0 )
			" transition
			"echo "found state transition"

			let currentTransition = ''
			let currentTransition = substitute(line, '.*transition(\"\([^\"]\+\).*', '\1', 'g')
			"echo "found state transition: " . currentTransition
			call add(events[currentEvent], currentTransition)

			"call add(viewLines, currentEvent . ' -> ' . SnakeToCamelCase(currentTransition))
			call add(viewLines, currentState . ' -> ' . SnakeToCamelCase(currentTransition))
			
		else
			" skip
		endif
	endfor

	if( currentState != '' )
		let states[currentState] = events
	endif 

	"call GetTransitions(states)

	"call XFormatBlock(states)

	"echo viewLines
	call FormatBlock(sort(viewLines), (startLine - 1))

	call append((startLine + len(viewLines) - 1), '')
	
	let stateDefinitionsWithTransitions = DefineStateTransitions(states)
	call FormatBlock(sort(stateDefinitionsWithTransitions), (startLine + len(viewLines)))

	"remove source content
  let newPos = [origPos[0], startLine + len(viewLines) + len(stateDefinitionsWithTransitions) + 1, 0, origPos[3]]
  call setpos('.', newPos)
	let @z = string(endLine - startLine + 2) . 'dd' | normal @z
endfunction

function! SnakeToCamelCase(...)
	let transition = a:1
	let camelCaseTransition = substitute(transition, '\%(\%(\k\+\)\)\@<=_\(\k\)', '\u\1', 'g')
	let camelCaseTransition = substitute(camelCaseTransition, '^\w', '\u\0', 'g')
	return camelCaseTransition
endfunction

function! DefineStateTransitions(...)
	let viewLines = []
	let states = a:1
	let allTransitions = []
	let byTransitions = {}

	let statesConsolidatedTransitions = {}
	for state in keys(states)
		let statesConsolidatedTransitions[state] = []
		let events = get(states, state)
		for event in keys(events)
			let transitions = get(events, event)

			if(len(transitions) > 0)
				for transition in transitions
					let camelCaseTransition = SnakeToCamelCase(transition)
					if ! has_key(byTransitions, camelCaseTransition)
						let byTransitions[camelCaseTransition] = []
					endif

					call add(byTransitions[camelCaseTransition], state)
					call add(statesConsolidatedTransitions[state], transition)
				endfor
			endif
		endfor
	endfor

	for state in keys(statesConsolidatedTransitions)
		let transitions = uniq(sort(statesConsolidatedTransitions[state]))
		let translatedTransitions = []
		for transition in transitions
			call add(translatedTransitions, SnakeToCamelCase(transition))
		endfor
		let translatedTransitions = uniq(sort(translatedTransitions))

		let inTransitions = []
		if has_key(byTransitions, state)
			let inTransitions = byTransitions[state]
		endif
		let inTransitions = uniq(sort(inTransitions))

		if( len(inTransitions) > 0 && len(translatedTransitions) > 0 )
			call add(viewLines, state . ' [label="' . state . '\n\nOUT:\n' . join(translatedTransitions, '\n') . '\n\nIN:\n' . join(inTransitions, '\n') . '"];')
		elseif( len(translatedTransitions) > 0 )
			call add(viewLines, state . ' [label="' . state . '\n\nOUT:\n' . join(translatedTransitions, '\n') . '"];')
		elseif( len(inTransitions) > 0 )
			call add(viewLines, state . ' [label="' . state . '\n\nIN:\n' . join(inTransitions, '\n') . '"];')
		else
			call add(viewLines, state . ' [label="' . state . '"];')
		endif
	endfor
	
	return viewLines
endfunction

function! FormatBlock(...)
	let viewLines = a:1
	let startLine = a:2

  let origPos = getpos('.')
  let newPos = [origPos[0], startLine, 0, origPos[3]]
  call setpos('.', newPos)
	
	let offset = 0
	for viewLine in viewLines 
		"echo viewLine
		call append(line('.') + offset, '	' . viewLine)
		let offset = offset + 1
	endfor
endfunction

function! GetTransitions(...)
	let states = a:1
	let allTransitions = []
	for state in keys(states)
		let events = get(states, state)
		for event in keys(events)
			let transitions = get(events, event)
			for transition in transitions
				let camelCaseTransition = substitute(transition, '\%(\%(\k\+\)\)\@<=_\(\k\)', '\u\1', 'g')
				let camelCaseTransition = substitute(camelCaseTransition, '^\w', '\u\0', 'g')
				call add(allTransitions, camelCaseTransition)
			endfor
		endfor
	endfor
	let @z = join(allTransitions, "\n")
endfunction

function! XFormatBlock(...)
	let states = a:1
	for state in keys(states)
		let events = get(states, state)
		for event in keys(events)
			let transitions = get(events, event)
			echo transitions
		endfor
	endfor
endfunction

"vmap <buffer> qxx :call CleanBlock()<CR>
vmap <buffer> qxx :call MapStatesOnly()<CR>

