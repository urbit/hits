import { installApp } from '../api/pokes.js'

function getAppPath(href) {
  if ('site' in href) {
    return href.site.substring(1)
  }

  return `apps/${href.glob.base}`
}

export default function AppButton({ app, isLoading, isInstalled }) {

  const buttonText = !isInstalled ? 'GET' : 'OPEN'

  return (
    <td className={`app-button ${isInstalled ? 'open-button' : ''}`}>
      <button
      onClick={
        isInstalled
        ? () => window.open(`${window.location.origin}/${getAppPath(app.docket.href)}`, '_blank', 'noopener,noreferrer')
        : () => installApp(app.publisher, app.desk)
      }
      >
        {isLoading ? '...' : buttonText}
      </button>
    </td>
  )
}
