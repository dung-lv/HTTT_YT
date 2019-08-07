using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.OAuth;
using APIBE.Models;
using MT.Repository;
using MT.Model;

namespace APIBE.Providers
{
    public class ApplicationOAuthProvider : OAuthAuthorizationServerProvider
    {
        private readonly string _publicClientId;

        public ApplicationOAuthProvider(string publicClientId)
        {
            if (publicClientId == null)
            {
                throw new ArgumentNullException("publicClientId");
            }

            _publicClientId = publicClientId;
        }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            var userManager = context.OwinContext.GetUserManager<ApplicationUserManager>();

            ApplicationUser user = await userManager.FindAsync(context.UserName, context.Password);

            if (user == null)
            {
                context.SetError("invalid_grant", "The user name or password is incorrect.");
                return;
            }

            ClaimsIdentity oAuthIdentity = await user.GenerateUserIdentityAsync(userManager,
               OAuthDefaults.AuthenticationType);
            ClaimsIdentity cookiesIdentity = await user.GenerateUserIdentityAsync(userManager,
                CookieAuthenticationDefaults.AuthenticationType);

            AuthenticationProperties properties = CreateProperties(user.UserName);
            AuthenticationTicket ticket = new AuthenticationTicket(oAuthIdentity, properties);
            context.Validated(ticket);
            context.Request.Context.Authentication.SignIn(cookiesIdentity);
        }

        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
            {
                context.AdditionalResponseParameters.Add(property.Key, property.Value);
            }

            return Task.FromResult<object>(null);
        }

        public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            // Resource owner password credentials does not provide a client ID.
            if (context.ClientId == null)
            {
                context.Validated();
            }

            return Task.FromResult<object>(null);
        }

        public override Task ValidateClientRedirectUri(OAuthValidateClientRedirectUriContext context)
        {
            if (context.ClientId == _publicClientId)
            {
                Uri expectedRootUri = new Uri(context.Request.Uri, "/");

                if (expectedRootUri.AbsoluteUri == context.RedirectUri)
                {
                    context.Validated();
                }
            }

            return Task.FromResult<object>(null);
        }

        public static AuthenticationProperties CreateProperties(string userName)
        {
            IUnitOfWork unitOfWork = new UnitOfWork();
            //IEmployeeRepository rep = unitOfWork.GetRepByName("Employee") as IEmployeeRepository;
            IAspNetUsersRepository rep = unitOfWork.GetRepByName("AspNetUsers") as IAspNetUsersRepository;
            //Employee emp = null;
            AspNetUsers emp = null;
            if (rep != null)
            {
                //emp = rep.GetEmpByUserName(userName);
                var users = rep.GetAllData() as List<AspNetUsers>;
                emp = users.Where(p => p.UserName == userName).FirstOrDefault();
            }

            IDictionary<string, string> data = new Dictionary<string, string>
            {
                { "userName", userName }
            };

            if (emp != null)
            {
                data.Add("FullName", emp.FullName == null ? "" : emp.FullName);
                data.Add("UserID", emp.UserID == 0 ? "-1" : emp.UserID.ToString());
                data.Add("GroupID", emp.GroupID.ToString());
                int reportYear = DateTime.Now.Year;
                data.Add("ReportYear", reportYear.ToString());

            }

            return new AuthenticationProperties(data);
        }
    }
}