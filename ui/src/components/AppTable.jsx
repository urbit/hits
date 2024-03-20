import { useEffect, useState } from 'react'
import AppButton from './AppButton.jsx';

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

  if (window.innerWidth < 700) {
    // return first sentence
    return newDesc.match(/^[^.!?]*[.!?](?:\s|$)/)[0]
  }

  // return first two sentences
  return newDesc.match(/(.*?[.!?])(\s+.*?[.!?])?/)[0]
}

function normalizeAppTitle(title) {
  if (title.length > 30) {
    return ''
  }

  if (title === title.toUpperCase()) {
    return title;
  }

  return title
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}

function normalizeIconPath(path) {
  if (!path.startsWith('http')) {
    return ''
  }

  return path
}

function normalizeLicense(license) {
  if (!license) {
    return ''
  }

  if (license.length > 9) {
    return ''
  }

  return `(${license.toUpperCase()})`
}

function normalizePublisher(ship) {
  if (ship.length > 28) {
    return `${ship.substring(0, 7)}_${ship.substring(51)}`
  }
  return ship
}

function normalizeVersion(version) {
  if (version.length > 8) {
    return ''
  }

  return version
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

  newUrl = newUrl.match(/^[^\/]+/)

  if (newUrl.length >= 30) {
    return 'website'
  }

  return newUrl
}

export default function AppTable({ apps, loadingDesks, installedDesks }) {
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
            // TODO check if normalized app title is truthy
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
                          {normalizeAppTitle(app.docket.title)}
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
                          {normalizeVersion(app.docket.version) &&
                            <>
                              <span>{`${normalizeVersion(app.docket.version)}`}</span>
                              &nbsp;
                            </>
                          }
                          {normalizeLicense(app.docket.license) &&
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
                          {normalizeAppTitle(app.docket.title)}
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
                            {document.innerWidth >= 425 &&
                              (app.docket.website || app.docket.version || app.docket.license ? ' / ' : '')
                            }
                          </>
                        }
                        {document.innerWidth >= 425 && (
                          <>
                            {normalizeWebsite(app.docket.website) && (
                              <>
                                <span className='info-website'>
                                  <a href={app.docket.website} target='_blank' rel="noopener noreferrer">{normalizeWebsite(app.docket.website)}</a>
                                </span>
                                {' '}
                              </>
                            )}
                            <span className="info-additional">
                              {normalizeVersion(app.docket.version) && (
                                <>
                                  <span>{`${normalizeVersion(app.docket.version)}`}</span>
                                  {' '}
                                </>
                              )}
                              {normalizeLicense(app.docket.license) && (
                                <>
                                  <span>{normalizeLicense(app.docket.license)}</span>
                                </>
                              )}
                            </span>
                          </>
                        )}
                      </div>
                    </td>
                  </>
              }
              <AppButton
              app={app}
              isLoading={loadingDesks.includes(app.desk)}
              isInstalled={installedDesks.includes(app.desk)}
              />
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
