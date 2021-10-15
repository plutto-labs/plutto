<template>
  <div>
    <canvas ref="chartRef" />
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import Chart from 'chart.js/auto';

export default {
  props: {
    datasets: {
      type: Object,
      default: () => {},
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
      labels: Object.keys(props.datasets[Object.keys(props.datasets)[0]]),
      datasets: [],
    };

    const config = {
      type: 'bar',
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
          leyend: {
            display: true,
            position: 'top',
            labels: {
              color: 'rgb(255, 99, 132)',
            },
          },
        },
        scales: {
          x: { stacked: true },
          y: { stacked: true, beginAtZero: true },
        },
      },
    };

    let chart;

    onMounted(() => {
      const ctx = chartRef.value.getContext('2d');
      chart = new Chart(ctx, config);
      Object.keys(props.datasets).forEach((key) => {
        const dataset = {
          label: key,
          data: Object.values(props.datasets[key]),
          backgroundColor:
            ['#ffea00', '#dbc900', '#a89a00', '#756c00', '#423d00'][Object.keys(props.datasets).indexOf(key)],
        };
        data.datasets.push(dataset);
      });
      chart.data.datasets = data.datasets;
      chart.update();
    });

    return { chartRef };
  },
};
</script>
