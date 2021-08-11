<template>
  <main>
    <PluttoHeader
      title="Customers"
      button-text="Add Customer"
    />
    <div class="mt-6 px-6">
      <PluttoTable
        class="mt-6"
        :headers="headers"
        :rows="rows"
      />
    </div>
  </main>
</template>
<script>
import PluttoTable from '@/components/plutto-table';
import PluttoHeader from '../components/plutto-header';

export default {
  components: {
    PluttoTable,
    PluttoHeader,
  },
  data() {
    return {
      headers: [
        {
          title: 'info',
          type: 'twoLinesText',
          bigText: 'name',
          smallText: 'id',
        },
        {
          title: 'plan',
          type: 'oneLineText',
        },
        {
          title: 'status',
          type: 'tag',
        },
        {
          title: 'revenue',
          type: 'oneLineText',
        },
        {
          title: 'none',
          type: 'icon',
        },
      ],

      rows: [
        {
          name: 'Jane Cooper',
          id: 'customer_FFGDS234D23FSSDf',
          plan: 'Plan 1',
          status: true,
          revenue: '$10.000',
        },
        {
          name: 'Jane Cooper',
          id: 'customer_FFGDS234D23FSSDf',
          plan: 'Plan 1',
          status: false,
          revenue: '$10.000',
        },
      ],
    };
  },
};
</script>
