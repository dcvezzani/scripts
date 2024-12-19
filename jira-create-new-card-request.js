#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

const getAtlDate = () => {
  const date = new Date();
  const formatter = new Intl.DateTimeFormat('en-US', { day: '2-digit', month: 'short', year: '2-digit' });
  const [noop, month, day, year] = Array.from(formatter.format(date).match(/^([^ ]+) ([^,]+), (.+)/))
  console.log(`${day}/${month}/${year}`);
  return `${day}/${month}/${year}`
}

const ATL_TOKEN = process.env.ATL_TOKEN // || 'ALBC-WBTK-JOOD-IAPB_f5d8b6d611964e5dc8095bfda52925a1568c1638_lin'
const ATL_DATE_CREATED = process.env.ATL_DATE_CREATED || getAtlDate()
  // "customfield_10500": "18/Jun/24",
const ATL_EPIC_ID = process.env.ATL_EPIC_ID

const fetch = (...args) => import('node-fetch/src/index.js').then(({default: fetch}) => fetch(...args))

const split = require('split');
const input = process.stdin.pipe(split());
const output = process.stdout;

const RE = {
  dataRaw: /^ +--data-raw \$*'(.+)'$/,
  wwwFormUrlEncoded: /application\/x-www-form-urlencoded/,
  contentType: /^ *-H 'Content-Type: /,
  summary: /^## (.*)/,
  empty: /^$/,
  acceptanceCriteria: /^### Acceptance criteria/,
  table: /^\|/,
}

const state = {
  lines: {
    summary: null,
    description: [],
    acceptanceCriteria: [],
  },
  capturing: null, // summary | description | acceptanceCriteria
  table: null,
}

const stateMachine = line => {
  if (state.capturing === null && RE.summary.test(line)) {
    return state.capturing = 'summary'
  }
  else if (state.capturing === 'summary' && RE.empty.test(line)) {
    return state.capturing = 'description'
  }
  else if (state.capturing === 'description' && RE.acceptanceCriteria.test(line)) {
    return state.capturing = 'acceptanceCriteria'
  }
  else if (state.capturing === 'description') {
    if (state.table === null && RE.table.test(line)) {
      state.table = 'header'
    }
    else if (state.table === 'header') {
      state.table = 'header-separator'
    }
    else if (state.table === 'header-separator') {
      state.table = 'body'
    }
    else if (state.table === 'body' && RE.empty.test(line)) {
      state.table = null
    }
  }
}

const capture = {
  summary: (line) => {
    const md = line.match(RE.summary)
    const _summary = md && md[1]
    if (!!_summary) state.capturing = 'description'
    return _summary
  },
  // description: (line) => {
  //   if (state.capturing === 'summary' && RE.empty.test(line)) {
  //     state.capturing = 'description'
  //   }
  // },
  // acceptanceCriteria: (line) => {
  //   if (state.capturing === 'description' && RE.acceptanceCriteria.test(line)) {
  //     state.capturing = 'acceptanceCriteria'
  //   }
  // },
}

const updateCategory = (line, category) => {
  if (
    (
      !RE.hasOwnProperty(category)
      || !RE[category].test(line)
    )
    && (
      state.lines[category].length > 0
      || !RE.empty.test(line)
    )
  ) {
    if (RE.table.test(line)) {
      updateTable(line, category)
    } 
    else {
      state.lines[category].push(line)
    }
  }
}

const updateTable = (line, category) => {
  if (state.table === 'header') {
    line = line.replaceAll(/\|/g, '||')
    state.lines[category].push(line)
  }
  else if (state.table === 'body') {
    state.lines[category].push(line)
  }
}

// const updateAcceptanceCriteria = (line) => {
//   if (
//     !RE.acceptanceCriteria.test(line)
//     && (
//       state.lines.acceptanceCriteria.length > 0
//       || !RE.empty.test(line)
//     )
//   ) state.lines.acceptanceCriteria.push(line)
// }

const serializeDescription = (description=[]) => {
  return description.join("\/n\/r").replaceAll(/'/g, "\\'")
}

const serializeValue = (content=[]) => {
  if (typeof content === 'string') content = [content]
  return content.join("\/n\/r").replaceAll(/(["])/g, "\\$1").replaceAll(/\\(?![nr"])/g, '')
}

const jsonToFormUrlEncoded = obj => {
  const urlSearchParams2 = new URLSearchParams()
  for (const [key, value] of Object.entries(obj)) {
    if (Array.isArray(value)) {
      value.forEach(v => 
        urlSearchParams2.append(key, v)
      )
    } else {
      urlSearchParams2.set(key, value)
    }
  }
  let formUrlEncoded = urlSearchParams2.toString()
  .replaceAll(/%2Fn%2Fr/g, '%0D%0A')

  return formUrlEncoded
}

const requestCreateCard = async (body) => {
  try {
    const response = await fetch("https://jira.churchofjesuschrist.org/secure/QuickCreateIssue.jspa?decorator=none", {
      "headers": {
        "accept": "*/*",
        "accept-language": "en-US,en;q=0.9",
        "cache-control": "no-cache",
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Cookie": `_fbp=fb.1.1716993857281.596763294; PFpreferredHomepage=COJC; _bti=%7B%22app_id%22%3A%22church-of-jesus-christ-of-latter-day-saints%22%2C%22bsin%22%3A%22dUrmzyBhXzdBUqNMSkHarxQHBuCvc77pM4vDIaA4G6syAMWMCjRuB9LwHOzPcg6I5h5UD39QJ8GTzNU6IS3Iqw%3D%3D%22%2C%22is_identified%22%3Afalse%7D; header-test-running=true; at_check=true; AMCVS_66C5485451E56AAE0A490D45%40AdobeOrg=1; s_cc=true; RT="z=1&dm=churchofjesuschrist.org&si=77997d2c-d90f-4d30-a9ad-39847a3eceb2&ss=lxkkalft&sl=0&tt=0"; notice_behavior=implied|us; BIGipServerpool_jira.churchofjesuschrist.org_HTTP=1013660938.36895.0000; mbox=PC#1c2dfec09ddd4a1f9b7cc1a04d60192d.35_0#1781988307|session#fbb38e05965b41a1bd4470a59c865728#1718745367; s_plt=6.96; s_pltp=deseret-trust%3Ahome; s_ips=768; s_tp=5130; s_ppv=deseret-trust%253Ahome%2C15%2C15%2C15%2C768%2C6%2C1; adcloud={%22_les_v%22:%22c%2Cy%2Cchurchofjesuschrist.org%2C1718745306%22}; AMCV_66C5485451E56AAE0A490D45%40AdobeOrg=179643557%7CMCIDTS%7C19892%7CMCMID%7C69123944408262232880165845341588939027%7CMCAAMLH-1719348306%7C9%7CMCAAMB-1719348306%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1718750706s%7CNONE%7CvVersion%7C5.5.0; JSESSIONID=0DF6057FCB7A2DAF78374C99EC167733; atlassian.xsrf.token=${ATL_TOKEN}`,
        "pragma": "no-cache",
        "sec-ch-ua": "\"Google Chrome\";v=\"125\", \"Chromium\";v=\"125\", \"Not.A/Brand\";v=\"24\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"macOS\"",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "x-ausername": "dcvezzani",
        "x-requested-with": "XMLHttpRequest"
      },
      "referrer": "https://jira.churchofjesuschrist.org/secure/RapidBoard.jspa?rapidView=2155",
      "referrerPolicy": "strict-origin-when-cross-origin",
      body,
      "method": "POST",
      "mode": "cors",
      "credentials": "include"
    });

    if (!response.ok) throw `Unable to create new card`

    const json = await response.json()
    return json.issueKey || null

  } catch(error) {
console.error(">>>dcv (jira-create-new-card-request.js, , error:130)", error)
    return error
  }
}

input.on('data', line => {
  stateMachine(line)

  if (state.capturing === 'summary') {
    state.lines.summary = capture.summary(line)
  }
  else if (state.capturing === 'description') updateCategory(line, 'description')
  else if (state.capturing === 'acceptanceCriteria') updateCategory(line, 'acceptanceCriteria')
});

input.on('end', async () => {
  // console.log(state.lines.summary)
  // console.log(state.lines.description)
  // console.log(state.lines.acceptanceCriteria)

  let payload = require('fs').readFileSync(`/Users/dcvezzani/Dropbox/journal/current/20240618-new-issue-no-attachments.json`).toString()

  payload = payload.replace(/\$\{atlToken\}/, ATL_TOKEN)
  payload = payload.replace(/\$\{summary\}/, serializeValue(state.lines.summary))
  payload = payload.replace(/\$\{description\}/, serializeValue(state.lines.description))
  payload = payload.replace(/\$\{acceptanceCriteria\}/, serializeValue(state.lines.acceptanceCriteria))

  payload = payload.replace(/\$\{ATL_DATE_CREATED\}/, serializeValue(ATL_DATE_CREATED))
  payload = payload.replace(/\$\{ATL_EPIC_ID\}/, serializeValue(ATL_EPIC_ID))

  // require('fs').writeFileSync(`/Users/dcvezzani/Dropbox/journal/current/20240618-asdf.json`, payload)
  // console.log(">>>dcv (jira-create-new-card-request.js, , payload:87)", jsonToFormUrlEncoded(JSON.parse(payload)))

  // process.stdout.write
  // console.log(jsonToFormUrlEncoded(JSON.parse(payload)))
  
  const body = jsonToFormUrlEncoded(JSON.parse(payload))
  const issueKey = await requestCreateCard(body)

  const cardUrl = `https://jira.churchofjesuschrist.org/browse/${issueKey}`
// console.log("\n>>>dcv (jira-create-new-card-request.js, , cardUrl:164)", cardUrl)
  console.log(`- ${cardUrl}`)
})

input.on('error', error => {
  console.error('Error', error)
})

/*
/Users/dcvezzani/Dropbox/journal/current/20240618-new-issue-no-attachments.json

$summary



  "summary": "${summary}",
  "description": "${description}",
  "customfield_10327": "${acceptanceCriteria}",




cat << 'EOL' | ATL_TOKEN='ALBC-WBTK-JOOD-IAPB_f5d8b6d611964e5dc8095bfda52925a1568c1638_lin' /Users/dcvezzani/scripts/jira-create-new-card-request.js
## [FE] Port api endpoints over to new application (meetings; 1 of 5)

In the previous version, node express was used to power these endpoints.  Next.js api routes will be used in this next version.

As part of this card, port the following api routes.  These should be all the routes that are related to meeting entities.

| method | route                                  | protected      | Category | Service(s) entry point                   | Notes |
|--------|----------------------------------------|----------------|----------|------------------------------------------|-------|
| post   | "/api/admin/meetings/:id/archive",     | ensureSignedIn | secure   | meetingService.archive                   |       |
| post   | "/api/admin/meeting/create",           | ensureSignedIn | secure   | meetingService.createMeeting             |       |
| get    | "/api/admin/meetings/hostingUnits",    | ensureSignedIn | secure   | meetingService.getHostingUnits           |       |

As part of this story, use or create happy path tests to capture the json response payload of the original api call and save it somewhere.  Use this payload and the request inputs to verify the new code is behaving as it should.

### Acceptance criteria
- inputs and outputs of the original api call should be the same as the new implementation
EOL


*/



