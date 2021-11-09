import { createApp } from 'vue';
import { createI18n } from 'vue-i18n';

import App from '@/app.vue';
import Widget from '@/widget.vue';
import router from '@/router';
import store from '@/store';

import Locales from '@/locales/locales.js';
import FormatterMixin from '@/mixins/formatter-mixin';
import Segment from '@/mixins/segment';

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
      App, Widget,
    },
  });
  app.config.globalProperties.environment = window.location.host.split('.')[0];
  app.use(router);
  app.use(store);
  app.use(i18n);
  app.mixin(FormatterMixin);
  app.mixin(Segment);
  app.mount('#vue-app');
});
