<script>
export default {
  methods: {
    formatCurrency(val, currency = 'CLP') {
      return new Intl.NumberFormat('pt-BR', { style: 'currency', currency }).format(val);
    },
  },
};
</script>
