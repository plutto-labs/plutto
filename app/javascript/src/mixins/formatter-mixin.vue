<script>
import currencies from '../../../../config/currencies.json';

export default {
  data() {
    return {
      CURRENCIES: currencies,
      CURRENCY_KEYS: Object.keys(currencies),
    };
  },
  methods: {
    formatCurrency(val, currency = 'CLP') {
      return new Intl.NumberFormat('pt-BR', { style: 'currency', currency }).format(val);
    },
  },
};
</script>
