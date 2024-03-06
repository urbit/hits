export default function AppTable({ apps }) {
  console.log('AppTable apps: ', apps)

    return (
      <table>
        <thead>
          <th>#</th>
          <th>ICON</th>
          <th>INFO</th>
          <th>DOWNLOAD ↓</th>
        </thead>
        <tbody>
          {apps.map((app, index) => (
            <tr key={index + 1}>
              <td>
                {index + 1}
              </td>
              <td >
                {/* TODO handle null cases where there's no icon */}
                <img
                src={app.docket.image}
                alt={`${app.name} app icon`}
                />
              </td>
              <td>
                <span className='app-title'>
                  {app.name.toUpperCase()}
                </span>
                <span className='app-description'>
                  {/* TODO enforce sentence case */}
                  {app.docket.info}
                </span>
              </td>
              <td>
                <button className='get-app-button'>GET</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    )
  }
