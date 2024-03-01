import Urbit from '@urbit/http-api';

function scryHits(path) {
  const api = new Urbit('', '', 'hits')
  return api.scry({ app: 'hits', path: path })
}

export async function scryAppDocket(ship, desk) {
  const response = await scryHits(`/${ship}/${desk}/docket`)
  return response.docket
}

export async function scryAppInstalls(ship, desk) {
  const response = await scryHits(`/${ship}/${desk}/installs`)
  return response.installs
}

export async function scryAppScore(ship, desk) {
  const response = await scryHits(`/${ship}/${desk}/score`)
  return response.score
}

export async function scryAppVersion(ship, desk) {
  const response = await scryHits(`/${ship}/${desk}/version`)
  return response.version
}

export async function scryBaseVersion() {
  const response = await scryHits(`/base-version`)
  return response.version
}

export async function scryRankings() {
  const response = await scryHits('/rankings')
  return response.rankings
}
