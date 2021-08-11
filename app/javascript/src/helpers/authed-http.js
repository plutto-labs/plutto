import axios from 'axios';
import store from '../store';

const authedAxios = axios.create();

authedAxios.interceptors.request.use(
  config => {
    config.headers['X-User-Token'] = store.state.auth.token;
    config.headers['X-User-Email'] = store.state.auth.email;
    config.headers['Content-Type'] = 'application/json';

    return config;
  },
  error => Promise.reject(error),
);

export default authedAxios;
