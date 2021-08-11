<template>
  <main>
    <form
      class="py-16 md:px-8 px-4 mx-4 md:m-auto top-20 rounded-2xl text-center bg-transparent relative md:w-96"
      @submit.prevent="submitForm"
    >
      <div class="text-3xl">
        Plutto
      </div>
      <div class="plutto-input mt-8">
        <span class="plutto-input__icon text-primary">mail_outline</span>
        <input
          required
          type="email"
          class="plutto-input__input"
          placeholder="email"
          v-model="login.email"
        >
      </div>
      <div class="plutto-input mt-4 mb-8">
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
        class="btn btn--filled w-full h-10"
        v-else
      >
        Login
      </button>
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
