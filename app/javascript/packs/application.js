import { createApp } from 'vue';
import '../css/application.css';

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp({
    el: '#vue-app',
    components: {
    },
  });
  app.mount('#vue-app');
});
