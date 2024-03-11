export default function AppTable({ apps }) {

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

    return newDesc.match(/\w.*?[.!?](?:\s|$|\n)/)
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

  function normalizeWebsite(url) {
    let newUrl = url

    if (newUrl.startsWith('https://')) {
      newUrl = newUrl.substring(8)
    }

    if (newUrl.startsWith('http://')) {
      newUrl = newUrl.substring(7)
    }

    if (newUrl.startsWith('www.')) {
      newUrl = newUrl.substring(4)
    }

    if (newUrl.startsWith('web+urbitgraph://group/')) {
      newUrl = ''
    }

    if (newUrl[newUrl.length - 1] === '/') {
      newUrl = newUrl.substring(0, newUrl.length - 1)
    }

    return newUrl
  }

  function handleGetButtonClick(name, publisher) {
    window.open(`${window.location.origin}/apps/landscape/search/${publisher}/apps/${publisher}/${name}`, '_blank', 'noopener,noreferrer')
  }

  return (
    <div className="table-wrapper">
      <table>
        <thead>
          <th className='index-header'>#</th>
          <th className='icon-header'>ICON</th>
          <th className='app-header'>APP</th>
          <th className='download-header'>DOWNLOAD</th>
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
                  {app.publisher &&
                    <>
                    <br></br>
                    <span className='info-publisher'>{app.publisher}</span>
                    <br></br>
                    </>
                  }
                  {normalizeWebsite(app.docket.website) &&
                    <>
                    <span className='info-website'>
                      <a href={app.docket.website} target='_blank'>{normalizeWebsite(app.docket.website)}</a>
                    </span>
                    <br></br>
                    </>
                  }
                  <span className="info-additional">
                    {app.docket.version &&
                      <>
                        <span>{`v${app.docket.version}`}</span>
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
