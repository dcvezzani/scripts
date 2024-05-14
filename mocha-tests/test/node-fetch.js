// Since 2.6.7, node-fetch can only be made available using import (mjs) instead of require (cjs)
// - this wrapper could keep the rest of the code relatively clean until the
//   time comes for the code to fully embrace mjs style imports
module.exports = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));

