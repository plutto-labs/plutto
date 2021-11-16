<template>
  <main>
    <form
      class="relative px-4 py-16 mx-4 text-center bg-transparent md:px-8 md:m-auto top-20 rounded-2xl md:w-96"
      @submit.prevent="submitForm"
    >
      <div class="text-3xl">
        Plutto
      </div>
      <div class="mt-8 plutto-input">
        <span class="plutto-input__icon text-primary">mail_outline</span>
        <input
          required
          type="email"
          class="plutto-input__input"
          placeholder="email"
          v-model="login.email"
        >
      </div>
      <div class="mt-4 text-sm text-right text-blue-800 underline cursor-pointer">
        Forgot password?
      </div>
      <div class="mb-8 plutto-input">
        <span class="plutto-input__icon text-primary">password</span>
        <input
          required
          type="password"
          class="plutto-input__input"
          placeholder="password"
          v-model="login.password"
        >
      </div>
      <PluttoLoader
        v-if="sending"
      />
      <button
        class="w-full h-10 btn btn--filled"
        v-else
      >
        Login
      </button>
      <a
        class="text-sm text-left text-blue-800 underline cursor-pointer"
        href="/widget#/sign-up"
      >
        Don't have an account?
      </a>
    </form>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoLoader from '../components/plutto-loader';

export default {
  components: { PluttoLoader },
  data() {
    return {
      login: {
        email: null,
        password: null,
      },
      sending: false,
      error: null,
    };
  },
  computed: {
    ...mapState({
      currentUser: state => state.auth,
    }),
  },
  methods: {
    async submitForm() {
      this.sending = true;
      this.error = null;

      return this.$store.dispatch('LOGIN_USER', this.login)
        .then(() => {
          if (this.$route.query && this.$route.query.redirect_to) {
            this.$router.replace(this.$route.query.redirect_to);
          } else {
            this.$router.replace('/');
          }
        })
        .catch((err) => {
          this.error = err.response;
        })
        .finally(() => {
          this.sending = false;
        });
    },
  },
};
</script>
