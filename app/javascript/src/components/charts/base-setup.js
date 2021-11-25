import { ref } from 'vue';

export default function chartApi() {
  function constants(datasets, type, title) {
    const chartRef = ref(null);

    const data = {
      labels: Object.keys(datasets[Object.keys(datasets)[0]]),
      datasets: [],
    };

    const config = {
      type,
      data,
      options: {
        responsive: true,
        spanGaps: true,
        plugins: {
          legend: {
            display: false,
          },
          title: {
            display: true,
            text: title,
            color: '#5691f0',
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

    return { chartRef, data, config };
  }

  function updateChartData(data, props, chart) {
    data.datasets = [];
    Object.keys(props.datasets).forEach((key) => {
      const dataset = {
        label: key,
        data: Object.values(props.datasets[key]),
        backgroundColor:
        ['#0f1323', '#282a3a', '#5b5d6b', '#777986', '#b3b5bd'][Object.keys(props.datasets).indexOf(key)],
        borderColor:
          ['#0f1323', '#282a3a', '#5b5d6b', '#777986', '#b3b5bd'][Object.keys(props.datasets).indexOf(key)],
        pointBackgroundColor:
          ['#0f1323', '#282a3a', '#5b5d6b', '#777986', '#b3b5bd'][Object.keys(props.datasets).indexOf(key)],
      };
      data.datasets.push(dataset);
    });
    chart.data.datasets = data.datasets;
    chart.update();
  }

  return {
    constants,
    updateChartData,
  };
}
