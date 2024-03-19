import React, { useEffect, useState, useRef } from 'react'
import useHitsState from './state/useHitsState.js'
import useDesksState from './state/useDesksState.js'
import AppTable from './components/AppTable'
import { subscribeToCharges, subscribeToUiUpdates } from './api/subscriptions.js'
import hitsTitle from './assets/hits.svg'
import helpIcon from './assets/help.svg'

export function App() {
  const [listView, setListView] = useState('allTime')
  const [isHelpVisible, setIsHelpVisible] = useState(false)
  const helpIconRef = useRef(null)
  const helpWindowRef = useRef(null)
  const {
    allTimeRankings,
    receiveUiUpdate,
    trendingApps
  } = useHitsState()
  const { receiveDesksUpdate } = useDesksState()

  const todaysDate = new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })

  useEffect(() => {
    async function init() {
      await subscribeToCharges(chargesUpdate => receiveDesksUpdate(chargesUpdate))
      await subscribeToUiUpdates(uiUpdate => receiveUiUpdate(uiUpdate))
    }

    init()
  }, [])

  useEffect(() => {
    const handleScroll = () => {
      if (isHelpVisible) {
        setIsHelpVisible(false)
      }
    }

    window.addEventListener('scroll', handleScroll)

    return () => window.removeEventListener('scroll', handleScroll)
  }, [isHelpVisible])

  useEffect(() => {
    function handleClickOutside(event) {
      if (helpWindowRef.current && !helpWindowRef.current.contains(event.target) &&
          helpIconRef.current && !helpIconRef.current.contains(event.target)) {
        setIsHelpVisible(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  function handleMostInstalledClick() {
    setListView('allTime')
  }

  function handleTrendingAppsClick() {
    setListView('trendingApps')
  }

  return (
    <div className='app-container'>
      <div className='header'>
        <span className='header-text'>{todaysDate.toUpperCase()}</span>
        <span id='most-installed' className={`header-text header-link ${listView === 'allTime' ? '' : 'inactive-link'}`} onClick={handleMostInstalledClick}>ALL-TIME</span>
        <span id='trending-apps' className={`header-text header-link ${listView === 'trendingApps' ? '' : 'inactive-link'}`} onClick={handleTrendingAppsClick}>TRENDING</span>
        <img ref={helpIconRef} className='help-icon' src={helpIcon} alt="help icon" onClick={() => setIsHelpVisible(!isHelpVisible)} />
        <div ref={helpWindowRef} className={`help-window ${isHelpVisible ? 'visible' : ''}`}>
          <p>Hits is compiled from a local sample of app installs among your neighbors.</p>
          <p>That sample includes everyone you've added in the <a className='link-text' href={`${window.location.origin}/apps/landscape/search/~paldev/apps/~paldev/pals`} target='_blank' rel='noopener noreferrer'>%pals</a> app, and everyone they've added as a pal. These aren't definitive rankings for the whole Urbit network.</p>
          <p>Trending apps are determined by the frequency of installs your Hits app knows about.</p>
        </div>
      </div>
      <div className='title-container'>
        <img src={hitsTitle} alt="%hits title" />
      </div>
      <AppTable apps={
        listView === 'allTime'
        ? allTimeRankings
        : trendingApps
      } />
    </div>
  )
}
