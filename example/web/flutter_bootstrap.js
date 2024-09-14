{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
    onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
        const engine = await engineInitializer.initializeEngine({
            multiViewEnabled: true, // Enables embedded mode.
        });
        const app = await engine.runApp();
        window.app = app
        // const viewId = app.addView({hostElement: document.getElementById('app')})
        // console.log('addView', viewId)
        // Make this `app` object available to your JS app.
    }
});

// https://docs.flutter.cn/platform-integration/web/embedding-flutter-web/
// https://docs.flutter.dev/platform-integration/web/embedding-flutter-web#embedded-mode
// https://docs.flutter.dev/platform-integration/web/initialization
// https://docs.flutter.cn/platform-integration/web/initialization