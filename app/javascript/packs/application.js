import { createApp } from 'vue';
import App from '@/components/app.vue';
import '../css/application.css';

import router from '../router';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({
    el: '#vue-app',
    router,
    components: {
      App,
    },
  });
  app.mount('#vue-app');
});
