<template>
  <div>
    Active users
  </div>
</template>

<script>
import { mapState } from 'vuex';
import PluttoTable from '@/components/plutto-table';

export default {
  components: {
    PluttoTable,
  },
  data() {
    return {
      headers: [{
        title: 'info',
        type: 'twoLinesText',
        bigText: 'name',
        smallText: 'email',
      }, {
        title: 'identifier',
        type: 'oneLineText',
      }, {
        title: 'id',
        type: 'copyableLine',
      }, {
        title: 'planSubscription',
        type: 'component',
      }, {
        title: 'none',
        type: 'action',
        action: 'edit',
      }],
    };
  },
};
</script>
