export default function AppTable({ apps }) {
  console.log('AppTable apps: ', apps)

  function normalizeAppColor(color) {
    return `#${color.slice(2).replace('.', '').toUpperCase()}`;
  }

  function normalizeAppDescription(info) {
    let newDesc = `${info[0].toUpperCase()}${info.substring(1)}`

    if (
      newDesc[newDesc.length -1] !== '.'
      && newDesc[newDesc.length -1] !== '…'
      // TODO handle other punctuation
      ) {
      newDesc = `${newDesc}.`
    }

    if (newDesc.length > 256) {
      newDesc = `${newDesc.substring(0, 256)}…`
    }

    return newDesc
  }

  function handleGetButtonClick(name, publisher) {
    window.open(`${window.location.origin}/apps/landscape/search/${publisher}/apps/${publisher}/${name}`, '_blank', 'noopener,noreferrer')
  }

  return (
    <table>
      <thead>
        <th className='index-header'>#</th>
        <th className='icon-header'>ICON</th>
        <th className='app-header'>APP</th>
        <th className='info-header'></th>
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
                app.docket.color &&
                { backgroundColor: `${normalizeAppColor(app.docket.color)}` }
              }
            >
              {/* TODO Should be app name in docket */}
              {/* TODO All name and app.name should be desk and app.desk */}
              {app.docket.image &&
              <img
              src={app.docket.image}
              alt={`${app.name} app icon`}
              />
              }
            </td>
            <td className='app-name-desc'>
              <span className='app-title'>
                {/* TODO Should be app name in docket */}
                {app.name.toUpperCase()}
              </span>
              &nbsp;
              <span className='app-description'>
                {normalizeAppDescription(app.docket.info)}
              </span>
            </td>
            <td className='app-info'>
              <span className='info-publisher'>{app.publisher}</span><br></br>
              <span className='info-website'>
                <a href={app.docket.website} target='_blank'>{app.docket.website}</a>
                </span><br></br>
              <span className="info-additional">
                {/* TODO add real desk hash */}
                <span>{`v${app.docket.version}`}</span>&nbsp;<span>398ub</span>&nbsp;<span>({app.docket.license})</span>
              </span>
            </td>
            <td className='app-button'>
              <button onClick={() => handleGetButtonClick(app.name, app.publisher)}>GET</button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}
