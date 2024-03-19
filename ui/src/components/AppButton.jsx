import { installApp } from '../api/pokes.js'

export default function AppButton({ desk, publisher, isLoading, isInstalled }) {

  function handleGetButtonClick(desk, publisher) {
    installApp(publisher, desk)
  }

  const buttonText = !isInstalled ? 'GET' : 'OPEN'

  return (
    <td className={`app-button ${isInstalled ? 'open-button' : ''}`}>
      <button
      onClick={() => handleGetButtonClick(desk, publisher)}
      >
        {isLoading ? '...' : buttonText}
      </button>
    </td>
  )
}
