#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

cookieHeader='Cookie: mywork.tab.tasks=false; JSESSIONID=927B43173D67A995B151A55AB06326A8; F5_ST=1z1z1z1690823330z86340; LastMRH_Session=c055bc73; MRHSession=b0006a351b7df6f219cbf122c055bc73; checkuser=true; mbox=PC#811f28ab18d447faa6f1c398e75e7d45.35_0#1753128655|session#6d5b85f3f54049a0bbdbd00e929584f7#1689885757; adcloud={%22_les_v%22:%22y%2Cchurchofjesuschrist.org%2C1689885695%22}; AMCV_66C5485451E56AAE0A490D45%40AdobeOrg=179643557%7CMCIDTS%7C19559%7CMCMID%7C42709063369997651052539458539074364076%7CMCAAMLH-1690488656%7C9%7CMCAAMB-1690488656%7C6G1ynYcLPuiQxYZrsz_pkqfLG9yMXBpb2zX5dvJdYQJzPXImdj0y%7CMCOPTOUT-1689891056s%7CNONE%7CvVersion%7C5.5.0%7CMCAID%7CNONE; newMenusToast=hide; PFpreferredHomepage=COJC'

cookieHeader=process.argv[2]

const stripLabel = (cookieHeader) => {
  return cookieHeader.trim().replace(/^[^:]+: /, '')
}

const parseCookies = (cookieHeader) => {
  return cookieHeader.split(/; /).reduce((coll, keyValue) => {
    const [key, value] = keyValue.split(/=/)
    coll[key] = value
    return coll
  }, {})
}

const {JSESSIONID, MRHSession} = parseCookies(stripLabel(cookieHeader))

process.stdout.write(JSON.stringify({JSESSIONID, MRHSession})) // no newline
