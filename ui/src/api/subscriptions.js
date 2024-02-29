import Urbit from '@urbit/http-api'

function subscribeToHits(path, err, event, quit) {
  const api = new Urbit('', '', 'hits')

  return api.subscribe({
    app: 'hits',
    path: path,
    ship: window.ship,
    err: err || {},
    event: event,
    quit: quit || {}
  })
}

export async function subscribeToUiUpdates(event) {
  return await subscribeToHits(
    '/ui-updates',
    () => {console.error('Failed to subscribe to /ui-updates')},
    event,
    () => {console.log('Kicked from /ui-updates')}
  )
}
