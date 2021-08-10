
import { createRouter, createWebHistory } from 'vue-router';

import App from '@/components/app';

const router = createRouter({
  history: createWebHistory('/'),
  routes: [
    {
      path: '/home',
      name: 'home',
      component: App,
      meta: {
        title: 'Plutto',
      },
    },
  ],
});

router.beforeEach((to, from, next) => {
  next();
  document.title = to.meta.title || 'Plutto';
});

export default router;
