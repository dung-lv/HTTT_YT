using Autofac;
using System.Reflection;
using Autofac.Integration.WebApi;
using System.Web.Http;
using MT.Repository;

namespace APIBE
{
    public class AutofacConfig
    {
        public static IContainer Container { get; private set; }
        public static void Register(HttpConfiguration config)
        {
            var builder = new ContainerBuilder();
            // Register your Web API controllers.
            builder.RegisterApiControllers(Assembly.GetExecutingAssembly());

            builder.RegisterType<UnitOfWork>().As<IUnitOfWork>().InstancePerRequest();

            //Register repositories and services.            
            Container = builder.Build();
            GlobalConfiguration.Configuration.DependencyResolver = new AutofacWebApiDependencyResolver(Container);
        }
    }
}