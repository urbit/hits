import { useState } from 'react'
import {
  scryAppDocket,
  scryAppScore,
  scryAppVersion,
  scryBaseVersion
} from '../api/scries'

export default function useHitsHelper() {
  const [allTimeApps, setAllTimeApps] = useState([])

  const chartLimit = 40

  async function initAllTimeApps(response) {
    let rankings = await response;

    // TODO baseVersion: track %base version here and filter
    //      out apps on initAllTimeApps / receiveUpdate.
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

    setAllTimeApps(validApps);
  }

  function receiveUiUpdate() {}

  return { allTimeApps, initAllTimeApps, receiveUiUpdate }
}
