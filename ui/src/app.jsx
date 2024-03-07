import React, { useEffect, useState } from 'react';
import useHitsHelper from './helpers/useHitsHelper.js'
import AppTable from './components/AppTable'
import { subscribeToUiUpdates } from './api/subscriptions.js';
import hitsTitle from './assets/hits.svg'
import helpIcon from './assets/help.svg'

export function App() {
  const [listView, setListView] = useState('allTime')
  const {
    allTimeRankings,
    receiveUiUpdate,
    trendingApps
  } = useHitsHelper()

  const todaysDate = new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })

  useEffect(() => {
    async function init() {
      await subscribeToUiUpdates(uiUpdate => receiveUiUpdate(uiUpdate))
    }

    init();
  }, []);

  useEffect(() => {
    console.log('new allTimeRankings: ', allTimeRankings)
  }, [allTimeRankings])

  useEffect(() => {
    console.log('new trendingApps: ', trendingApps)
  }, [trendingApps])

  function handleMostInstalledClick() {
    setListView('allTime')
  }

  function handleTrendingAppsClick() {
    setListView('trendingApps')
  }

  return (
      <div className='app-container'>
      <div className='header'>
        <span className='header-text'>{todaysDate}</span>
        <span className="links-wrapper">
          <span id='most-installed' className={`header-text ${listView === 'allTime' ? '' : 'inactive-link'}`} onClick={handleMostInstalledClick}>Most Installed</span>
          <span id='trending-apps' className={`header-text ${listView === 'trendingApps' ? '' : 'inactive-link'}`} onClick={handleTrendingAppsClick}>Trending Apps</span>
        </span>
        <img className='help-icon' src={helpIcon} alt="help icon" />
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
  );
}
