// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "chartkick"
import "Chart.bundle"
import "controllers"

document.addEventListener('DOMContentLoaded', () => {
  intializeOriginalUrlInputEventListener();
  initializeGeoChart();
});

const intializeOriginalUrlInputEventListener  = () => {
  const originalUrlInput = document.getElementById('link_original_url');
  const titleInput = document.getElementById('link_title');

  if (originalUrlInput) {
    originalUrlInput.addEventListener('blur', async () => {
      const url = originalUrlInput.value;
      if (url) {
        try {
          const response = await fetch(`/links/fetch_title?original_url=${encodeURIComponent(url)}`);
          const data = await response.json();
          if (data.title) {
            titleInput.value = data.title;
          }
        } catch (error) {
          console.error('Error fetching title:', error);
        }
      }
    });
  }
}

const initializeGeoChart = () => {
  google.charts.load('current', {
    packages: ['geochart'],
  });

  google.charts.setOnLoadCallback(drawRegionsMap);

  function drawRegionsMap() {
    const jsonData = JSON.parse(document.getElementById('geo-chart-data').textContent);

    const data = new google.visualization.DataTable();
    data.addColumn('string', 'Country');
    data.addColumn('number', 'Visits');

    jsonData.forEach(item => {
      data.addRow([item.country, item.visits]);
    });

    const options = {
      colorAxis: { colors: ['#e0f7fa', '#006064'] },
      legend: { textStyle: { color: 'black', fontSize: 14 } },
    };

    const chart = new google.visualization.GeoChart(document.getElementById('regions_div'));
    chart.draw(data, options);

    // Adjust the chart size on window resize
    window.addEventListener('resize', () => chart.draw(data, options));
  }
}
