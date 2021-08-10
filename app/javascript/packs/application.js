import { createApp } from 'vue';
import '../css/application.css';

import router from '../router';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({
    el: '#vue-app',
    router,
    components: {
    },
  });
  app.mount('#vue-app');
});
