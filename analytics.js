/* DucyDrive support website: optional, consent-first GA4 measurement. */
(() => {
  'use strict';
  const measurementId = 'G-Z6FZC2CEDK';
  const preferenceKey = 'ducydrive_support_analytics_v1';
  const blocked = navigator.globalPrivacyControl === true || navigator.doNotTrack === '1';
  let started = false;
  const status = document.getElementById('analytics-status');
  const enable = document.getElementById('analytics-enable');
  const disable = document.getElementById('analytics-disable');
  const readPreference = () => { try { return localStorage.getItem(preferenceKey); } catch (_) { return null; } };
  const remember = value => { try { localStorage.setItem(preferenceKey, value); } catch (_) {} };
  const updateControls = active => {
    if (status) status.textContent = blocked ? 'Analytics off (browser privacy preference).' : active ? 'Analytics enabled.' : 'Analytics off.';
    if (enable) { enable.hidden = active || blocked; }
    if (disable) disable.hidden = !active;
  };
  const start = () => {
    if (started || blocked) return;
    started = true;
    window['ga-disable-' + measurementId] = false;
    window.dataLayer = window.dataLayer || [];
    window.gtag = function () { window.dataLayer.push(arguments); };
    window.gtag('consent', 'default', {analytics_storage:'granted', ad_storage:'denied', ad_user_data:'denied', ad_personalization:'denied'});
    window.gtag('js', new Date());
    let referrer = '';
    try { referrer = document.referrer ? new URL(document.referrer).origin : ''; } catch (_) {}
    window.gtag('config', measurementId, {
      send_page_view:false, allow_google_signals:false,
      allow_ad_personalization_signals:false, cookie_prefix:'ducydrive',
      cookie_expires:31536000, page_location:location.origin + location.pathname,
      page_referrer:referrer, page_title:document.title
    });
    window.gtag('event', 'page_view', {page_location:location.origin + location.pathname, page_referrer:referrer, page_title:document.title});
    const script = document.createElement('script');
    script.async = true;
    script.src = 'https://www.googletagmanager.com/gtag/js?id=' + encodeURIComponent(measurementId);
    document.head.appendChild(script);
    updateControls(true);
  };
  if (enable) enable.addEventListener('click', () => { remember('granted'); start(); });
  if (disable) disable.addEventListener('click', () => {
    remember('denied');
    window['ga-disable-' + measurementId] = true;
    if (window.gtag) window.gtag('consent', 'update', {analytics_storage:'denied'});
    for (const part of document.cookie.split(';')) {
      const name = part.split('=')[0].trim();
      if (!name.startsWith('ducydrive_')) continue;
      for (const domain of ['', '; domain=' + location.hostname, '; domain=.' + location.hostname])
        document.cookie = name + '=; Max-Age=0; path=/' + domain + '; SameSite=Lax; Secure';
    }
    updateControls(false);
    location.reload();
  });
  document.addEventListener('click', event => {
    const link = event.target.closest && event.target.closest('a[href]');
    if (!link || !started || readPreference() !== 'granted' || blocked) return;
    let url;
    try { url = new URL(link.href); } catch (_) { return; }
    if (url.hostname !== 'play.google.com' || url.pathname !== '/store/apps/details' || url.searchParams.get('id') !== 'com.michaelducylowycz.duchydriveaiousbtools') return;
    const ref = new URLSearchParams(url.searchParams.get('referrer') || '');
    window.gtag('event', 'google_play_click', {
      page_path:location.pathname, campaign_source:'ducydrive_support',
      campaign_medium:'owned', campaign_name:ref.get('utm_campaign') || 'website',
      link_placement:ref.get('utm_content') || 'website_link', transport_type:'beacon'
    });
  });
  updateControls(false);
  if (readPreference() === 'granted') start();
})();
