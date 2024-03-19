import Urbit from '@urbit/http-api'

function subscribeToUrbit(app, path, err, event, quit) {
  const api = new Urbit('', '', app)

  return api.subscribe({
    app: app,
    path: path,
    ship: window.ship,
    err: err || {},
    event: event,
    quit: quit || {}
  })
}

export async function subscribeToCharges(event) {
  return await subscribeToUrbit(
    'docket',
    '/charges',
    () => {console.error('Failed to subscribe to /charges')},
    event,
    () => {console.log('Kicked from /charges')}
  )
}

export async function subscribeToUiUpdates(event) {
  return await subscribeToUrbit(
    'hits',
    '/ui-updates',
    () => {console.error('Failed to subscribe to /ui-updates')},
    event,
    () => {console.log('Kicked from /ui-updates')}
  )
}
