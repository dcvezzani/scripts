// graphviz-endpoint-relationships-config.js

module.exports = {
  defaults: {
    fontname: "Courier"
  },

  files: {
    byResource: "./by-resource-02.json",
    byEndpoint: "./by-endpoint-02.json",
    graphvizConfig: "./graphviz-config.json",
    graphvizDot: "./graphviz.dot",
  },

  grep: {
    tokens: [
      "/temples/version",
      "/temples/login|/login|loginUrl|loginPath",
      "/temples/auth/login|/auth/login",
      "/temples/auth/logout|forceLogoutAndRevoke|logout_url|logoutUrl|logoutPath|logoutUrl",
      "/temples/userinfo",
      "/temples/isSignedIn",
      "/temples/introspect",
      "/temples/sessKeys",
      "/temples/sessions",
      "/temples/invalidateUserSession",
      "/temples/config",
      "/temples/feConfig",
      "/temples/httpResponseLocals",
      "/temples/oidc",
      "/temples/debug",
      "/temples/schedule/appointment",
      "/temples/prayer-roll|/prayer-roll|getPrayerRoll",
      "/temples/submit-prayer-roll-names|/submit-prayer-roll-names|submitPrayerRollNames",
      "/temples/post-email",
      "/temples/my-temple",
      "/temples/details-note",
      "/temples/list|/list|getListPage",
      "/navigation|getSubNav",
      "/temples/open-houses|/open-house|getOpenHousesPage",
      "/temples/dedicatory-prayer",
      "/temples/details|/details|getTempleDetailsPage",
      "/temples/schedule",
      "/temples/map",
      "/logged-in",
      "/temples/photo-gallery|/photo-gallery|getPhotoGallery",
      "/temples/news-and-events|/events|getNewsPage",
      "getMapPage",
      "/temples/errorData/|/errorData/",
      "templesHomePage|homePagePath|getHomePage|/homepage|templesHomepage",
      "/temples/_next",
      "/dynamic-content|getDynamicPage",
      "/email/post|postEmail",
      "/pubhub|getTempleOrdinanceStrings",
    ],
    dirs: [
      "components",
      "pages",
      "server",
      "lib",
      "public",
      "config",
    ],
  },

  colors: {
    pink: 'pink',
    blue: '#a8eafd',
    yellow: '#fdf8a8',
    green: '#d8fda8',
    orange: '#fdcda8',
    purple: '#a8aafd',
  },
  
  patterns: {
    components: {token: 'components', color: '$colors.yellow'},
    pages: {token: 'pages', color: '$colors.green'},
    routes: {token: 'routes', color: '$colors.orange'},
    services: {token: 'services', color: '$colors.purple'},
  },
  
  endpoints: {
    defaults: {
      shape: "box",
      style: "filled",
      fillcolor: '$colors.pink',
    },
    nodes: [
      {label: "/temples/dynamic-content"},
      {label: "/temples/email/post"},
    ],
  },

  resources: {
    defaults: {
      fillcolor: '$colors.blue',
    },
    nodes: [
      {label: "server/routes/postProcess.js", fillcolor: "#fdcda8"},
      {label: "server/services/api.js", fillcolor: "#a8aafd", id: 'node_server_services_api_js_01'},
    ],
  },

  relationships: {
    defaults: {
      color: '$colors.blue',
      fillcolor: 'black',
      dir: 'both',
      arrowtail: 'box',
    },
    edges: [
      {
        nodes: [
          {name: 'server/routes/postProcess.js'}, 
          '/temples/dynamic-content',
        ],
        color: '#fdcda8',
      },
      {
        nodes: [
          {id: 'node_server_services_api_js_01'}, 
          {name: '/temples/dynamic-content'},
        ],
        color: '#fdcda8',
      },
    ],
  },
}



