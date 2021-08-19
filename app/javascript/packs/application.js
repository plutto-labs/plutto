import { createApp } from 'vue';
import { createI18n } from 'vue-i18n';

import App from '@/app.vue';
import router from '@/router';
import store from '@/store';

import Locales from '@/locales/locales.js';

import '@/helpers/validation-rules.js';
import '../css/application.css';

document.addEventListener('DOMContentLoaded', () => {
  const i18n = createI18n({
    locale: 'en',
    messages: Locales.messages,
  });
  const app = createApp({
    el: '#vue-app',
    components: {
      App,
    },
  });
  app.use(router);
  app.use(store);
  app.use(i18n);
  app.mount('#vue-app');
});
