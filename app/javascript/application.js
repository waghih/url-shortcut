// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('DOMContentLoaded', () => {
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
});
