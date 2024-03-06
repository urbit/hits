export default function AppTable({ apps }) {
  console.log('AppTable apps: ', apps)

  function normalizeAppColor(color) {
    // TODO is this necessary?
    // if (color.startsWith('#')) {
    //   return color;
    // }
    return `#${color.slice(2).replace('.', '').toUpperCase()}`;
  }

  function normalizeAppDescription(info) {
    let newDesc = `${info[0].toUpperCase()}${info.substring(1)}`

    if (
      newDesc[newDesc.length -1] !== '.'
      && newDesc[newDesc.length -1] !== '…'
      ) {
      newDesc = `${newDesc}.`
    }

    if (newDesc.length > 256) {
      newDesc = `${newDesc.substring(0, 256)}…`
    }

    return newDesc
  }

  return (
    <table>
      <thead>
        <th className='index-header'>#</th>
        <th className='icon-header'>ICON</th>
        <th className='app-header'>APP</th>
        <th className='info-header'>INFO</th>
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
              {app.docket.image &&
              <img
              src={app.docket.image}
              alt={`${app.name} app icon`}
              />
              }
            </td>
            <td className='app-info'>
              <span className='app-title'>
                {app.name.toUpperCase()}
              </span>
              <span className='app-description'>
                {normalizeAppDescription(app.docket.info)}
              </span>
            </td>
            <td className='app-info'>
              metadata
            </td>
            <td className='app-button'>
              <button >GET</button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}
