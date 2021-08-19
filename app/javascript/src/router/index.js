
import { createRouter, createWebHashHistory } from 'vue-router';

import Auth from '@/router/auth';
import Customers from '@/router/customers';
import NewCustomer from '@/router/new-customer';
import Plans from '@/router/plans';
import Plan from '@/router/plan';
import NewPlan from '@/router/new-plan';
import Meters from '@/router/meters';
import NewMeter from '@/router/new-meter';
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
      path: '/customers/new',
      name: 'new-customer',
      component: NewCustomer,
      meta: {
        title: 'New Customer | Plutto',
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
      path: '/meters/new',
      name: 'new-meter',
      component: NewMeter,
      meta: {
        title: 'New Meter | Plutto',
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
    next();
    document.title = to.meta.title || 'Plutto';
  }
});

export default router;
