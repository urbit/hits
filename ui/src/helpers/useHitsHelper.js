import { useState } from 'react'
import {
  scryAppDocket,
  scryAppInstalls,
  scryAppScore,
  scryAppVersion
} from '../api/scries'

export default function useHitsHelper() {
  const [allTimeRankings, setAllTimeRankings] = useState([])
  // TODO baseVersion: track %base version here and filter
  //      out apps on initAllTimeRankings / receiveUpdate.
  //      Assuming for now we only care about %zuse
  const [baseVersion, setBaseVersion] = useState()

  const chartLimit = 40

  async function initAllTimeRankings(response) {
    let data = await response
    console.log('initAllTimeRankings response: ', data)

    data.rankings.forEach(ranking => {
      if (allTimeRankings.length < chartLimit) {
        let thisApp = {}
        const desk = ranking.desk
        const ship = ranking.ship

        thisApp.version = scryAppVersion(ship, desk)

        if (thisApp.version === baseVersion) {
          thisApp.rank = allTimeRankings.length + 1
          thisApp.name = desk
          thisApp.publisher = ship
          thisApp.score = scryAppScore(ship, desk)
          thisApp.docket = scryAppDocket(ship, desk)

          setAllTimeRankings(prevApps => [...prevApps, thisApp])
        }
      }
    })
  }

  function receiveUiUpdate() {}

  return { allTimeRankings, initAllTimeRankings, receiveUiUpdate }
}
