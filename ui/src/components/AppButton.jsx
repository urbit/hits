import { installApp } from '../api/pokes.js'

export default function AppButton({ desk, publisher, isInstalled }) {

  function handleGetButtonClick(desk, publisher) {
    installApp(publisher, desk)
  }

  return (
    <td className='app-button'>
      <button onClick={() => handleGetButtonClick(desk, publisher)}>GET</button>
    </td>
  )
}
