import { useEffect, useState } from 'react'

export default function useHitsHelper() {
  const [allTimeRankings, setAllTimeRankings] = useState([])
  const [trendingApps, setTrendingApps] = useState([])

  const chartLimit = 40
  const installLimit = 25

  function sortAllTimeRankings(rankings) {
    return rankings.sort((a, b) => {
      // if scores are the same, sort by newest install
      if (b.score - a.score === 0) {
        return b.installs[0] - a.installs[0]
      }
      // otherwise, sort by score
      return b.score - a.score
    })
  }

  function sortTrendingApps(apps) {
    // get most recent known install datetime for any
    // app in milliseconds; use this rather than current
    // datetime so results are deterministic based on the
    // app's current state
    const mostRecentInstall = apps.reduce((mostRecentInstall, app) => {
      const mostRecentAppInstall = app.installs[0]

      return mostRecentInstall > mostRecentAppInstall
             ? mostRecentInstall
             : mostRecentAppInstall
    }, 0)

    return apps.sort((a, b) => {
      const scoreA = a.installs.slice(0, installLimit).reduce((totalScore, install) => {
        const timeDiff = new Date(mostRecentInstall) - new Date(install);
        // TODO adjust score decay rate based on testing
        // score decays based on how many 24-hour periods
        // are in the timeDiff
        const score = Math.exp(-timeDiff / 86400000);

        return totalScore + score;
      }, 0);

      const scoreB = b.installs.slice(0, installLimit).reduce((totalScore, install) => {
        const timeDiff = new Date(mostRecentInstall) - new Date(install);
        const score = Math.exp(-timeDiff / 86400000);

        return totalScore + score;
      }, 0);

      return scoreB - scoreA;
    });
  }

  function receiveUiUpdate(uiUpdate) {
    switch (uiUpdate.updateTag) {
      case 'score-update':
        // TODO remove console log
        console.log('score-update for ', uiUpdate.desk)

        setAllTimeRankings(prevRankings => {
          const newAllTimeRankings = prevRankings.map(ranking => {
            if (
              ranking.name === uiUpdate.desk
              && ranking.publisher === uiUpdate.ship
              ) {
              return { ...ranking, score: uiUpdate.score }
            }
            return ranking
          })

          return sortAllTimeRankings(newAllTimeRankings)
        })

        setTrendingApps(prevApps => {
          const newTrendingApps = prevApps.map(ranking => {
            if (
              ranking.name === uiUpdate.desk
              && ranking.publisher === uiUpdate.ship
            ) {
              return { ...ranking, score: uiUpdate.score }
            }
          })

          return newTrendingApps
        })
        break

      case 'version-update':
        // TODO remove console log
        console.log('version-update for ', uiUpdate.desk)

        setAllTimeRankings(prevRankings => {
          const newAllTimeRankings = prevRankings.map(ranking => {
            if (
              ranking.name === uiUpdate.desk
              && ranking.publisher === uiUpdate.ship
            ) {
              return { ...ranking, version: uiUpdate.version }
            }
          })

          return newAllTimeRankings
        })

        setTrendingApps(prevApps => {
          const newTrendingApps = prevApps.map(ranking => {
            if (
              ranking.name === uiUpdate.desk
              && ranking.publisher === uiUpdate.ship
            ) {
              return { ...ranking, version: uiUpdate.version }
            }
          })

          return newTrendingApps
        })
        break

      case 'installs-update':
        // TODO remove console log
        console.log('installs-update for ', uiUpdate.desk)

        setAllTimeRankings(prevRankings => {
          const newAllTimeRankings = prevRankings.map(ranking => {
            if (
              ranking.name === uiUpdate.desk
              && ranking.publisher === uiUpdate.ship
            ) {
              return { ...ranking, installs: uiUpdate.installs }
            }
          })

          return newAllTimeRankings
        })

        setTrendingApps(prevApps => {
          const newTrendingApps = prevApps.map(ranking => {
            if (
              ranking.name === uiUpdate.desk
              && ranking.publisher === uiUpdate.ship
            ) {
              return { ...ranking, installs: uiUpdate.installs }
            }
          })

          return sortTrendingApps(newTrendingApps)
        })
        break

      case 'docket-update':
        // TODO remove console log
        console.log('docket-update for ', uiUpdate.desk)

        setAllTimeRankings(prevRankings => {
          const newAllTimeRankings = prevRankings.map(ranking => {
            if (
              ranking.name === uiUpdate.desk
              && ranking.publisher === uiUpdate.ship
            ) {
              return { ...ranking, docket: uiUpdate.docket }
            }
          })

          return newAllTimeRankings
        })

        setTrendingApps(prevApps => {
          const newTrendingApps = prevApps.map(ranking => {
            if (
              ranking.name === uiUpdate.desk
              && ranking.publisher === uiUpdate.ship
            ) {
              return { ...ranking, docket: uiUpdate.docket }
            }
          })

          return newTrendingApps
        })
        break

      case 'app-update':
        // TODO remove console log
        console.log('app-update for ', uiUpdate.desk)

        setTrendingApps(prevApps => {
          // TODO remove this appIndex check, shouldn't
          //      need to check for duplicates
          const appIndex = prevApps.findIndex(app => {
            return app.name === uiUpdate.desk
          })

          if (appIndex === -1) {
            return sortTrendingApps([...prevApps, {
              name: uiUpdate.desk,
              publisher: uiUpdate.ship,
              score: uiUpdate.score,
              version: uiUpdate.version,
              installs: uiUpdate.installs,
              docket: uiUpdate.docket,
            }])
          } else {
            return prevApps
          }
        })

        if (allTimeRankings.length < chartLimit) {
          // const baseVersionResponse = await scryBaseVersion()
          // const localBaseVersion = baseVersionResponse

          // TODO remove hard-coded %base version
          if (uiUpdate.version <= 412) {
            setAllTimeRankings(prevApps => {
              // TODO remove this appIndex check, shouldn't
              //      need to check for duplicates
              const appIndex = prevApps.findIndex(app => {
                return app.name === uiUpdate.desk
              })

              if (appIndex === -1) {
                return [...prevApps, {
                  name: uiUpdate.desk,
                  publisher: uiUpdate.ship,
                  rank: prevApps.length + 1,
                  score: uiUpdate.score,
                  version: uiUpdate.version,
                  installs: uiUpdate.installs,
                  docket: uiUpdate.docket,
                }]
              } else {
                return prevApps
              }
            })
          }
        }
        break

      default:
        console.log('Unknown uiUpdate: ', uiUpdate)
      }
  }

  return { allTimeRankings, receiveUiUpdate, trendingApps }
}
