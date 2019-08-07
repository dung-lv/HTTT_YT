using Autofac;
using Autofac.Core.Lifetime;
using System;
using System.Collections.Generic;
using System.Web.Http.Dependencies;

namespace APIBE
{
    /// <summary>
    /// Autofac implementation of the <see cref="IDependencyResolver"/> interface.
    /// </summary>
    public class AutofacDependencyResolver : IDependencyResolver
    {
        private bool _disposed;
        readonly ILifetimeScope _container;
        readonly IDependencyScope _rootDependencyScope;
        readonly Action<ContainerBuilder> _configurationAction;

        /// <summary>
        /// Initializes a new instance of the <see cref="AutofacDependencyScope"/> class.
        /// </summary>
        /// <param name="container">The container that nested lifetime scopes will be create from.</param>
        /// <param name="configurationAction">A configuration action that will execute during lifetime scope creation.</param>
        public AutofacDependencyResolver(ILifetimeScope container, Action<ContainerBuilder> configurationAction)
            : this(container)
        {
            if (configurationAction == null) throw new ArgumentNullException("configurationAction");

            _configurationAction = configurationAction;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AutofacDependencyScope"/> class.
        /// </summary>
        /// <param name="container">The container that nested lifetime scopes will be create from.</param>
        public AutofacDependencyResolver(ILifetimeScope container)
        {
            if (container == null) throw new ArgumentNullException("container");

            _container = container;
            _rootDependencyScope = new AutofacDependencyScope(container);
        }

        /// <summary>
        /// Finalizes an instance of the <see cref="AutofacDependencyScope"/> class.
        /// </summary>
        ~AutofacDependencyResolver()
        {
            Dispose(false);
        }

        /// <summary>
        /// Gets the root container provided to the dependency resolver.
        /// </summary>
        public ILifetimeScope Container
        {
            get { return _container; }
        }

        /// <summary>
        /// Try to get a service of the given type.
        /// </summary>
        /// <param name="serviceType">Type of service to request.</param>
        /// <returns>An instance of the service, or null if the service is not found.</returns>
        public object GetService(Type serviceType)
        {
            return _rootDependencyScope.GetService(serviceType);
        }

        /// <summary>
        /// Try to get a list of services of the given type.
        /// </summary>
        /// <param name="serviceType">ControllerType of services to request.</param>
        /// <returns>An enumeration (possibly empty) of the service.</returns>
        public IEnumerable<object> GetServices(Type serviceType)
        {
            return _rootDependencyScope.GetServices(serviceType);
        }

        /// <summary>
        /// Starts a resolution scope. Objects which are resolved in the given scope will belong to
        /// that scope, and when the scope is disposed, those objects are returned to the container.
        /// </summary>
        /// <returns>
        /// The dependency scope.
        /// </returns>
        public IDependencyScope BeginScope()
        {
            var lifetimeScope = _configurationAction == null
                                    ? _container.BeginLifetimeScope(MatchingScopeLifetimeTags.RequestLifetimeScopeTag)
                                    : _container.BeginLifetimeScope(MatchingScopeLifetimeTags.RequestLifetimeScopeTag, _configurationAction);
            return new AutofacDependencyScope(lifetimeScope);
        }

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    if (_rootDependencyScope != null)
                    {
                        _rootDependencyScope.Dispose();
                    }
                }
                _disposed = true;
            }
        }
    }
}