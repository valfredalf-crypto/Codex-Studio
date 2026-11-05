// Service worker "kill switch": disattiva il vecchio service worker e svuota
// tutte le cache. Serve a eliminare per sempre il problema della "modalità
// browser" sul server locale (la pagina veniva servita dalla cache invece che
// dal server). Non intercetta più nulla: la rete passa diretta.
self.addEventListener('install', () => self.skipWaiting());

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    try {
      const keys = await caches.keys();
      await Promise.all(keys.map((k) => caches.delete(k)));
    } catch (e) { /* ignora */ }
    try { await self.registration.unregister(); } catch (e) { /* ignora */ }
    try {
      const clients = await self.clients.matchAll({ type: 'window' });
      for (const c of clients) { try { c.navigate(c.url); } catch (e) { /* ignora */ } }
    } catch (e) { /* ignora */ }
  })());
});
// Nessun handler 'fetch': tutte le richieste vanno direttamente in rete.
