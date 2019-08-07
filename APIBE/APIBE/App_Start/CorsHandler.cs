using MT.Library;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web;

namespace APIBE
{
    public class CorsHandler : DelegatingHandler
    {
        private const string Origin = "Origin";
        private const string AccessControlRequestMethod = "Access-Control-Request-Method";
        private const string AccessControlRequestHeaders = "Access-Control-Request-Headers";
        private const string AccessControlAllowOrigin = "Access-Control-Allow-Origin";
        private const string AccessControlAllowMethods = "Access-Control-Allow-Methods";
        private const string AccessControlAllowHeaders = "Access-Control-Allow-Headers";

        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            bool isCorsRequest = request.Headers.Contains(Origin);
            bool isPreflightRequest = request.Method == HttpMethod.Options;

            if (isCorsRequest)
            {
                var response = new HttpResponseMessage(HttpStatusCode.OK);
                string domains = UtilityExtensions.GetKeyAppSetting(Commonkey.Domains);
                string allowMethods = UtilityExtensions.GetKeyAppSetting(Commonkey.AllowMethods);
                string allowHeaders = UtilityExtensions.GetKeyAppSetting(Commonkey.AllowHeaders);
                if (isPreflightRequest)
                {
                    response.Headers.Add(AccessControlAllowOrigin, domains);

                    response.Headers.Add(AccessControlAllowMethods, allowMethods);

                    response.Headers.Add(AccessControlAllowHeaders, allowHeaders);

                    var tcs = new TaskCompletionSource<HttpResponseMessage>();
                    tcs.SetResult(response);
                    return tcs.Task;
                }
                return base.SendAsync(request, cancellationToken).ContinueWith(t =>
                {
                    HttpResponseMessage resp = t.Result;
                    resp.Headers.Add(AccessControlAllowOrigin, domains);
                    return resp;
                });
            }
            return base.SendAsync(request, cancellationToken);
        }
    }
}