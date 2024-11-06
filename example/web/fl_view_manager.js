/**
 * For convenience, the glue code (js side) between
 * flutter and js is written in js instead of ts,
 * but I provide a complete jsdoc for type hints.
 */

/**
 * a duck-typed flutter app object definition
 * @typedef {{
 * addView: (args:{hostElement: HTMLElement}) => number,
 * removeView: (viewId: number) => void
 * }} FlApp
 */

/**
 * flutter view manager
 *
 * get the singleton instance of FlViewManager by calling
 * `FlViewManager.instance` or `new FlViewManager()`,
 * they are equivalent.
 */
class FlViewManager {
    /**
     * @type {null | FlViewManager}
     */
    static #singleton = null

    /**
     * accessor for the singleton instance of FlViewManager
     * @return {FlViewManager}
     */
    static get instance() {
        return new FlViewManager();
    }

    /**
     * whether log is enabled
     * @type {boolean}
     */
    static #logEnabled = true

    /**
     * log delegate
     *
     * @param {'log' | 'warn' | 'error'} fn
     * @param {any} args
     */
    static #log(fn, ...args) {
        if (FlViewManager.#logEnabled) console[fn](...args)
    }

    /**
     * enable or disable log behavior
     * @param enable {boolean}
     */
    static enableLog(enable) {
        FlViewManager.#logEnabled = enable
    }

    /**
     * alias for {@link FlViewManager.enableLog}
     */
    enableLog = FlViewManager.enableLog

    /**
     * accessor for the flutter app object
     * @return {FlApp}
     */
    get #flApp() {
        if (!window.$isFlutterApp) {
            throw new Error('FlViewManager can only be used in a flutter app');
        }
        return window.$flApp;
    }

    /**
     * a map of all the views that have been registered,
     * mapping from host element to view id.
     * @type {Map<HTMLElement, number>}
     */
    #flViews = new Map();

    /**
     * number of views that have been registered
     * @return {number}
     */
    get numOfViews() {
        return this.#flViews.size;
    }

    /**
     * factory method to create a singleton instance of FlViewManager
     */
    constructor() {
        if (!FlViewManager.#singleton) FlViewManager.#singleton = this;
        return FlViewManager.#singleton;
    }

    /**
     * add a flutter view to the host element,
     * if the host element already has a view attached to it,
     * the old view will be dropped automatically.
     * @param host {HTMLElement} the host element to add the view to
     */
    addView(host) {
        // 1. drop the previous view if any
        const previousViewId = this.#flViews.get(host);
        // => since the viewId may be 0, we need to check if it is undefined rather than falsy
        if (previousViewId !== undefined) {
            this.#flApp.removeView(previousViewId);
            FlViewManager.#log('log', `previous view ${previousViewId} removed`);
        }

        // 2. add the new view and update the view map
        const viewId = this.#flApp.addView({hostElement: host});
        this.#flViews.set(host, viewId);

        // OPTIMIZE: listen to host element's lifecycle and remove the view when it is removed from the DOM
    }

    /**
     * remove a flutter view from the host element
     * @param host {HTMLElement} the host element to remove the view from
     */
    removeView(host) {
        const viewId = this.#flViews.get(host);
        if (viewId === undefined) {
            FlViewManager.#log('warn', `view not found for host element ${host}`);
            return;
        }

        this.#flApp.removeView(viewId);
        this.#flViews.delete(host);
    }
}

export {
    FlViewManager,
}