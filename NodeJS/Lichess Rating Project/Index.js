const axios = require('axios');

/* Create your personal token on https://lichess.org/account/oauth/token */
const personalToken = 'SfRMjC1EasxvWzzQ';

axios.get('/api/games/user/watsa01', {
  baseURL: 'https://lichess.org/',
  headers: { 'Authorization': 'Bearer ' + personalToken }
}).then(
  console.log,
  err => console.error(err.message)
);