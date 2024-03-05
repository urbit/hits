import React, { useEffect, useState } from 'react';
import useHitsHelper from './helpers/useHitsHelper.js'
import Header from './components/Header'
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

  // TODO remove useEffects, they're just for testing
  useEffect(() => {
    console.log('new allTimeRankings: ', allTimeRankings)
  }, [allTimeRankings])

  useEffect(() => {
    console.log('new trendingApps: ', trendingApps)
  }, [trendingApps])

  return (
    <div className='app-container bg-background'>
    <Header />
    <div className='m-3'>
      <h1 className='font-sans text-main'>%hits</h1>
    </div>
    <AppTable />
    </div>
  );
}
