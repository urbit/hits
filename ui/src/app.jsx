import React, { useEffect, useState } from 'react';
import Urbit from '@urbit/http-api';
import useHitsHelper from './helpers/useHitsHelper.js'
import Header from './components/Header'
import AppTable from './components/AppTable'

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

// TODO check we have %pals installed, display a warning if not
export function App() {
  const [list, setList] = useState('allTime')
  // const {initRankings, receiveUiUpdate} = useHitsHelper()

  useEffect(() => {
    async function init() {
  //     initRankings(await api.scry({
  //       app: 'hits',
  //       path: '/rankings'
  //     }))

      await api.subscribe({
        app: 'hits',
        path: '/ui-updates',
        err: () => {console.error('Failed subscription to /ui-updates')},
        event: () => {},
        // event: (uiUpdate) => {receiveUiUpdate(uiUpdate)},
        quit: () => {console.log('Kicked from /ui-updates')}
      })
    }

    init();
  }, []);

  return (
    <div class='app-container bg-background'>
    <Header />
    <div class='m-3'>
      <h1 class='font-sans text-main'>%hits</h1>
    </div>
    <AppTable />
    </div>
  );
}
