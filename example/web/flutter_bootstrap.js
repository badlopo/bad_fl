{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
    onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
        let engine = await engineInitializer.initializeEngine({
            multiViewEnabled: true, // Enables embedded mode.
        });
        let app = await engine.runApp();
        console.log(app)
        // Make this `app` object available to your JS app.
    }
});