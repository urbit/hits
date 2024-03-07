import React, { useEffect, useState } from 'react';
import useHitsHelper from './helpers/useHitsHelper.js'
import AppTable from './components/AppTable'
import { subscribeToUiUpdates } from './api/subscriptions.js';
import hitsTitle from './assets/hits.svg'

export function App() {
  const [listView, setListView] = useState('allTime')
  const {
    allTimeRankings,
    receiveUiUpdate,
    trendingApps
  } = useHitsHelper()

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

  return (
      <div className='app-container'>
      <div className='header'>
        <span className='header-text'>March 6, 2024</span>
        <span className='header-text' onClick={() => setListView('allTime')}>All Time</span>
        <span className='header-text' onClick={() => setListView('trending')}>Trending</span>
        <span className='header-text'>?</span>
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
