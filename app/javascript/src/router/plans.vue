<template>
  <main>
    <PluttoHeader
      title="Plans"
      button-text="Add Plan"
    />
    <div class="px-6 mt-6">
      <PluttoLoader
        v-if="loading"
      />
      <button
        class="btn btn--big"
        @click="$store.dispatch('setLoading', !loading)"
      >
        Cargar
      </button>
    </div>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoHeader from '../components/plutto-header';
import PluttoLoader from '../components/plutto-loader';

export default {
  components: { PluttoHeader, PluttoLoader },
  computed: {
    ...mapState({
      loading: state => state.ui.loading,
    }),
  },
};
</script>
