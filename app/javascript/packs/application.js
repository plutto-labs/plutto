import { createApp } from 'vue';
import App from '@/app.vue';
import router from '@/router';

import '../css/application.css';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({
    el: '#vue-app',
    components: {
      App,
    },
  });
  app.use(router);
  app.mount('#vue-app');
});
