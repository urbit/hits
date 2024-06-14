import React, { useState, useEffect } from 'react'
import { installApp } from '../api/pokes.js'

function getAppPath(href) {
  if ('site' in href) {
    return href.site.substring(1)
  }

  return `apps/${href.glob.base}`
}

export default function AppButton({ app, isLoading, isInstalled }) {
  const [animatedText, setAnimatedText] = useState('.\u00A0\u00A0')
  const buttonText = !isInstalled ? 'GET' : 'OPEN'

  useEffect(() => {
    if (isLoading) {
      const ellipsis = ['..\u00A0', '...', '.\u00A0\u00A0']
      let index = 0
      const interval = setInterval(() => {
        setAnimatedText(ellipsis[index])
        index = (index + 1) % ellipsis.length
      }, 400)

      return () => clearInterval(interval)
    }
  }, [isLoading])

  return (
    <td className={`app-button ${isInstalled ? 'open-button' : ''}`}>
      <button
        onClick={
          isInstalled
            ? () => window.open(`${window.location.origin}/${getAppPath(app.docket.href)}`, '_blank', 'noopener,noreferrer')
            : () => installApp(app.publisher, app.desk)
        }
      >
        {isLoading ? animatedText : buttonText}
      </button>
    </td>
  )
}
