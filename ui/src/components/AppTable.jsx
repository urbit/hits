import { useEffect, useState } from 'react'
import { installApp } from '../api/pokes.js'

function normalizeAppColor(color) {
  if (color === '0x0') {
    return '#FACDB9'
  }

  let hexColor = `#${color.slice(2).replace('.', '').toUpperCase()}`;

  if (hexColor.length !== 7) {
    return '#FACDB9'
  }

  return hexColor
}

function normalizeAppDescription(info) {
  if (info === '') {
    return ''
  }

  let newDesc = `${info[0].toUpperCase()}${info.substring(1)}`

  if (
    newDesc[newDesc.length - 1] !== '.' &&
    newDesc[newDesc.length - 1] !== '…' &&
    newDesc[newDesc.length - 1] !== '!' &&
    newDesc[newDesc.length - 1] !== '?' &&
    newDesc[newDesc.length - 1] !== ')' &&
    newDesc[newDesc.length - 1] !== ']' &&
    newDesc[newDesc.length - 1] !== '}' &&
    newDesc[newDesc.length - 1] !== '\'' &&
    newDesc[newDesc.length - 1] !== '\"'
    ) {
    newDesc = `${newDesc}.`
  }

  return newDesc.match(/(.*?[.!?])(\s+.*?[.!?])?/)[0]
}

function normalizeIconPath(path) {
  if (!path.startsWith('http')) {
    return ''
  }

  return path
}

function normalizeLicense(license) {
  return `(${license.toUpperCase()})`
}

function normalizePublisher(ship) {
  if (ship.length > 28) {
    return `${ship.substring(0, 7)}_${ship.substring(51)}`
  }
  return ship
}

function normalizeWebsite(url) {
  let newUrl = url

  if (newUrl.startsWith('web+urbitgraph://group/')) {
    return ''
  }

  if (newUrl.startsWith('https://')) {
    newUrl = newUrl.substring(8)
  }

  if (newUrl.startsWith('http://')) {
    newUrl = newUrl.substring(7)
  }

  if (newUrl.startsWith('www.')) {
    newUrl = newUrl.substring(4)
  }

  return newUrl.match(/^[^\/]+/)
}

function handleGetButtonClick(name, publisher) {
  installApp(publisher, name)
}

export default function AppTable({ apps }) {
  const widthCutoff = 700
  const [screenWidth, setScreenWidth] = useState(window.innerWidth)

  useEffect(() => {
    const handleResize = () => {
      setScreenWidth(window.innerWidth)
    }

    window.addEventListener('resize', handleResize)

    return () => {
      window.removeEventListener('resize', handleResize)
    }
  }, [])

  return (
    <div className="table-wrapper">
      <table>
        <thead>
          <th className='index-header'>#</th>
          <th className='icon-header'>ICON</th>
          <th className='app-header'>APPLICATION</th>
          <th className="info-header">DETAILS</th>
          <th className='download-header'>INSTALL</th>
        </thead>
        <tbody>
          {apps.map((app, index) => (
            <tr key={index + 1}>
              <td className='app-index'>
                {index + 1}
              </td>
              <td
                className='app-icon'
                style={
                  { backgroundColor: `${normalizeAppColor(app.docket.color)}` }
                }
              >
                {normalizeIconPath(app.docket.image) &&
                <img
                src={normalizeIconPath(app.docket.image)}
                alt={`${app.docket.title} app icon`}
                />
                }
              </td>
              {screenWidth > widthCutoff
                // desktop screens
                ? <>
                    <td className='app-name-desc'>
                      <div className="text-wrapper">
                        <span className='app-title'>
                          {app.docket.title.toUpperCase()}
                        </span>
                        {normalizeAppDescription(app.docket.info) &&
                          <>
                            &nbsp;
                            <span className='app-description'>
                              {normalizeAppDescription(app.docket.info)}
                            </span>
                          </>
                        }
                      </div>
                    </td>
                    <td className="app-info">
                      <div className="text-wrapper">
                        {app.publisher &&
                          <>
                          <span className='info-publisher'>{normalizePublisher(app.publisher)}</span>
                          <br></br>
                          </>
                        }
                        {normalizeWebsite(app.docket.website) &&
                          <>
                          <span className='info-website'>
                            <a href={app.docket.website} target='_blank'>{normalizeWebsite(app.docket.website)}</a>
                          </span>
                          &nbsp;
                          </>
                        }
                        <span className="info-additional">
                          {app.docket.version &&
                            <>
                              <span>{`${app.docket.version}`}</span>
                              &nbsp;
                            </>
                          }
                          {app.docket.license &&
                          <>
                          <span>{normalizeLicense(app.docket.license)}</span>
                          </>}
                        </span>
                      </div>
                    </td>
                  </>
                // tablet + mobile screens
                : <>
                    <td className='app-name-desc'>
                      <div className="text-wrapper">
                        <span className='app-title'>
                          {app.docket.title.toUpperCase()}
                        </span>
                        {normalizeAppDescription(app.docket.info) &&
                          <>
                            &nbsp;
                            <span className='app-description'>
                              {normalizeAppDescription(app.docket.info)}
                            </span>
                          </>
                        }
                      </div>
                      <div className='text-wrapper'>
                        {app.publisher &&
                          <>
                          <span className='info-publisher'>{normalizePublisher(app.publisher)}</span>
                          &nbsp;{!app.docket.website && !app.docket.version && !app.docket.license ? '' : '/ ' }
                          </>
                        }
                        {normalizeWebsite(app.docket.website) &&
                          <>
                          <span className='info-website'>
                            <a href={app.docket.website} target='_blank'>{normalizeWebsite(app.docket.website)}</a>
                          </span>
                          &nbsp;
                          </>
                        }
                        <span className="info-additional">
                          {app.docket.version &&
                            <>
                              <span>{`${app.docket.version}`}</span>
                              &nbsp;
                            </>
                          }
                          {app.docket.license &&
                          <>
                          <span>{normalizeLicense(app.docket.license)}</span>
                          </>}
                        </span>
                      </div>
                    </td>
                  </>
              }
              <td className='app-button'>
                <button onClick={() => handleGetButtonClick(app.desk, app.publisher)}>GET</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
