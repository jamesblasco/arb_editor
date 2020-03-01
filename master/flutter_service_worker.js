'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/main.dart.js_2.part.js.map": "25f3282cbe8da13198fc026a20204497",
"/assets/LICENSE": "fd8cedb8c0f6f8d8679f13032969ff0a",
"/assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/metadata/ms-icon-150x150.png": "b5292d49409e75a395618e6fc00ef00e",
"/assets/metadata/android-icon-192x192.png": "25b969965c0bc8335fe0ce9a3db27bf6",
"/assets/metadata/ms-icon-70x70.png": "2242e03af836d70d8dd8b6e02edd643f",
"/assets/metadata/android-icon-144x144.png": "ee2a72b5a11f17a2ac85743bf12c1cf7",
"/assets/metadata/apple-icon-144x144.png": "ee2a72b5a11f17a2ac85743bf12c1cf7",
"/assets/metadata/favicon-96x96.png": "37b18e5f7345f8835a67f6abdd99863b",
"/assets/metadata/apple-icon-180x180.png": "b4857564adc5f5c67a35926bde932ff6",
"/assets/metadata/apple-icon-72x72.png": "395a124efd32836cbec520433bedd579",
"/assets/metadata/apple-icon-precomposed.png": "c67b81e2dd9f107f944b015cdae31ec2",
"/assets/metadata/android-icon-36x36.png": "f98f073bf77fe8f8e7fa5de633c45c5d",
"/assets/metadata/apple-icon.png": "c67b81e2dd9f107f944b015cdae31ec2",
"/assets/metadata/ms-icon-144x144.png": "ee2a72b5a11f17a2ac85743bf12c1cf7",
"/assets/metadata/favicon-16x16.png": "a75b02e9c178ea0ccd158fc9e540fa89",
"/assets/metadata/apple-icon-114x114.png": "51fc68aa94b0821c7079645439e50097",
"/assets/metadata/manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"/assets/metadata/favicon.ico": "544b9058898d513812d327a88f758b32",
"/assets/metadata/apple-icon-57x57.png": "4b2ce8e627135c1885723a73996e8992",
"/assets/metadata/apple-icon-152x152.png": "1c89e34d279c4bd91f79bc33bf71b8c8",
"/assets/metadata/favicon-32x32.png": "6cd2bd59520bd45a1eed4124bf50cc60",
"/assets/metadata/ms-icon-310x310.png": "6e33600220eb2d8677aab820b2a1dc89",
"/assets/metadata/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"/assets/metadata/apple-icon-76x76.png": "029e4d9ae4c27f1de3522d2a4ebad3d5",
"/assets/metadata/apple-icon-60x60.png": "0cd9ce90ba56f0ad068b08aec3fe25f1",
"/assets/metadata/apple-icon-120x120.png": "7c3ad41f65ac98a730cb27c96b8abd62",
"/assets/metadata/android-icon-96x96.png": "37b18e5f7345f8835a67f6abdd99863b",
"/assets/metadata/android-icon-72x72.png": "395a124efd32836cbec520433bedd579",
"/assets/metadata/android-icon-48x48.png": "7627e330f75a73dbca1eabd1fbc7ffb6",
"/assets/images/github.png": "472739dfb5857b1f659f4c4c6b4568d0",
"/assets/images/arb-editor.png": "cc368c8cb746730ffbd775bff11f3246",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/AssetManifest.json": "9bed2bb768f4b54ac5fc2ad28cced8c4",
"/index.html": "f29394817b39bad0b38a8a671210cabb",
"/main.dart.js_1.part.js": "4dd76507ed32000319bfd948ab8ff11c",
"/main.dart.js": "4262aab98c2dbb1ab96c91ca8f1a0518",
"/main.dart.js_3.part.js.map": "10988b94ede5c1df0163ee005aba280a",
"/main.dart.js_1.part.js.map": "2c2b6d2db48c361d2e9d41a072487da0",
"/main.dart.js_3.part.js": "e34af042a0a856167406dc5d682127d2",
"/main.dart.js_2.part.js": "ed149d02ea8a2d95bfdd114aaae792c3"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
