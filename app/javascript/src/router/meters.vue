<template>
  <main>
    <PluttoHeader
      title="Meters"
      button-text="Add Meter"
      @button-clicked="$router.push({ name: 'new-meter'})"
    />
    <div class="px-6 mt-6">
      <PluttoTable
        class="mt-6"
        :headers="headers"
        :rows="meters"
        :loading="loading"
        @delete-clicked="destroyMeter"
      />
    </div>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoHeader from '../components/plutto-header';

export default {
  components: { PluttoHeader, PluttoTable },
  data() {
    return {
      headers: [
        {
          title: 'info',
          type: 'twoLinesText',
          bigText: 'name',
          smallText: 'meterType',
        },
        {
          title: 'identifier',
          type: 'oneLineText',
        },
        {
          title: 'none',
          type: 'action',
          action: 'delete',
        },
      ],
    };
  },
  computed: {
    ...mapState({
      loading: state => state.meters.loading,
      meters: state => state.meters.meters,
    }),
  },
  async mounted() {
    await this.$store.dispatch('GET_METERS');
  },
  methods: {
    destroyMeter(meter) {
      this.$store.dispatch('DESTROY_METER', meter);
    },
  },
};
</script>
