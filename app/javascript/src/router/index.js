
import { createRouter, createWebHashHistory } from 'vue-router';

import Auth from '@/router/auth';
import Customers from '@/router/customers';
import Plans from '@/router/plans';
import Plan from '@/router/plan';
import Meters from '@/router/meters';
import Settings from '@/router/settings';
import store from '@/store';

const router = createRouter({
  history: createWebHashHistory('/'),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: Auth,
      meta: {
        title: 'Login | Plutto',
      },
    },
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
        authRequired: true,
      },
    }, {
      path: '/plans',
      name: 'plans',
      component: Plans,
      meta: {
        title: 'Plans | Plutto',
        authRequired: true,
      },
    }, {
      path: '/plan/:id',
      name: 'plan',
      component: Plan,
      meta: {
        title: 'Plan | Plutto',
        authRequired: true,
      },
    }, {
      path: '/meters',
      name: 'meters',
      component: Meters,
      meta: {
        title: 'Meters | Plutto',
        authRequired: true,
      },
    }, {
      path: '/settings',
      name: 'settings',
      component: Settings,
      meta: {
        title: 'Settings | Plutto',
        authRequired: true,
      },
    },
  ],
});

router.beforeEach((to, from, next) => {
  const user = store.state.auth;
  if (to.meta.authRequired && !user.token) {
    next(`/login?redirect_to=${to.fullPath}`);
    document.title = 'Ingresar | Milla';
  } else {
    if (analytics) {
      analytics.page(to.name, {
        title: to.meta.title,
        path: to.path,
        referrer: from.path,
      });
    }
    next();
    document.title = to.meta.title || 'Plutto';
  }
});

export default router;
