export default function AppTable({ apps }) {
  console.log('AppTable apps: ', apps)

  function normalizeUrbitColor(color) {
    // TODO is this necessary?
    // if (color.startsWith('#')) {
    //   return color;
    // }
    return `#${color.slice(2).replace('.', '').toUpperCase()}`;
  }

  return (
    <table>
      <thead>
        <th>#</th>
        <th>ICON</th>
        <th className='app-header'>APP</th>
        <th className='info-header'>INFO</th>
        <th>DOWNLOAD</th>
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
                { backgroundColor: `${normalizeUrbitColor(app.docket.color)}` }
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
                {/* TODO enforce sentence case */}
                {app.docket.info}
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
