import Urbit from '@urbit/http-api';

function scryHits(path) {
  const api = new Urbit('', '', 'hits')
  return api.scry({ app: 'hits', path: path })
}

export async function scryAppDocket(ship, desk) {
  return await scryHits(`/${ship}/${desk}/docket`)
}

export async function scryAppInstalls(ship, desk) {
  return await scryHits(`/${ship}/${desk}/installs`)
}

export async function scryAppScore(ship, desk) {
  return await scryHits(`/${ship}/${desk}/score`)
}

export async function scryAppVersion(ship, desk) {
  return await scryHits(`/${ship}/${desk}/version`)
}

export async function scryRankings() {
  return await scryHits('/rankings')
}
