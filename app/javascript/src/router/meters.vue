<template>
  <main>
    <PluttoHeader
      button-text="Add Meter"
      @button-clicked="showNewMeterForm = true"
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
    <PluttoModal
      :showing="showNewMeterForm"
      @close="showNewMeterForm = false"
    >
      <NewMeterForm
        @created-meter="meter => showNewMeterForm = false"
      />
    </PluttoModal>
  </main>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';
import PluttoHeader from '@/components/plutto-header';
import PluttoModal from '@/components/plutto-modal';
import NewMeterForm from '@/components/forms/new-meter-form';

export default {
  components: { PluttoHeader, PluttoTable, PluttoModal, NewMeterForm },
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
          title: 'id',
          type: 'oneLineText',
        },
        {
          title: 'none',
          type: 'action',
          action: 'delete',
        },
      ],
      showNewMeterForm: false,
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
