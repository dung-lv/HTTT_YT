Ext.define('Ext.overrides.util.Event', {
    override: 'Ext.util.Event',
    removeListener: function (fn, scope, index) {
        var me = this,
            removed = false,
            observable = me.observable,
            eventName = me.name,
            listener, options, manager, managedListeners, managedListener, i;
        index = index != null ? index : me.findListener(fn, scope);
        if (index !== -1) {
            listener = me.listeners[index];
            if (me.firing) {
                me.listeners = me.listeners.slice(0);
            }
            // Remove this listener from the listeners array. We can use splice directly here.
            // The IE8 bug which Ext.Array works around only affects *insertion*
            // http://social.msdn.microsoft.com/Forums/en-US/iewebdevelopment/thread/6e946d03-e09f-4b22-a4dd-cd5e276bf05a/
            me.listeners.splice(index, 1);
            // if the listeners array contains negative priority listeners, adjust the
            // internal index if needed.
            if (me._highestNegativePriorityIndex) {
                if (index < me._highestNegativePriorityIndex) {
                    me._highestNegativePriorityIndex--;
                } else if (index === me._highestNegativePriorityIndex && index === me.listeners.length) {
                    delete me._highestNegativePriorityIndex;
                }
            }
            if (listener) {
                options = listener.o;
                // cancel and remove a buffered handler that hasn't fired yet.
                // When the buffered listener is invoked, it must check whether
                // it still has a task.
                if (listener.task) {
                    listener.task.cancel();
                    delete listener.task;
                }
                // cancel and remove all delayed handlers that haven't fired yet
                i = listener.tasks && listener.tasks.length;
                if (i) {
                    while (i--) {
                        listener.tasks[i].cancel();
                    }
                    delete listener.tasks;
                }
                // Cancel the timer that could have been set if the event has already fired
                if (listener.fireFn && listener.fireFn.hasOwnProperty('timerId') && typeof listener.fireFn.timerId != undefined) {
                    listener.fireFn.timerId = Ext.undefer(listener.fireFn.timerId);
                }
                manager = listener.manager;
                if (manager) {
                    // If this is a managed listener we need to remove it from the manager's
                    // managedListeners array.  This ensures that if we listen using mon
                    // and then remove without using mun, the managedListeners array is updated
                    // accordingly, for example
                    //
                    //     manager.on(target, 'foo', fn);
                    //
                    //     target.un('foo', fn);
                    managedListeners = manager.managedListeners;
                    if (managedListeners) {
                        for (i = managedListeners.length; i--;) {
                            managedListener = managedListeners[i];
                            if (managedListener.item === me.observable && managedListener.ename === eventName && managedListener.fn === fn && managedListener.scope === scope) {
                                managedListeners.splice(i, 1);
                            }
                        }
                    }
                }
                if (observable.isElement) {
                    observable._getPublisher(eventName, options.translate === false).unsubscribe(observable, eventName, options.delegated !== false, options.capture);
                }
            }
            removed = true;
        }
        return removed;
    }
});

