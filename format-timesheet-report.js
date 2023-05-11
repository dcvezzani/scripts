const fs = require('fs')

// console.log(process.argv[2])

const reportString = fs.readFileSync(`${process.argv[2]}`).toString()
// console.log(reportString)

const week = [], lines = reportString.split(/\n+/)
// console.log(lines)

const report = lines.reduce((obj, line) => {
  if (line.match(/^\d/)) {
    // add work time; associate with specified project
    // console.log(">>>line", line)
    const columns = line.split(/; */)
    let [ project, jiraId ] = columns[1].split(/-/)
    jiraId = `${project}-${jiraId || 'admin'}`
    const hrs = parseFloat(columns[0])
    const entry = {date: obj.currentKey, hrs, project, jiraId, description: columns.slice(2).join('; ')}
    // console.log(">>>entry", entry)
    
    obj.byDay.entries[obj.currentKey].entries.push(entry)

    if (!obj.byDay.entries[obj.currentKey].totals[project])
      obj.byDay.entries[obj.currentKey].totals[project] = 0.0

    obj.byDay.entries[obj.currentKey].totals[project] += hrs
    obj.byDay.entries[obj.currentKey].totals.ztotal += hrs
    obj.byDay.ztotal += hrs


    if (project.match(/^[a-z]/)) {
      jiraId = project
      project = 'admin'
    }


    if (!obj.byProject.entries[project])
      obj.byProject.entries[project] = {days: {}, totals: {ztotal: 0.0}}

    if (!obj.byProject.entries[project].days[obj.currentKey])
      obj.byProject.entries[project].days[obj.currentKey] = {entries: [], totals: { ztotal: 0.0 }}

    obj.byProject.entries[project].days[obj.currentKey].entries.push(entry)

    if (!obj.byProject.entries[project].days[obj.currentKey].totals[jiraId])
      obj.byProject.entries[project].days[obj.currentKey].totals[jiraId] = 0.0

    obj.byProject.entries[project].days[obj.currentKey].totals[jiraId] += hrs
    obj.byProject.entries[project].days[obj.currentKey].totals.ztotal += hrs

    if (!obj.byProject.entries[project].totals[jiraId])
      obj.byProject.entries[project].totals[jiraId] = 0.0

    obj.byProject.entries[project].totals[jiraId] += hrs
    obj.byProject.entries[project].totals.ztotal += hrs
    obj.byProject.ztotal += hrs

  } 
  else if (line.match(/^work-log/)) {
    // create key for day; initialize value as array (of work times grouped by project)
    const key = line.match(/^work-log-([^\.]+)\.md$/)[1]
    // console.log(">>>key", key)
    obj.byDay.entries[key] = {entries: [], totals: { ztotal: 0.0 }}
    obj.currentKey = key
  }

  return obj
}, {byDay: {ztotal: 0.0, entries: {}}, byProject: {ztotal: 0.0, entries: {}}})

const reportFilename = `${process.argv[2].replace(/\.txt$/, '.json')}`
fs.writeFileSync(reportFilename, JSON.stringify(report, null, 2))
console.log(`>>>report written to ${reportFilename}`)
