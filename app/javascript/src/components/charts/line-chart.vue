<template>
  <div>
    <canvas ref="chartRef" />
  </div>
</template>

<script>
import { onMounted, watch } from 'vue';
import Chart from 'chart.js/auto';
import chartApi from './base-setup.js';

export default {
  props: {
    label: {
      type: String,
      default: null,
    },
    title: {
      type: String,
      default: null,
    },
    datasets: {
      type: Object,
      default: () => {},
    },
  },

  setup(props) {
    const { chartRef, data, config } = chartApi().constants(props.datasets, 'line', props.title);

    let chart;

    watch(
      () => props.datasets,
      () => { chartApi().updateChartData(data, props, chart); },
      { deep: true },
    );

    onMounted(() => {
      const ctx = chartRef.value.getContext('2d');
      chart = new Chart(ctx, config);
      chartApi().updateChartData(data, props, chart);
    });

    return { chartRef };
  },
};
</script>
