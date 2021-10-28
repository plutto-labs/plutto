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

    return { chartRef, data, config };
  }

  function updateChartData(data, props, chart) {
    data.datasets = [];
    Object.keys(props.datasets).forEach((key) => {
      const dataset = {
        label: key,
        data: Object.values(props.datasets[key]),
        backgroundColor:
        ['#ffea00', '#dbc900', '#a89a00', '#756c00', '#423d00'][Object.keys(props.datasets).indexOf(key)],
        borderColor:
          ['#ffea00', '#dbc900', '#a89a00', '#756c00', '#423d00'][Object.keys(props.datasets).indexOf(key)],
        pointBackgroundColor:
          ['#ffea00', '#dbc900', '#a89a00', '#756c00', '#423d00'][Object.keys(props.datasets).indexOf(key)],
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
