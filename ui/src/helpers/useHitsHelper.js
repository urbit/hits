import { useState } from 'react'

export default function useHitsHelper() {
  const [allTimeApps, setAllTimeApps] = useState([])

  const chartLimit = 40

  function receiveUiUpdate(uiUpdate) {
    switch (uiUpdate.updateTag) {
      case 'score-updated':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
        break;

      case 'version-updated':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
        break;

      case 'installs-updated':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
        break;

      case 'docket-updated':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
        break;

      case 'app-requested':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
        if (allTimeApps.length < chartLimit) {
          // const baseVersionResponse = await scryBaseVersion();
          // const localBaseVersion = baseVersionResponse;

          // TODO remove hard-coded %base version
          if (uiUpdate.version <= 412) {
            setAllTimeApps(prevApps => {
              // TODO remove this appIndex check, shouldn't
              //      need to check for duplicates
              const appIndex = prevApps.findIndex(app => {
                return app.name === uiUpdate.desk
              });

              if (appIndex === -1) {
                return [...prevApps, {
                  name: uiUpdate.desk,
                  publisher: uiUpdate.ship,
                  rank: prevApps.length + 1,
                  score: uiUpdate.score,
                  version: uiUpdate.version,
                  installs: uiUpdate.installs,
                  docket: uiUpdate.docket,
                }];
              }

              return prevApps;
            });
          }
        }
        break;

      default:
        console.log('Unknown uiUpdate: ', uiUpdate);
      }
  }

  return { allTimeApps, receiveUiUpdate }
}
