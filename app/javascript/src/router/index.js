
import { createRouter, createWebHashHistory } from 'vue-router';

import Auth from 'src/router/auth';
import Customers from 'src/router/customers';
import Plans from 'src/router/plans';
import NewPlan from '@/router/new-plan';
import Meters from '@/router/meters';
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
      path: '/plans/new',
      name: 'new-plan',
      component: NewPlan,
      meta: {
        title: 'New Plan | Plutto',
      },
    }, {
      path: '/meters',
      name: 'meters',
      component: Meters,
      meta: {
        title: 'Meters | Plutto',
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
    next();
    document.title = to.meta.title || 'Plutto';
  }
});

export default router;
