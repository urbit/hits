import { useState } from 'react'

export default function useHitsHelper() {
  const [allTimeRankings, setAllTimeRankings] = useState([])

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

  function receiveUiUpdate(uiUpdate) {
    switch (uiUpdate.updateTag) {
      case 'score-updated':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
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
        break

      case 'version-updated':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
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
        break

      case 'installs-updated':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
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
        break

      case 'docket-updated':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
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
        break

      case 'app-requested':
        // TODO remove console log
        console.log('uiUpdate tag: ', uiUpdate.updateTag)
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
              }

              return prevApps
            })
          }
        }
        break

      default:
        console.log('Unknown uiUpdate: ', uiUpdate)
      }
  }

  return { allTimeRankings, receiveUiUpdate }
}
