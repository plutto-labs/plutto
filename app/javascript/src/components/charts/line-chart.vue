<template>
  <div>
    <canvas ref="chartRef" />
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue';
import Chart from 'chart.js/auto';

export default {
  props: {
    labels: {
      type: Array,
      default: () => [],
    },
    data: {
      type: Array,
      default: () => [],
    },
    label: {
      type: String,
      default: null,
    },
    title: {
      type: String,
      default: null,
    },
  },

  setup(props) {
    const chartRef = ref(null);

    const data = {
      labels: props.labels,
      datasets: [
        {
          label: props.label,
          data: props.data,
          fill: true,
          pointBackgroundColor: '#a89a00',
          tension: 0.1,
          borderColor: '#a89a00',
        },
      ],

    };

    const config = {
      type: 'line',
      data,
      options: {
        responsive: true,
        plugins: {
          legend: {
            display: false,
          },
          title: {
            display: true,
            text: props.title,
            color: '#a89a00',
            padding: {
              top: 10,
              bottom: 15,
            },
          },
        },
        scales: {
          y: { beginAtZero: true },
        },
      },
    };

    let chart;

    watch(
      () => props.data,
      () => props.labels,
      () => {
        chart.data.datasets[0].data = props.data;
        chart.data.labels = props.labels;
        chart.update();
      },
    );

    onMounted(() => {
      const ctx = chartRef.value.getContext('2d');
      chart = new Chart(ctx, config);
    });

    return { chartRef };
  },
};
</script>
