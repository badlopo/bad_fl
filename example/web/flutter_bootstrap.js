{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
    onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
        // Initialize the engine.
        const engine = await engineInitializer.initializeEngine({
            // Enables embedded mode.
            multiViewEnabled: true,
        });

        // Run the app and make this `app` object available to your JS app.
        window.$flApp = await engine.runApp();
    }
});