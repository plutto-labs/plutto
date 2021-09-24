<script>
export default {
  methods: {
    invoiceStatusTags() {
      const tags = {
        new: 'purple',
        posted: 'blue',
        paid: 'green',
        notPaid: 'red',
        voided: 'yellow',
      };

      return tags;
    },
  },
};
</script>
