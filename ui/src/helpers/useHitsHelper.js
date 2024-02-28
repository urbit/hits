import Urbit from '@urbit/http-api';

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export default function useHitsHelper() {
  const [apps, setApps] = useState([])
  // TODO baseVersion: track %base version here and filter
  //      out apps on initRankings / receiveUpdate.
  //      Assuming for now we only care about %zuse
  const [baseVersion, setBaseVersion] = useState()

  const chartLimit = 40

  // TODO move all scries to /api folder?
  async function scryAppScore(ship, desk) {
    return await api.scry({
      app: 'hits',
      path: `/${ship}/${desk}/score`
    })
  }

  async function scryAppVersion(ship, desk) {
    return await api.scry({
      app: 'hits',
      path: `/${ship}/${desk}/version`
    })
  }

  async function scryAppDocket(ship, desk) {
    return await api.scry({
      app: 'hits',
      path: `/${ship}/${desk}/docket`
    })
  }

  async function scryAppInstalls(ship, desk) {
    return await api.scry({
      app: 'hits',
      path: `/${ship}/${desk}/installs`
    })
  }

  function initRankings(response) {
    let data = JSON.parse(response)

    data.rankings.forEach(ranking => {
      if (apps.length < chartLimit) {
        let thisApp = {}
        const desk = ranking.desk
        const ship = ranking.ship
        
        thisApp.version = scryAppVersion(ship, desk)

        if (thisApp.version === baseVersion) {
          thisApp.rank = apps.length + 1
          thisApp.name = desk
          thisApp.publisher = ship
          thisApp.score = scryAppScore(ship, desk)
          thisApp.docket = scryAppDocket(ship, desk)
          thisApp.installs = scryAppInstalls(ship, desk)

          setApps(prevApps => [...prevApps, thisApp])
        }
      }
      // scry all data for next ship and desk in rankings
      // compile to one object
      // setApps(...apps, newObject)
    })
  }

  function receiveUiUpdate() {}

  // TODO expose hook state to App()
  return {initRankings, receiveUiUpdate}
}
