import { useState } from 'react'
import {
  scryAppDocket,
  scryAppScore,
  scryAppVersion,
  scryBaseVersion
} from '../api/scries'

export default function useHitsHelper() {
  const [allTimeRankings, setAllTimeRankings] = useState([])

  const chartLimit = 40

  async function initAllTimeRankings(response) {
    let rankings = await response;

    // TODO baseVersion: track %base version here and filter
    //      out apps on initAllTimeRankings / receiveUpdate.
    //      Assuming for now we only care about %zuse
    const baseVersionResponse = await scryBaseVersion();
    const localBaseVersion = baseVersionResponse;

    let validApps = [];

    await Promise.all(rankings.map(async (ranking, index) => {
      if (validApps.length < chartLimit) {
        let thisApp = {};
        const desk = ranking.desk;
        const ship = ranking.ship;

        thisApp.version = await scryAppVersion(ship, desk);

        if (thisApp.version <= localBaseVersion) {
          thisApp.rank = index + 1;
          thisApp.name = desk;
          thisApp.publisher = ship;
          thisApp.score = await scryAppScore(ship, desk);
          thisApp.docket = await scryAppDocket(ship, desk);

          validApps.push(thisApp);
        }
      }
    }));

    setAllTimeRankings(validApps);
  }

  function receiveUiUpdate() {}

  return { allTimeRankings, initAllTimeRankings, receiveUiUpdate }
}
