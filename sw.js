// sw.js
self.addEventListener('install', () => {
  event.waitUntil(
    caches.open('static').then((cache) => {
      return cache.addAll([
        '/',
        '/flatbar_projects.github.io/main_landing.html',
        '/flatbar_projects.github.io/flatbar_calculator.html',
        '/flatbar_projects.github.io/flatbar_report.html',
        '/flatbar_projects.github.io/flatbar_schedule.html',
        '/flatbar_projects.github.io/flatbar_stock_input.html',
        '/flatbar_projects.github.io/flatbarsection_landing.html',
        '/flatbar_projects.github.io/inbound_input.html',
        '/flatbar_projects.github.io/pipe_count_tool.html',
        '/flatbar_projects.github.io/ring.wav',
        '/flatbar_projects.github.io/typeb_stock_report.html',
        '/flatbar_projects.github.io/typeb_webapp.html',
        '/flatbar_projects.github.io/updatestock_input.html',
        '/flatbar_projects.github.io/version_history.log',
        '/flatbar_projects.github.io/wood_memo.html',
        '/flatbar_projects.github.io/typebsection_landing.html'
      ]);
    })
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(clients.claim());
});
