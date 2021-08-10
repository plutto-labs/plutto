
import { createRouter, createWebHashHistory } from 'vue-router';

import Customers from 'src/router/customers';
import Plans from 'src/router/plans';

const router = createRouter({
  history: createWebHashHistory('/'),
  routes: [
    {
      path: '/',
      name: 'home',
      redirect: {
        name: 'customers',
      },
    },
    {
      path: '/customers',
      name: 'customers',
      component: Customers,
      meta: {
        title: 'Customers | Plutto',
      },
    }, {
      path: '/plans',
      name: 'plans',
      component: Plans,
      meta: {
        title: 'Plans | Plutto',
      },
    },
  ],
});

router.beforeEach((to, from, next) => {
  next();
  document.title = to.meta.title || 'Plutto';
});

export default router;
