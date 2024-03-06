import React, { useEffect, useState } from 'react';
import useHitsHelper from './helpers/useHitsHelper.js'
import AppTable from './components/AppTable'
import { subscribeToUiUpdates } from './api/subscriptions.js';

// TODO check we have %pals installed, display a warning if not
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

  // TODO remove these two useEffects, they're just for testing
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
        <span className='header-text'>All Time</span>
        <span className='header-text'>Trending</span>
        <span className='header-text'>?</span>
      </div>
      <div id='title-container'>
        <h1 className='hits-title'>%HITS</h1>
      </div>
      <AppTable />
      </div>
  );
}
