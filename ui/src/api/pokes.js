import Urbit from '@urbit/http-api'

function pokeUrbit(app, mark, json) {
  const api = new Urbit('', '', app)
  api.ship = window.ship
  return api.poke({
    app: app,
    mark: mark,
    json: json,
    onError: () => {
      console.error(`Failed to poke ${app} with mark ${mark} and json ${json}`)
    }
  })
}

export function installApp(ship, desk) {
  console.log(`Attempting to install ${desk} from ${ship}`)
  return pokeUrbit('docket', 'docket-install', `${ship}/${desk}`)
}
