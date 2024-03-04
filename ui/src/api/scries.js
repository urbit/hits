import Urbit from '@urbit/http-api';

function scryHits(path) {
  const api = new Urbit('', '', 'hits')
  return api.scry({ app: 'hits', path: path })
}

export async function scryBaseVersion() {
  const response = await scryHits(`/base-version`)
  return response.version
}
