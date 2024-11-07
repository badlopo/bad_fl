{{flutter_js}}
{{flutter_build_config}}

// https://docs.flutter.dev/platform-integration/web/initialization

/**
 * @param {boolean} multiViewEnabled
 */
const setup_flutter=  (multiViewEnabled) => {
    _flutter.loader.load({
        onEntrypointLoaded: async function(engineInitializer) {
            // Initialize the engine.
            const engine = await engineInitializer.initializeEngine({
                multiViewEnabled: multiViewEnabled,
            });

            // Run the app and make this `app` object available to your JS app.
            window.$flApp = await engine.runApp();
        }
    });
}

setup_flutter(false);