import { useEffect, useState } from 'react'

export default function useHitsState() {
  const [allTimeRankings, setAllTimeRankings] = useState([])
  const [trendingApps, setTrendingApps] = useState([])

  const chartLimit = 40

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
    const filteredApps = apps.filter(app => {
      return app.score > 2
    })

    const mostRecentInstall = filteredApps.reduce((mostRecentInstall, app) => {
      const mostRecentAppInstall = app.installs[0]
      return mostRecentInstall > mostRecentAppInstall
             ? mostRecentInstall
             : mostRecentAppInstall
    }, 0)

    return filteredApps.sort((a, b) => {
      const installLimit = 25
      const scoreA = a.installs.slice(0, installLimit).reduce((totalScore, install) => {
        const timeDiff = new Date(mostRecentInstall) - new Date(install)
        // TODO adjust score decay rate based on testing
        // score decays based on how many 24-hour periods
        // are in the timeDiff
        const score = Math.exp(-timeDiff / 86400000)
        return totalScore + score
      }, 0)

      const scoreB = b.installs.slice(0, installLimit).reduce((totalScore, install) => {
        const timeDiff = new Date(mostRecentInstall) - new Date(install)
        const score = Math.exp(-timeDiff / 86400000)
        return totalScore + score
      }, 0)

      return scoreB - scoreA
    })
  }

  function receiveUiUpdate(uiUpdate) {
    switch (uiUpdate.updateTag) {
      case 'score-update':
        console.log('score-update for ', uiUpdate.desk)

        setAllTimeRankings(prevRankings => {
          const newAllTimeRankings = prevRankings.map(ranking => {
            if (ranking.desk === uiUpdate.desk && ranking.publisher === uiUpdate.ship) {
              return { ...ranking, score: uiUpdate.score }
            }
            return ranking
          })

          return sortAllTimeRankings(newAllTimeRankings).slice(0, chartLimit)
        })

        setTrendingApps(prevApps => {
          const newTrendingApps = prevApps.map(app => {
            if (app.desk === uiUpdate.desk && app.publisher === uiUpdate.ship) {
              return { ...app, score: uiUpdate.score }
            }
            return app
          })

          return sortTrendingApps(newTrendingApps).slice(0, chartLimit)
        })
        break

      case 'version-update':
        console.log('version-update for ', uiUpdate.desk)

        setAllTimeRankings(prevRankings => {
          const newAllTimeRankings = prevRankings.map(ranking => {
            if (ranking.desk === uiUpdate.desk && ranking.publisher === uiUpdate.ship) {
              return { ...ranking, version: uiUpdate.version }
            }
            return ranking
          })

          return sortAllTimeRankings(newAllTimeRankings).slice(0, chartLimit)
        })

        setTrendingApps(prevApps => {
          const newTrendingApps = prevApps.map(app => {
            if (app.desk === uiUpdate.desk && app.publisher === uiUpdate.ship) {
              return { ...app, version: uiUpdate.version }
            }
            return app
          })

          return sortTrendingApps(newTrendingApps).slice(0, chartLimit)
        })
        break

      case 'installs-update':
        console.log('installs-update for ', uiUpdate.desk)

        setAllTimeRankings(prevRankings => {
          const newAllTimeRankings = prevRankings.map(ranking => {
            if (ranking.desk === uiUpdate.desk && ranking.publisher === uiUpdate.ship) {
              return { ...ranking, installs: uiUpdate.installs }
            }
            return ranking
          })

          return sortAllTimeRankings(newAllTimeRankings).slice(0, chartLimit)
        })

        setTrendingApps(prevApps => {
          const newTrendingApps = prevApps.map(app => {
            if (app.desk === uiUpdate.desk && app.publisher === uiUpdate.ship) {
              return { ...app, installs: uiUpdate.installs }
            }
            return app
          })

          return sortTrendingApps(newTrendingApps).slice(0, chartLimit)
        })
        break

      case 'docket-update':
        console.log('docket-update for ', uiUpdate.desk)

        setAllTimeRankings(prevRankings => {
          const newAllTimeRankings = prevRankings.map(ranking => {
            if (ranking.desk === uiUpdate.desk && ranking.publisher === uiUpdate.ship) {
              return { ...ranking, docket: uiUpdate.docket }
            }
            return ranking
          })

          return sortAllTimeRankings(newAllTimeRankings).slice(0, chartLimit)
        })

        setTrendingApps(prevApps => {
          const newTrendingApps = prevApps.map(app => {
            if (app.desk === uiUpdate.desk && app.publisher === uiUpdate.ship) {
              return { ...app, docket: uiUpdate.docket }
            }
            return app
          })

          return sortTrendingApps(newTrendingApps).slice(0, chartLimit)
        })
        break

        case 'app-update':
          if (!uiUpdate.docket.title) {
            return;
          }

          setTrendingApps(prevApps => {
            const newApps = prevApps.find(app => app.desk === uiUpdate.desk)
              ? prevApps
              : sortTrendingApps([...prevApps, {
                  desk: uiUpdate.desk,
                  publisher: uiUpdate.ship,
                  score: uiUpdate.score,
                  version: uiUpdate.version,
                  installs: uiUpdate.installs,
                  docket: uiUpdate.docket,
                }]).slice(0, chartLimit)

            return newApps
          })

          setAllTimeRankings(prevApps => {
            const newApps = prevApps.find(ranking => ranking.desk === uiUpdate.desk)
              ? prevApps
              : [...prevApps, {
                  desk: uiUpdate.desk,
                  publisher: uiUpdate.ship,
                  score: uiUpdate.score,
                  version: uiUpdate.version,
                  installs: uiUpdate.installs,
                  docket: uiUpdate.docket,
                }].slice(0, chartLimit)

            return newApps
          })

          break

        default:
          console.log('Unknown uiUpdate: ', uiUpdate)
      }
    }

  return { allTimeRankings, receiveUiUpdate, trendingApps }
}
