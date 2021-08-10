<template>
  <div>
    <h1>Customers</h1>
    <plutto-table
      :headers="headers"
      :rows="rows"
    />
  </div>
</template>
<script>
import PluttoTable from '@/components/plutto-table';

export default {
  components: {
    PluttoTable,
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
