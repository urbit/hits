import Urbit from '@urbit/http-api';

function scryUrbit(app, path) {
  const api = new Urbit('');
  return api.scry({
    app: app,
    path: path
  });
}

export async function scryCharges() {
  const response = await scryUrbit('docket', '/charges')
  return response.initial
}
